const appInfo = {
  name: "MEMIL Python / AI Environment Catalog",
  version: "v3 prototype",
  branch: "v3-gui-prototype",
  status: "Static mockup"
};

const fallbackDataSources = [
  {
    title: "catalog/index.json",
    description: "Stores AI / Tools catalog items such as Jupyter, YOLO, Whisper, Transformers, and SAM."
  },
  {
    title: "catalog/setup.json",
    description: "Stores recommended setup presets such as minimal, lab basic, vision AI, and audio AI."
  },
  {
    title: "catalog/installed.json",
    description: "Tracks installed tools and project environment status."
  },
  {
    title: "tools PowerShell scripts",
    description: "Provides the backend scripts that the future GUI should call."
  },
  {
    title: "Project virtual environments",
    description: "Each AI or tool project should have its own isolated Python environment."
  }
];

const fallbackCatalogItems = [
  {
    title: "Common Python packages",
    description: "Install basic packages for research and data analysis."
  },
  {
    title: "Jupyter / JupyterLab",
    description: "Use notebooks for experiments and data analysis."
  },
  {
    title: "YOLO / Ultralytics",
    description: "Detect objects in images and videos."
  },
  {
    title: "Whisper",
    description: "Transcribe audio files into text."
  },
  {
    title: "Hugging Face Transformers",
    description: "Try text AI and natural language processing."
  },
  {
    title: "SAM / Segment Anything",
    description: "Segment objects and regions in images using Meta Segment Anything. Experimental support."
  }
];

const fallbackSetupItems = [
  {
    title: "Minimal setup",
    description: "Basic setup for starting Python and VS Code."
  },
  {
    title: "Lab basic setup",
    description: "Recommended setup for research, classes, and data analysis."
  },
  {
    title: "Vision AI setup",
    description: "Setup for image recognition and object detection."
  },
  {
    title: "Audio AI setup",
    description: "Setup for speech recognition and transcription."
  }
];

const fallbackActions = [
  {
    label: "First setup",
    script: "tools/first-setup.ps1"
  },
  {
    label: "VS Code setup",
    script: "tools/install-vscode.ps1"
  },
  {
    label: "Recommended setup",
    script: "tools/setup-preset.ps1"
  },
  {
    label: "AI / Tools catalog",
    script: "tools/show-catalog.ps1"
  },
  {
    label: "Health check",
    script: "tools/health-check.ps1"
  },
  {
    label: "Create AI support report",
    script: "tools/share-env-to-ai.ps1"
  },
  {
    label: "WinPython setup guide",
    script: "tools/winpython-guide.ps1"
  },
  {
    label: "SAM setup",
    script: "tools/setup-sam.ps1"
  },
  {
    label: "Run SAM sample",
    script: "tools/run-sam-sample.ps1"
  }
];

const fallbackStatusCards = [
  {
    label: "WinPython",
    value: "Not detected",
    status: "warn"
  },
  {
    label: "VS Code",
    value: "Detected",
    status: "ok"
  },
  {
    label: "Catalog items",
    value: "6",
    status: "normal"
  },
  {
    label: "Mode",
    value: "WinPython only",
    status: "normal"
  }
];

const fallbackRunnerStatus = {
  mode: "preview",
  backend: "planned-tauri",
  canExecuteScripts: false,
  description: "This GUI prototype only previews future PowerShell script mappings. It does not execute scripts yet.",
  futureRuntime: "Tauri command bridge",
  scriptRoot: "tools"
};

const fallbackScriptPolicy = {
  mode: "allowlist",
  canExecuteScripts: false,
  description: "Only scripts listed in this policy should be executable when the future Tauri bridge is implemented.",
  allowedScripts: [
    {
      label: "First setup",
      script: "tools/first-setup.ps1",
      enabled: true
    },
    {
      label: "VS Code setup",
      script: "tools/install-vscode.ps1",
      enabled: true
    },
    {
      label: "Recommended setup",
      script: "tools/setup-preset.ps1",
      enabled: true
    },
    {
      label: "AI / Tools catalog",
      script: "tools/show-catalog.ps1",
      enabled: true
    },
    {
      label: "Health check",
      script: "tools/health-check.ps1",
      enabled: true
    },
    {
      label: "Create AI support report",
      script: "tools/share-env-to-ai.ps1",
      enabled: true
    },
    {
      label: "WinPython setup guide",
      script: "tools/winpython-guide.ps1",
      enabled: true
    },
    {
      label: "SAM setup",
      script: "tools/setup-sam.ps1",
      enabled: true
    },
    {
      label: "Run SAM sample",
      script: "tools/run-sam-sample.ps1",
      enabled: true
    }
  ]
};

let activeScriptPolicy = fallbackScriptPolicy;

const executionLogEntries = [];
let lastCommandPayload = null;

