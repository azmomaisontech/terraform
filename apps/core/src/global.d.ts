declare global {
  interface Window {
    MFEManifest?: MFEManifest;
  }
}

type MFEManifest = {
  coreRemoteEntry: string;
  layoutManifest: string;
  remote1: string;
  remote2: string;
};

export { MFEManifest };
