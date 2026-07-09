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

function renderCatalog(items) {
  const catalog = document.getElementById("catalog-list");

  if (!catalog) {
    return;
  }

  catalog.innerHTML = "";

  items.forEach((item) => {
    const div = document.createElement("div");

    div.className = "item";

    div.innerHTML = `
      <h3>${item.title}</h3>
      <p>${item.description}</p>
    `;

    catalog.appendChild(div);
  });
}

async function loadCatalog() {
  try {
    const response = await fetch("./catalog/index.json");

    if (!response.ok) {
      throw new Error(`Failed to load catalog: ${response.status}`);
    }

    const items = await response.json();

    renderCatalog(items);

    console.log("Catalog loaded from app/catalog/index.json");
  } catch (error) {
    console.warn("Catalog JSON loading failed. Using fallback data.", error);

    renderCatalog(fallbackCatalogItems);
  }
}

document.addEventListener("DOMContentLoaded", () => {
  const info = document.querySelector("#app-info p");

  if (info) {
    info.textContent =
      `${appInfo.version} | ${appInfo.branch} | ${appInfo.status}`;
  }

  loadCatalog();

  console.log(appInfo);
});