function renderItems(containerId, items) {
  const container = document.getElementById(containerId);

  if (!container) {
    return;
  }

  container.innerHTML = "";

  items.forEach((item) => {
    const div = document.createElement("div");
    div.className = "item";

    div.innerHTML = `
      <h3>${item.title}</h3>
      <p>${item.description}</p>
    `;

    container.appendChild(div);
  });
}

function renderStatusCards(items) {
  const container = document.getElementById("status-cards");

  if (!container) {
    return;
  }

  container.innerHTML = "";

  items.forEach((item) => {
    const div = document.createElement("div");
    div.className = "card";

    let statusClass = "";

    if (item.status === "ok") {
      statusClass = "ok";
    }

    if (item.status === "warn") {
      statusClass = "warn";
    }

    div.innerHTML = `
      <small>${item.label}</small>
      <strong class="${statusClass}">${item.value}</strong>
    `;

    container.appendChild(div);
  });
}

function renderActions(actions) {
  const container = document.getElementById("actions-list");

  if (!container) {
    return;
  }

  container.innerHTML = "";

  actions.forEach((action) => {
    const button = document.createElement("button");

    button.textContent = action.label;
    button.setAttribute("data-script", action.script);

    container.appendChild(button);
  });

  setupActionPreview();
}

function renderRunnerStatus(status) {
  const container = document.getElementById("runner-status");

  if (!container) {
    return;
  }

  const executionText = status.canExecuteScripts
    ? "Enabled"
    : "Disabled in this prototype";

  container.innerHTML = `
    <h3>Script execution: ${executionText}</h3>
    <p>${status.description}</p>
    <p><strong>Backend:</strong> ${status.backend}</p>
    <p><strong>Future runtime:</strong> ${status.futureRuntime}</p>
    <p><strong>Script root:</strong> ${status.scriptRoot}</p>
  `;
}

function renderScriptPolicy(policy) {
  const container = document.getElementById("script-policy");

  if (!container) {
    return;
  }

  const allowedItems = policy.allowedScripts
    .map((item) => {
      const statusText = item.enabled ? "Allowed" : "Disabled";

      return `
        <div class="item">
          <h3>${item.label}</h3>
          <p><strong>Script:</strong> <code>${item.script}</code></p>
          <p><strong>Status:</strong> ${statusText}</p>
        </div>
      `;
    })
    .join("");

  container.innerHTML = `
    <h3>Policy mode: ${policy.mode}</h3>
    <p>${policy.description}</p>
    <p><strong>Script execution now:</strong> Disabled in this prototype</p>
    ${allowedItems}
  `;
}

function renderCommandPayload(payload) {
  const container = document.getElementById("command-payload");

  if (!container) {
    return;
  }

  if (!payload) {
    container.innerHTML = `
      <h3>No command payload yet</h3>
      <p>Select a Quick Action button to preview the future Tauri command payload.</p>
    `;
    return;
  }

  container.innerHTML = `
    <h3>Planned Tauri Command</h3>
    <p><strong>Command:</strong> <code>${payload.command}</code></p>
    <p><strong>Label:</strong> ${payload.label}</p>
    <p><strong>Script:</strong> <code>${payload.script}</code></p>
    <p><strong>Allowed by policy:</strong> ${payload.allowedByPolicy}</p>
    <p><strong>Execution mode:</strong> ${payload.mode}</p>
    <p><strong>Runner:</strong> ${payload.runner}</p>
  `;
}

function renderExecutionLog() {
  const container = document.getElementById("execution-log");

  if (!container) {
    return;
  }

  if (executionLogEntries.length === 0) {
    container.innerHTML = `
      <h3>No execution log yet</h3>
      <p>Select a Quick Action button to add a preview log entry.</p>
    `;
    return;
  }

  const items = executionLogEntries
    .map((entry) => {
      return `
        <div class="item">
          <h3>${entry.label}</h3>
          <p><strong>Script:</strong> <code>${entry.script}</code></p>
          <p><strong>Mode:</strong> ${entry.mode}</p>
          <p><strong>Policy:</strong> ${entry.policy}</p>
          <p><strong>Bridge:</strong> ${entry.bridge}</p>
          <p><strong>Time:</strong> ${entry.time}</p>
        </div>
      `;
    })
    .join("");

  container.innerHTML = items;
}

function isScriptAllowed(script) {
  return activeScriptPolicy.allowedScripts.some((item) => {
    return item.script === script && item.enabled;
  });
}

function createCommandPayload(label, script) {
  const allowed = isScriptAllowed(script);

  return {
    command: "run_script",
    label,
    script,
    allowedByPolicy: allowed,
    mode: "preview",
    runner: "planned-tauri"
  };
}

async function dispatchCommandPayload(payload) {
  const tauriInvoke = window.__TAURI__?.core?.invoke;

  if (!tauriInvoke) {
    return {
      ok: false,
      executed: false,
      message: "Tauri bridge is not available. Running in static preview mode."
    };
  }

  try {
    const result = await tauriInvoke("run_script", {
      payload
    });

    return result;
  } catch (error) {
    return {
      ok: false,
      executed: false,
      message: `Tauri bridge error: ${error}`
    };
  }
}

