const appInfo = {
  name: "MEMIL Python / AI Environment Catalog",
  version: "v3 prototype",
  branch: "v3-gui-prototype",
  status: "Static mockup"
};

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

function setupActionPreview() {
  const preview = document.getElementById("action-preview");

  if (!preview) {
    console.warn("Action preview element was not found.");
    return;
  }

  const buttons = document.querySelectorAll("[data-script]");

  if (buttons.length === 0) {
    console.warn("No action buttons with data-script were found.");
    return;
  }

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
    "./catalog/index.json",
    fallbackCatalogItems,
    "catalog-list"
  );

  loadJsonList(
    "./catalog/setup.json",
    fallbackSetupItems,
    "setup-list"
  );

  setupActionPreview();

  console.log(appInfo);
});