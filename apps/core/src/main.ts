import { registerRemotes } from '@module-federation/enhanced/runtime';

if(window.MFEManifest) {
    registerRemotes([
        { name: 'layout', entry:  window.MFEManifest.layoutManifest },
        { name: 'remote1', entry:  window.MFEManifest.remote1 },
        { name: 'remote2', entry:  window.MFEManifest.remote2 },
    ], { force: true });
}

import('./bootstrap').catch((err) => console.error(err));
