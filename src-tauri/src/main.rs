use serde::{Deserialize, Serialize};
use std::env;
use std::path::PathBuf;
use std::process::{Command, Stdio};
use std::thread;
use std::time::{Duration, Instant};

#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
struct CommandPayload {
    command: String,
    label: String,
    script: String,
    allowed_by_policy: bool,
    mode: String,
    runner: String,
}

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
struct CommandResult {
    ok: bool,
    executed: bool,
    command: String,
    label: String,
    script: String,
    normalized_script: String,
    allowed_by_policy: bool,
    mode: String,
    runner: String,
    validation_status: String,
    exit_code: Option<i32>,
    stdout: String,
    stderr: String,
    message: String,
}

const ALLOWED_SCRIPTS: &[&str] = &[
    "tools/first-setup.ps1",
    "tools/install-vscode.ps1",
    "tools/setup-preset.ps1",
    "tools/show-catalog.ps1",
    "tools/health-check.ps1",
    "tools/share-env-to-ai.ps1",
    "tools/winpython-guide.ps1",
    "tools/setup-sam.ps1",
    "tools/run-sam-sample.ps1",
];

const EXECUTABLE_SCRIPTS: &[&str] = &[
    "tools/health-check.ps1",
];

const POWERSHELL_TIMEOUT_SECONDS: u64 = 30;

fn normalize_script_path(script: &str) -> String {
    let normalized = script.replace('\\', "/");

    if normalized.starts_with("./") {
        normalized.trim_start_matches("./").to_string()
    } else {
        normalized
    }
}

fn project_root() -> Result<PathBuf, String> {
    let current = env::current_dir()
        .map_err(|error| format!("Failed to read current directory: {}", error))?;

    if current.ends_with("src-tauri") {
        current
            .parent()
            .map(|path| path.to_path_buf())
            .ok_or_else(|| "Failed to resolve project root from src-tauri.".to_string())
    } else {
        Ok(current)
    }
}

fn build_script_full_path(normalized_script: &str) -> Result<PathBuf, String> {
    let root = project_root()?;
    Ok(root.join(normalized_script))
}

fn validate_runner_mode(mode: &str) -> Result<(), String> {
    match mode {
        "preview" => Ok(()),
        "dryRun" => Ok(()),
        "execute" => Ok(()),
        other => Err(format!("Unsupported execution mode: {}", other)),
    }
}

fn validate_script_path(script: &str) -> Result<String, String> {
    let normalized = normalize_script_path(script);

    if normalized.trim().is_empty() {
        return Err("Script path is empty.".to_string());
    }

    if normalized.contains('\0') {
        return Err("Script path contains a null character.".to_string());
    }

    if normalized.contains(':') {
        return Err("Absolute or drive-qualified paths are not allowed.".to_string());
    }

    if normalized.starts_with('/') {
        return Err("Absolute paths are not allowed.".to_string());
    }

    if normalized.contains("../") || normalized.contains("/..") || normalized == ".." {
        return Err("Parent directory traversal is not allowed.".to_string());
    }

    if !normalized.starts_with("tools/") {
        return Err("Only scripts under the tools folder are allowed.".to_string());
    }

    if !normalized.ends_with(".ps1") {
        return Err("Only PowerShell .ps1 scripts are allowed.".to_string());
    }

    if !ALLOWED_SCRIPTS.contains(&normalized.as_str()) {
        return Err(format!("Script is not in the allowlist: {}", normalized));
    }

    Ok(normalized)
}

fn validate_preflight(normalized_script: &str) -> Result<PathBuf, String> {
    let script_full_path = build_script_full_path(normalized_script)?;

    if !script_full_path.exists() {
        return Err(format!(
            "Script file does not exist: {}",
            script_full_path.display()
        ));
    }

    if !script_full_path.is_file() {
        return Err(format!(
            "Script path is not a file: {}",
            script_full_path.display()
        ));
    }

    Ok(script_full_path)
}

fn blocked_result(
    payload: CommandPayload,
    normalized_script: String,
    validation_status: &str,
    message: String,
) -> CommandResult {
    CommandResult {
        ok: false,
        executed: false,
        command: payload.command,
        label: payload.label,
        script: payload.script,
        normalized_script,
        allowed_by_policy: payload.allowed_by_policy,
        mode: payload.mode,
        runner: payload.runner,
        validation_status: validation_status.to_string(),
        exit_code: None,
        stdout: "".to_string(),
        stderr: message.clone(),
        message,
    }
}

fn dry_run_result(
    payload: CommandPayload,
    normalized_script: String,
    script_full_path: PathBuf,
) -> CommandResult {
    let executable_status = if EXECUTABLE_SCRIPTS.contains(&normalized_script.as_str()) {
        "eligible-for-controlled-execution"
    } else {
        "validated-but-not-enabled-for-execution"
    };

    let stdout = format!(
        "Dry-run only. No PowerShell process was started.\nScript: {}\nResolved path: {}\nExecutable status: {}\nPlanned shell: powershell.exe\nPlanned arguments: -NoProfile -ExecutionPolicy Bypass -File [script path]",
        normalized_script,
        script_full_path.display(),
        executable_status
    );

    CommandResult {
        ok: true,
        executed: false,
        command: payload.command,
        label: payload.label,
        script: payload.script,
        normalized_script,
        allowed_by_policy: payload.allowed_by_policy,
        mode: payload.mode,
        runner: payload.runner,
        validation_status: "approved-dry-run".to_string(),
        exit_code: None,
        stdout,
        stderr: "".to_string(),
        message: "Dry-run mode approved. Rust validator approved this script. PowerShell execution is not enabled yet.".to_string(),
    }
}

