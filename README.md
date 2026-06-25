# A Novel-Writing Pipeline for Claude Code

An opinionated, reusable pipeline for developing fiction with **Claude Code** as a *sharp,
skeptical critic-collaborator* — not a ghostwriter. It pairs a craft **framework**, a copyable
**project template**, a **questions mechanism**, and a **blind-spots watchlist** with an
**Obsidian + git** workflow. **The author writes 100% of the prose;** the agent researches, files,
organizes, and *pushes back*.

## What's here
- **`CLAUDE.md`** — the **agent**: a sharp / objective / skeptical critic that questions instincts,
  applies the blind-spots watchlist, and drives development with hard questions. It never writes prose.
- **`framework/the-framework.md`** — the **method**: concept → characters (Want/Need/Lie +
  opposition web) → setting → arc → diagnostic lenses → drafting pipeline.
- **`framework/novel-template/`** — a **copyable project skeleton** (premise / themes / characters /
  worldbuilding / plot / `questions.md` / `craft-lenses.md` / `workflow.md` / chapter meta-template).
- **`framework/blind-spots.md`** — a **watchlist** of common craft shortfalls, checked against every
  chapter and idea.
- **`ideas.md`** — an **idea intake** (a seed format) for half-baked novels.

## Architecture
- **Each novel = its own Obsidian vault + git repo**, scaffolded from the template (so `[[wikilinks]]`
  stay unambiguous per project and each book can have its own remote).
- **This repo = the meta-workspace** — it versions only the framework, agent, and intake.
- **Private content** (your idea seeds, personal writing tendencies, identity, and project
  premises) lives in a gitignored **`_private/`** folder, so this base stays share-worthy. Because
  it's gitignored it is **not backed up** to this repo's remote — if you want it backed up, keep
  `_private/` as its own separate private repo.

## Setup — clone it and make it yours
1. **Fork / clone** this repo, and point its `origin` at **your own** remote (don't push to someone
   else's). Each of your novels gets its *own* repo later, so this one only ever holds the pipeline.
2. **Open the folder in Claude Code.** On the first session the agent notices there's no `_private/`
   and **interviews you** to create it — your name, the git identity to commit your prose under,
   your GitHub namespace for new project repos, and your personal notes. Everything identifying you
   stays in `_private/` (gitignored); the tracked files stay generic.
3. **Start dumping ideas.** Seeds land in `_private/seeds.md`; develop them through the framework;
   promote a strong one into its own project repo (`cp -R framework/novel-template/ <Name>/`).
4. **Personalize freely.** As the agent learns your tics it grows `_private/blind-spots-personal.md`.
   None of that leaks: the meta-repo's `.gitignore` is an allow-list that tracks *only* the agent,
   framework, and idea-intake — your `_private/` and your project folders are ignored by default.

## How it works
1. **Open the folder in Claude Code** → it loads `CLAUDE.md` and becomes the critic-agent.
2. **Dump an idea** → it's seeded; **develop** it through the framework's layers (you talk; it files,
   critiques, and pushes questions).
3. **Promote** a strong idea → `cp -R framework/novel-template/ <Name>/`, `git init`, open as a vault.
4. **Draft** → prose lives in `drafts/ch-NNN/ch-NNN.md` (100% yours); after each chapter the agent
   runs a review routine (honest critique → chapter meta → index canon → continuity check → timeline
   → commit).

## Design principles
- **The author writes the prose (100%); the agent never writes or edits prose.** It researches,
  files, organizes, and critiques.
- **The agent is a critic, not a cheerleader** — it questions instincts, names blind spots, and
  pushes the hard questions (each project's `questions.md` tracks research / character / plot-arc /
  theme questions).
- **Frameworks are diagnostic, not generative** — used to find gaps, never to force-fit a story.
- **Themes stay uncomfortable / non-facile.**
- **Obsidian** (wikilinks, tag frontmatter, Dataview) + **git** (per project; offsite backup).

---
*A working pipeline I engineered and manage. Actual projects and personal notes live outside this
shared repo (`_private/`, gitignored).*
