import { ModuleFederationConfig } from '@nx/module-federation';

const config: ModuleFederationConfig = {
  name: 'remote2',
  exposes: {
    './Module': './src/remote-entry.ts',
  },
  shared: (libraryName, sharedConfig) => {
    if (libraryName === '@twilio-paste/core') {
      return {
        ...sharedConfig,
        singleton: true,
        strictVersion: true,
        requiredVersion: '^20.0.0',
      };
    } else {
      return {
        ...sharedConfig,
      };
    }
  },
};

/**
 * Nx requires a default export of the config to allow correct resolution of the module federation graph.
 **/
export default config;
