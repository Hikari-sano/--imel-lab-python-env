const appInfo = {
  name: "MEMIL Python / AI Environment Catalog",
  version: "v3 prototype",
  branch: "v3-gui-prototype",
  status: "Static mockup"
};

const catalogItems = [
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

document.addEventListener("DOMContentLoaded", () => {

  const info = document.querySelector("#app-info p");

  if (info) {
    info.textContent =
      `${appInfo.version} | ${appInfo.branch} | ${appInfo.status}`;
  }

  const catalog = document.getElementById("catalog-list");

  if (catalog) {
    catalog.innerHTML = "";

    catalogItems.forEach(item => {
      const div = document.createElement("div");

      div.className = "item";

      div.innerHTML = `
        <h3>${item.title}</h3>
        <p>${item.description}</p>
      `;

      catalog.appendChild(div);
    });
  }

  console.log(appInfo);
});