fn run_powershell_with_timeout(
    script_full_path: &PathBuf,
    root: &PathBuf,
) -> Result<(bool, Option<i32>, String, String, bool), String> {
    let mut child = Command::new("powershell.exe")
        .arg("-NoProfile")
        .arg("-ExecutionPolicy")
        .arg("Bypass")
        .arg("-File")
        .arg(script_full_path)
        .current_dir(root)
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .map_err(|error| format!("Failed to start PowerShell process: {}", error))?;

    let started_at = Instant::now();

    loop {
        match child.try_wait() {
            Ok(Some(_status)) => {
                let output = child
                    .wait_with_output()
                    .map_err(|error| format!("Failed to collect PowerShell output: {}", error))?;

                let success = output.status.success();
                let exit_code = output.status.code();
                let stdout = String::from_utf8_lossy(&output.stdout).to_string();
                let stderr = String::from_utf8_lossy(&output.stderr).to_string();

                return Ok((success, exit_code, stdout, stderr, false));
            }
            Ok(None) => {
                if started_at.elapsed() >= Duration::from_secs(POWERSHELL_TIMEOUT_SECONDS) {
                    let _ = child.kill();

                    let output = child
                        .wait_with_output()
                        .map_err(|error| {
                            format!("Failed to collect timed-out PowerShell output: {}", error)
                        })?;

                    let stdout = String::from_utf8_lossy(&output.stdout).to_string();
                    let mut stderr = String::from_utf8_lossy(&output.stderr).to_string();

                    if !stderr.trim().is_empty() {
                        stderr.push('\n');
                    }

                    stderr.push_str(&format!(
                        "PowerShell execution timed out after {} seconds.",
                        POWERSHELL_TIMEOUT_SECONDS
                    ));

                    return Ok((false, output.status.code(), stdout, stderr, true));
                }

                thread::sleep(Duration::from_millis(100));
            }
            Err(error) => {
                return Err(format!(
                    "Failed while waiting for PowerShell process: {}",
                    error
                ));
            }
        }
    }
}

fn execute_script(
    payload: CommandPayload,
    normalized_script: String,
    script_full_path: PathBuf,
) -> CommandResult {
    if !EXECUTABLE_SCRIPTS.contains(&normalized_script.as_str()) {
        let message = format!(
            "Execution blocked. This script is validated but not enabled for real execution yet: {}",
            normalized_script
        );

        return blocked_result(
            payload,
            normalized_script,
            "blocked-by-execution-allowlist",
            message,
        );
    }

    let root = match project_root() {
        Ok(value) => value,
        Err(reason) => {
            return blocked_result(
                payload,
                normalized_script,
                "blocked-by-project-root",
                reason,
            );
        }
    };

    let run_result = run_powershell_with_timeout(&script_full_path, &root);

    match run_result {
        Ok((success, exit_code, stdout, stderr, timed_out)) => CommandResult {
            ok: success,
            executed: true,
            command: payload.command,
            label: payload.label,
            script: payload.script,
            normalized_script,
            allowed_by_policy: payload.allowed_by_policy,
            mode: payload.mode,
            runner: payload.runner,
            validation_status: if timed_out {
                "executed-timeout".to_string()
            } else if success {
                "executed-success".to_string()
            } else {
                "executed-failed".to_string()
            },
            exit_code,
            stdout,
            stderr,
            message: if timed_out {
                format!(
                    "PowerShell script timed out after {} seconds.",
                    POWERSHELL_TIMEOUT_SECONDS
                )
            } else if success {
                "PowerShell script executed successfully.".to_string()
            } else {
                "PowerShell script finished with a non-zero exit code.".to_string()
            },
        },
        Err(error) => {
            let message = format!("Failed to start or monitor PowerShell process: {}", error);

            blocked_result(
                payload,
                normalized_script,
                "failed-to-start-or-monitor-powershell",
                message,
            )
        }
    }
}

#[tauri::command]
fn run_script(payload: CommandPayload) -> Result<CommandResult, String> {
    if payload.command != "run_script" {
        return Err(format!("Unsupported command: {}", payload.command));
    }

    if let Err(reason) = validate_runner_mode(&payload.mode) {
        return Ok(blocked_result(
            payload,
            "".to_string(),
            "blocked-by-runner-mode",
            format!("Blocked by runner mode. {}", reason),
        ));
    }

    let normalized_script = match validate_script_path(&payload.script) {
        Ok(value) => value,
        Err(reason) => {
            return Ok(blocked_result(
                payload,
                "".to_string(),
                "blocked-by-script-validator",
                format!("Blocked by Rust validator. {}", reason),
            ));
        }
    };

    let script_full_path = match validate_preflight(&normalized_script) {
        Ok(value) => value,
        Err(reason) => {
            return Ok(blocked_result(
                payload,
                normalized_script,
                "blocked-by-preflight",
                format!("Blocked by execution preflight. {}", reason),
            ));
        }
    };

    if !payload.allowed_by_policy {
        return Ok(blocked_result(
            payload,
            normalized_script,
            "blocked-by-frontend-policy",
            "Blocked by frontend script policy. No script was executed.".to_string(),
        ));
    }

    let mode = payload.mode.clone();

    match mode.as_str() {
        "preview" | "dryRun" => Ok(dry_run_result(payload, normalized_script, script_full_path)),
        "execute" => Ok(execute_script(payload, normalized_script, script_full_path)),
        other => Ok(blocked_result(
            payload,
            normalized_script,
            "blocked-by-runner-mode",
            format!("Unsupported execution mode: {}", other),
        )),
    }
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![run_script])
        .run(tauri::generate_context!())
        .expect("error while running MEMIL catalog application");
}