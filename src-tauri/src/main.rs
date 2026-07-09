use serde::{Deserialize, Serialize};

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
    allowed_by_policy: bool,
    mode: String,
    runner: String,
    message: String,
}

#[tauri::command]
fn run_script(payload: CommandPayload) -> Result<CommandResult, String> {
    if payload.command != "run_script" {
        return Err(format!("Unsupported command: {}", payload.command));
    }

    if !payload.allowed_by_policy {
        return Ok(CommandResult {
            ok: false,
            executed: false,
            command: payload.command,
            label: payload.label,
            script: payload.script,
            allowed_by_policy: payload.allowed_by_policy,
            mode: payload.mode,
            runner: payload.runner,
            message: "Blocked by script policy. No script was executed.".to_string(),
        });
    }

    Ok(CommandResult {
        ok: true,
        executed: false,
        command: payload.command,
        label: payload.label,
        script: payload.script,
        allowed_by_policy: payload.allowed_by_policy,
        mode: payload.mode,
        runner: payload.runner,
        message: "Dry-run successful. PowerShell execution is not enabled yet.".to_string(),
    })
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![run_script])
        .run(tauri::generate_context!())
        .expect("error while running MEMIL catalog application");
}