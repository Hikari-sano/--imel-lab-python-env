use serde::{Deserialize, Serialize};
use std::env;
use std::path::PathBuf;

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
    "tools/show-catalog.ps1",
];

const POWERSHELL_PROGRAM: &str = "powershell.exe";

const POWERSHELL_ARGUMENTS: &[&str] = &[
    "-NoProfile",
    "-ExecutionPolicy",
    "Bypass",
    "-File",
];

fn normalize_script_path(script: &str) -> String {
    let normalized = script.replace('\\', "/");

    if normalized.starts_with("./") {
        normalized.trim_start_matches("./").to_string()
    } else {
        normalized
    }
}

fn validate_runner_mode(mode: &str) -> Result<(), String> {
    match mode {
        "dryRun" => Ok(()),
        "preview" => Ok(()),
        "execute" => Err("Execute mode is locked. PowerShell execution is not enabled yet.".to_string()),
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

fn build_execution_plan_stdout(
    normalized_script: &str,
    script_full_path: &PathBuf,
    mode: &str,
) -> String {
    let executable_status = if EXECUTABLE_SCRIPTS.contains(&normalized_script) {
        "eligible-for-next-execution-phase"
    } else {
        "validated-but-not-enabled-for-execution"
    };

    format!(
        "Execution readiness plan generated.\nExecution mode: {}\nScript: {}\nResolved path: {}\nExecutable status: {}\nPlanned shell: {}\nPlanned arguments: {} [script path]\nPowerShell process was not started.",
        mode,
        normalized_script,
        script_full_path.display(),
        executable_status,
        POWERSHELL_PROGRAM,
        POWERSHELL_ARGUMENTS.join(" ")
    )
}

fn blocked_result(
    payload: CommandPayload,
    validation_status: &str,
    message: String,
) -> CommandResult {
    CommandResult {
        ok: false,
        executed: false,
        command: payload.command,
        label: payload.label,
        script: payload.script,
        normalized_script: "".to_string(),
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

#[tauri::command]
fn run_script(payload: CommandPayload) -> Result<CommandResult, String> {
    if payload.command != "run_script" {
        return Err(format!("Unsupported command: {}", payload.command));
    }

    if let Err(reason) = validate_runner_mode(&payload.mode) {
        return Ok(blocked_result(
            payload,
            "blocked-by-runner-mode",
            format!("Blocked by runner mode lock. {}", reason),
        ));
    }

    let normalized_script = match validate_script_path(&payload.script) {
        Ok(value) => value,
        Err(reason) => {
            return Ok(blocked_result(
                payload,
                "blocked-by-script-validator",
                format!("Blocked by Rust validator. {}", reason),
            ));
        }
    };

    let script_full_path = match validate_preflight(&normalized_script) {
        Ok(value) => value,
        Err(reason) => {
            return Ok(CommandResult {
                ok: false,
                executed: false,
                command: payload.command,
                label: payload.label,
                script: payload.script,
                normalized_script,
                allowed_by_policy: payload.allowed_by_policy,
                mode: payload.mode,
                runner: payload.runner,
                validation_status: "blocked-by-execution-preflight".to_string(),
                exit_code: None,
                stdout: "".to_string(),
                stderr: reason.clone(),
                message: format!("Blocked by execution readiness preflight. {}", reason),
            });
        }
    };

    if !payload.allowed_by_policy {
        return Ok(CommandResult {
            ok: false,
            executed: false,
            command: payload.command,
            label: payload.label,
            script: payload.script,
            normalized_script,
            allowed_by_policy: payload.allowed_by_policy,
            mode: payload.mode,
            runner: payload.runner,
            validation_status: "blocked-by-frontend-policy".to_string(),
            exit_code: None,
            stdout: "".to_string(),
            stderr: "Blocked by frontend script policy.".to_string(),
            message: "Blocked by frontend script policy. No script was executed.".to_string(),
        });
    }

    let execution_plan_stdout = build_execution_plan_stdout(
        &normalized_script,
        &script_full_path,
        &payload.mode,
    );

    Ok(CommandResult {
        ok: true,
        executed: false,
        command: payload.command,
        label: payload.label,
        script: payload.script,
        normalized_script,
        allowed_by_policy: payload.allowed_by_policy,
        mode: payload.mode,
        runner: payload.runner,
        validation_status: "approved-execution-readiness-plan".to_string(),
        exit_code: None,
        stdout: execution_plan_stdout,
        stderr: "".to_string(),
        message: "Execution readiness plan generated. PowerShell execution is still disabled.".to_string(),
    })
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![run_script])
        .run(tauri::generate_context!())
        .expect("error while running MEMIL catalog application");
}