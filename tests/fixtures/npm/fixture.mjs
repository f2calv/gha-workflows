import { mkdirSync, writeFileSync } from 'node:fs';

const version = process.env.APP_VERSION;
const base = process.env.VITE_BASE_PATH;
if (!version || process.env.VITE_APP_VERSION !== version || base !== '/fixture/') {
  throw new Error('The workflow must forward version and hosting base to the build.');
}
mkdirSync('dist', { recursive: true });
writeFileSync('dist/index.html', '<!doctype html><title>Frontend workflow fixture</title>');
writeFileSync('dist/version.json', JSON.stringify({ version, base }));
