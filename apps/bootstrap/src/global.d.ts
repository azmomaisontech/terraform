declare global {
  interface Window {
    MFEManifest?: MFEManifest;
  }
}

type MFEManifest = {
  coreRemoteEntry: string;
  layoutManifest: string;
  viewHomeManifest: string;
  viewPhoneNumbersManifest: string;
};

export { MFEManifest };
