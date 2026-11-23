import { strict as assert } from 'node:assert';
import { test } from 'node:test';

test('build environment supplies the version and hosting base', () => {
  assert.ok(process.env.APP_VERSION);
  assert.equal(process.env.VITE_APP_VERSION, process.env.APP_VERSION);
  assert.equal(process.env.VITE_BASE_PATH, '/fixture/');
});
