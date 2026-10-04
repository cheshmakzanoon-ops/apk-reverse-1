'use strict';
// Independent Khronos validator. Never execute scripts or fetch external resources.
const fs = require('node:fs');
const path = require('node:path');
const validator = require(process.env.GLTF_VALIDATOR_MODULE || 'gltf-validator');

async function main() {
  const [input, output] = process.argv.slice(2);
  if (!input || !output) throw new Error('Usage: validate_glb.cjs model.glb report.json');
  const report = await validator.validateBytes(new Uint8Array(fs.readFileSync(input)), {
    uri: path.basename(input), maxIssues: 1000,
    externalResourceFunction: () => Promise.reject(new Error('External resources are forbidden'))
  });
  fs.writeFileSync(output, JSON.stringify(report, null, 2));
  console.log(`${path.basename(input)}: ${report.issues.numErrors} errors, ${report.issues.numWarnings} warnings`);
  process.exitCode = report.issues.numErrors ? 1 : 0;
}
main().catch(error => { console.error(error.message); process.exitCode = 2; });
