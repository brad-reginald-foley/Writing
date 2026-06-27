# _private — bootstrap & control (agent instructions)

This is the author's **private** repo: personal notes + the bootstrap manifest for the whole writing
workspace. It's gitignored by the **Writing** meta-repo and lives at `…/Writing/_private`.

- **Identity & preferences:** `author.md` (read first)
- **Repo manifest (pipeline + every book):** `repos.md`
- **Rebuild on a new machine:** `bootstrap.md`
- **Personal:** `seeds.md` · `blind-spots-personal.md` · `projects.md`

## If you're launched here on a fresh machine
Check whether the workspace exists (a `Writing/framework/` and sibling book folders). **If not, offer
to run `bootstrap.md`** — clone the pipeline repo, this repo (→ `_private`), and each book per
`repos.md` (needs git/`gh` auth). Then hand off to the pipeline agent at `Writing/CLAUDE.md`.

## Keep current
When a book is added/renamed or a remote changes, **update `repos.md`** — it's the single source of
truth for "what exists and where it lives."
