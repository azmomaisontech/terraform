import { defineConfig } from '@rsbuild/core';

export default defineConfig({
    html: {
        template: './src/index.html',
    },
    plugins: [],
    source: {
        entry: {
            index: './src/main.ts',
        },
        tsconfigPath: './tsconfig.app.json',
    },
    server: {
        port: 4200,
    },
    output: {
        copy: [{ from: './src/assets' }],
        target: 'web',
        distPath: {
            root: 'dist',
        },
    },
});