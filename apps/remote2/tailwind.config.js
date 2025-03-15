import { join } from 'path';
import { fileURLToPath } from 'url';
import { createGlobPatternsForDependencies } from '@nx/react/tailwind';

/** Fix __dirname in ES Modules */
const __dirname = fileURLToPath(new URL('.', import.meta.url));

/** @type {import('tailwindcss').Config} */
const config = {
  content: [
    join(
        __dirname,
        '{src,pages,components,app}/**/*!(*.stories|*.spec).{ts,tsx,html}'
    ),
    ...createGlobPatternsForDependencies(__dirname),
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};

export default config;