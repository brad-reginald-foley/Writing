---
tags:
  - meta
---

# Writing workflow & conventions

## The hard boundary
**The assistant NEVER writes or edits prose.** Prose `.md` files under `drafts/ch-*/` are 100%
the author's. The assistant touches only meta/index/doc files; reviews are *critique*, logged
in the chapter's `.meta.md`.

## File conventions
- **Prose:** Markdown (`.md`), one file per chapter: `drafts/ch-NNN/ch-NNN.md`; start with an
  H1 `# Title`; scene break = a line with only `* * *`.
- **Stable filenames** (`ch-NNN` = creation order, immutable). Reading order / act / POV /
  status live in the **meta frontmatter** — reorder by editing numbers, never renaming, so
  `[[wikilinks]]` never break.
- **Folder per chapter:** prose + `ch-NNN.meta.md` (copy `drafts/_meta-template.md`) + optional
  `fragments/`.

## Tooling
- **Obsidian** vault; `[[wikilinks]]`; tag frontmatter; **Dataview** (chapters/timeline tables
  auto-build from meta frontmatter). **git** = version/backup; push to a private remote.
- Prose → LaTeX later via **pandoc**; the chapters index doubles as the compile manifest.

## Per-chapter routine (assistant, after the author writes/edits a chapter)
1. Read the prose. 2. **Honest review** (craft lenses) — in chat + logged in the meta.
3. Create/update `ch-NNN.meta.md`. 4. Index new canon → `continuity.md` (+ entity notes).
5. Continuity-check (contradictions; who-knows-what-when). 6. Add events to `timeline.md`.
7. Ensure the row in `chapters.md`. 8. Commit.

## Git attribution
Prose commits → author's identity, **no Claude trailer**. Scaffolding/notes commits → tagged.
