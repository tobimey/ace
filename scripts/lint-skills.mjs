#!/usr/bin/env node
// Static integrity linter for Ace skills under skills/.
// Checks:
//   1. Every skills/<dir>/SKILL.md has valid frontmatter with name === <dir> and non-empty description.
//   2. Every relative Markdown link in skills/**/*.md resolves to an existing file or directory.
//   3. Every skill listed under "## Requires" exists under skills/<name>/SKILL.md.
//   4. Every backticked ace-* skill referenced in skills/ace-mode/SKILL.md playbooks exists.

import fs from 'node:fs';
import path from 'node:path';

const repoRoot = process.cwd();
const skillsDir = path.join(repoRoot, 'skills');
const errors = [];

function walk(dir) {
  const results = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...walk(full));
    } else {
      results.push(full);
    }
  }
  return results;
}

function rel(p) {
  return path.relative(repoRoot, p);
}

function stripCodeFences(content) {
  return content.replace(/```[\s\S]*?```/g, (match) =>
    match.replace(/[^\n]/g, ' ')
  );
}

const skillDirs = fs
  .readdirSync(skillsDir, { withFileTypes: true })
  .filter((d) => d.isDirectory())
  .map((d) => d.name)
  .sort();

const validSkills = new Set(skillDirs);

// 1 & 3. Frontmatter and ## Requires checks
for (const dirName of skillDirs) {
  const skillFile = path.join(skillsDir, dirName, 'SKILL.md');
  if (!fs.existsSync(skillFile)) {
    errors.push(`${rel(path.join(skillsDir, dirName))}: missing SKILL.md`);
    continue;
  }

  const content = fs.readFileSync(skillFile, 'utf8');
  const fmMatch = content.match(/^---\n([\s\S]*?)\n---/);
  if (!fmMatch) {
    errors.push(`${rel(skillFile)}: missing YAML frontmatter`);
  } else {
    const fm = fmMatch[1];
    const nameMatch = fm.match(/^name:\s*(.+)$/m);
    const descMatch = fm.match(/^description:\s*(.+)$/m);
    const name = nameMatch ? nameMatch[1].trim().replace(/^["']|["']$/g, '') : '';
    const desc = descMatch ? descMatch[1].trim().replace(/^["']|["']$/g, '') : '';
    if (name !== dirName) {
      errors.push(`${rel(skillFile)}: frontmatter name "${name}" does not match folder "${dirName}"`);
    }
    if (!desc) {
      errors.push(`${rel(skillFile)}: frontmatter description is empty`);
    }
  }

  const reqMatch = content.match(/^## Requires\s*\n([\s\S]*?)(?=\n## |\n*$)/m);
  if (reqMatch) {
    for (const line of reqMatch[1].split('\n')) {
      const m = line.match(/^\s*-\s*`(ace-[a-z0-9-]+)`/);
      if (m && !validSkills.has(m[1])) {
        errors.push(`${rel(skillFile)}: Requires unknown skill "${m[1]}"`);
      }
    }
  }
}

// 2. Relative Markdown links in all skills/**/*.md
const mdFiles = walk(skillsDir).filter((f) => f.endsWith('.md'));
const linkRe = /(?<!!)\[[^\]]*\]\(([^)]+)\)/g;

for (const file of mdFiles) {
  const content = stripCodeFences(fs.readFileSync(file, 'utf8'));
  const lines = content.split('\n');
  lines.forEach((line, idx) => {
    let match;
    while ((match = linkRe.exec(line)) !== null) {
      const rawTarget = match[1].trim().split(/\s+/)[0];
      if (
        !rawTarget ||
        rawTarget.startsWith('http://') ||
        rawTarget.startsWith('https://') ||
        rawTarget.startsWith('#') ||
        rawTarget.startsWith('mailto:')
      ) {
        continue;
      }
      const targetPath = rawTarget.split('#')[0];
      if (!targetPath) continue;
      const resolved = path.resolve(path.dirname(file), targetPath);
      if (!fs.existsSync(resolved)) {
        errors.push(`${rel(file)}:${idx + 1}: broken link "${rawTarget}"`);
      }
    }
  });
}

// 4. Playbook skill references in skills/ace-mode/SKILL.md
const modeFile = path.join(skillsDir, 'ace-mode', 'SKILL.md');
if (fs.existsSync(modeFile)) {
  const modeContent = fs.readFileSync(modeFile, 'utf8');
  const pbMatch = modeContent.match(/^## Playbooks\s*\n([\s\S]*)$/m);
  if (pbMatch) {
    const skillRefRe = /`(ace-[a-z0-9-]+)(?:\/[^`]+)?`/g;
    let match;
    while ((match = skillRefRe.exec(pbMatch[1])) !== null) {
      if (!validSkills.has(match[1])) {
        errors.push(`${rel(modeFile)}: Playbooks references unknown skill "${match[1]}"`);
      }
    }
  }
}

if (errors.length > 0) {
  console.error(`lint-skills failed with ${errors.length} error(s):`);
  for (const err of errors) {
    console.error(`  - ${err}`);
  }
  process.exit(1);
}

console.log(`lint-skills passed (${skillDirs.length} skills, ${mdFiles.length} markdown files checked).`);