async function addExecutionLogEntry(label, script) {
  const now = new Date();
  const payload = createCommandPayload(label, script);

  lastCommandPayload = payload;

  const dispatchResult = await dispatchCommandPayload(payload);

  executionLogEntries.unshift({
    label,
    script,
    mode: "preview only",
    policy: payload.allowedByPolicy ? "allowed by policy" : "blocked by policy",
    bridge: dispatchResult.message,
    time: now.toLocaleString()
  });

  renderCommandPayload(lastCommandPayload);
  renderExecutionLog();
}

function setupExecutionLogControls() {
  const clearButton = document.getElementById("clear-log-button");

  if (!clearButton) {
    return;
  }

  clearButton.addEventListener("click", () => {
    executionLogEntries.length = 0;
    lastCommandPayload = null;
    renderCommandPayload(lastCommandPayload);
    renderExecutionLog();
  });
}

async function loadJsonList(path, fallbackItems, containerId) {
  try {
    const response = await fetch(path);

    if (!response.ok) {
      throw new Error(`Failed to load ${path}: ${response.status}`);
    }

    const items = await response.json();

    renderItems(containerId, items);

    console.log(`Loaded: ${path}`);
  } catch (error) {
    console.warn(`JSON loading failed: ${path}. Using fallback data.`, error);

    renderItems(containerId, fallbackItems);
  }
}

async function loadStatusCards() {
  try {
    const response = await fetch("./catalog/status.json");

    if (!response.ok) {
      throw new Error(`Failed to load status cards: ${response.status}`);
    }

    const items = await response.json();

    renderStatusCards(items);

    console.log("Loaded: ./catalog/status.json");
  } catch (error) {
    console.warn("Status JSON loading failed. Using fallback data.", error);

    renderStatusCards(fallbackStatusCards);
  }
}

async function loadActions() {
  try {
    const response = await fetch("./catalog/actions.json");

    if (!response.ok) {
      throw new Error(`Failed to load actions: ${response.status}`);
    }

    const actions = await response.json();

    renderActions(actions);

    console.log("Loaded: ./catalog/actions.json");
  } catch (error) {
    console.warn("Actions JSON loading failed. Using fallback data.", error);

    renderActions(fallbackActions);
  }
}

async function loadRunnerStatus() {
  try {
    const response = await fetch("./catalog/runner.json");

    if (!response.ok) {
      throw new Error(`Failed to load runner status: ${response.status}`);
    }

    const status = await response.json();

    renderRunnerStatus(status);

    console.log("Loaded: ./catalog/runner.json");
  } catch (error) {
    console.warn("Runner status loading failed. Using fallback data.", error);

    renderRunnerStatus(fallbackRunnerStatus);
  }
}

async function loadScriptPolicy() {
  try {
    const response = await fetch("./catalog/script-policy.json");

    if (!response.ok) {
      throw new Error(`Failed to load script policy: ${response.status}`);
    }

    const policy = await response.json();

    activeScriptPolicy = policy;

    renderScriptPolicy(policy);

    console.log("Loaded: ./catalog/script-policy.json");
  } catch (error) {
    console.warn("Script policy loading failed. Using fallback data.", error);

    activeScriptPolicy = fallbackScriptPolicy;

    renderScriptPolicy(fallbackScriptPolicy);
  }
}

function setupActionPreview() {
  const preview = document.getElementById("action-preview");

  if (!preview) {
    return;
  }

  const buttons = document.querySelectorAll("[data-script]");

  buttons.forEach((button) => {
    button.addEventListener("click", () => {
      const label = button.textContent.trim();
      const script = button.getAttribute("data-script");

      preview.innerHTML = `
        <h3>${label}</h3>
        <p>Future script mapping:</p>
        <p><code>${script}</code></p>
        <p>This GUI prototype does not execute PowerShell scripts yet.</p>
      `;

      addExecutionLogEntry(label, script);
    });
  });
}

document.addEventListener("DOMContentLoaded", () => {
  const info = document.querySelector("#app-info p");

  if (info) {
    info.textContent =
      `${appInfo.version} | ${appInfo.branch} | ${appInfo.status}`;
  }

  loadJsonList(
    "./catalog/data-sources.json",
    fallbackDataSources,
    "data-sources-list"
  );

  loadStatusCards();

  loadJsonList(
    "./catalog/index.json",
    fallbackCatalogItems,
    "catalog-list"
  );

  loadJsonList(
    "./catalog/setup.json",
    fallbackSetupItems,
    "setup-list"
  );

  loadActions();

  loadRunnerStatus();

  loadScriptPolicy();

  setupExecutionLogControls();
  renderCommandPayload(lastCommandPayload);
  renderExecutionLog();

  console.log(appInfo);
});