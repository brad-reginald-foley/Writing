---
tags:
  - meta
---

# Writing workflow & conventions

*The generic per-chapter drafting routine + conventions. Lives **once** here in `framework/`; each project references it (`../framework/workflow.md`) and never copies it. Project-specific structure — act labels, POV rules — lives in that project's own files (e.g. `plot/arc.md`), not here.*

## The hard boundary
**The assistant NEVER writes or edits prose.** The `.md` files under `drafts/ch-*/` that contain story prose are 100% the author's own. The assistant only touches **meta / index / doc `.md` files** (everything else). Reviews are *critique*, delivered in chat and logged in the chapter's `.meta.md` — never edits to the prose.

## File conventions
- **Prose:** Markdown (`.md`), plain. One file per chapter: `drafts/ch-NNN/ch-NNN.md`.
  - Start each prose file with an H1 chapter title: `# Title` (pandoc/LaTeX recognize this).
  - **Scene break:** a line containing only `* * *` (stable across pandoc → LaTeX).
- **Filenames are STABLE** (`ch-NNN` = creation order, immutable). Reading order, act, POV, and status live in the **meta frontmatter** — reorder by editing numbers, never renaming, so `[[wikilinks]]` never break.
- **Folder per chapter** holds the prose, its `.meta.md`, and an optional `fragments/` for exploratory/maybe-cut material (write twice as much; assess later).
- **Meta file** (`ch-NNN.meta.md`) is the queryable record (frontmatter + summary + what-it-does + canon + flags + links + the assistant's dated review). Copy `drafts/_meta-template.md`.

## Tooling
- **Obsidian** vault; links are filename-based `[[wikilinks]]`.
- **Dataview** plugin (enabled): [[chapters]], [[timeline]] auto-build their tables from the meta frontmatter. **Templater** optional (auto-fill the meta template).
- **git** is the version/backup layer. Avoid layering Dropbox/iCloud sync on the vault (many-small-files conflict risk). Push to a private remote for offsite backup.
- Prose → LaTeX later via **pandoc**; [[chapters]] order doubles as the compile manifest.

## Per-chapter routine (assistant runs this after the author writes/edits a chapter)
1. **Read** the prose (`ch-NNN.md`).
2. **Review** — honest, unvarnished critique (craft lenses in `../framework/craft-lenses.md`; prose, structure, character, pacing, continuity). Delivered in chat + logged in the meta's *Assistant review* section, dated.
3. **Meta** — create/update `ch-NNN.meta.md` (summary, what-it-does, beats, links-out).
4. **Index canon** — new facts/characters/places → [[continuity]] (+ create entity notes as needed). Scan prose for names not yet captured (manual "unlinked mentions").
5. **Continuity check** — flag contradictions with established canon and the who-knows-what-when ledger in [[continuity]]. Set `continuity_checked` in meta.
6. **Timeline** — add the chapter's in-world events/date to [[timeline]].
7. **Chapters index** — ensure the row appears/updates in [[chapters]] (Dataview auto).
8. **Commit** (git) — see attribution below.

## Git attribution
- **Prose commits** → the author's own git identity, **no Claude co-author trailer** (the writing is 100% theirs).
- **Scaffolding/doc/meta commits** (assistant's work) → tagged with the Claude co-author trailer.
- Clear messages: `ch-001: draft`, `meta+continuity: ch-001`, etc.

## Status vocabulary (meta `status`)
`draft` · `revising` · `canon` (locked) · `exploratory` (might not survive) · `cut` · `fragment` (a scene/beat, not a full chapter).
