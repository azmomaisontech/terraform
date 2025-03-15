
async function loadCore() {
    try {
        const response = await fetch(`/manifest.json`)
        const manifest = await response.json();
        window.MFEManifest = manifest;

        const { coreRemoteEntry } = manifest;
        const script = document.createElement("script");
        script.src = coreRemoteEntry;
        script.type = "module";
        script.onerror = () => console.error(`Failed to load Core from ${coreRemoteEntry}`);

        document.body.appendChild(script);
    } catch (error) {
        console.error("Error loading Core:", error);
    }
}

await loadCore();

export { };

