import { existsSync } from 'fs';
import { readFile, writeFile } from 'fs/promises';
import { resolve } from 'path';

async function main() {
  const { TEMPLATE, OUTPUT, MATCH, REPLACE } = process.env;
  const template_file = resolve(__dirname, String(TEMPLATE));
  const output_file = resolve(__dirname, String(OUTPUT));

  let should_exit = false;

  if (!TEMPLATE) {
    console.error('TEMPLATE is required');
    should_exit = true;
  }

  if (!OUTPUT) {
    console.error('OUTPUT is required');
    should_exit = true;
  }

  if (!MATCH) {
    console.error('MATCH is required');
    should_exit = true;
  }

  if (!REPLACE) {
    console.error('REPLACE is required');
    should_exit = true;
  }

  if (!existsSync(template_file)) {
    console.error(`File not found: ${TEMPLATE} does not exist`);
    should_exit = true;
  }

  if (should_exit) {
    process.exit(1);
  }

  const content = await readFile(resolve(template_file), 'utf-8');
  const match = String(MATCH);
  const replace = String(REPLACE);
  const replaced_content = content.replaceAll(match, replace);

  if (replaced_content.includes(replace)) {
    await writeFile(output_file, replaced_content, 'utf-8');
    console.log(
      `Replaced "${match}" with "${replace}" in "${template_file}" and saved to "${output_file}"`,
    );
  } else {
    console.error(
      `Failed to replace "${match}" with "${replace}" in "${template_file}"`,
    );
    process.exit(1);
  }
}

void main();
