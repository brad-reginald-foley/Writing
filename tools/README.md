# tools/ — workspace maintenance for the super-repo

`Writing/` is a **super-repo of nested independent repos**: it gitignores `_private/` and every
book folder, each of which is *its own* git repo. **Consequence:** git run inside `Writing/` is
blind to the nested repos — a dirty, unpushed, or behind subfolder will not show up in
`git status` here. These tools + rules exist so nothing in a subfolder is ever missed.

> **Not submodules — on purpose.** Submodules would record each book's path and remote URL in a
> tracked `.gitmodules`, leaking the existence of private books into this public repo. We keep the
> repos independent and coordinate by convention + this tool instead.

## The tool
`sync.ps1` (Windows/pwsh) and `sync.sh` (Linux/macOS) are twins. They discover every repo by
scanning for `.git` dirs (new books are picked up automatically) and report on all of them at once.

| Command | Does |
|---|---|
| `sync status` *(default)* | One table for all repos + warnings: dirty / unpushed / behind / no-upstream / **privacy leak** / **unregistered**. Read-only. |
| `sync pull` | Fetch + **fast-forward-only** pull across all repos. |
| `sync push` | Push every repo that is **ahead** of its upstream. The tool pushes **only** on this explicit command — never on its own. |
| `sync check` | Same as status but exits non-zero if any warning fires (for hooks/CI). |

```
pwsh tools/sync.ps1            # or:  bash tools/sync.sh
pwsh tools/sync.ps1 pull
pwsh tools/sync.ps1 push
```

Two warnings are workspace-integrity guards, not just git state:
- **PRIVACY** — the super-repo tracks a top-level path outside the allow-list (`.gitignore`,
  `CLAUDE.md`, `README.md`, `ideas.md`, `framework`, `tools`). Something personal may be about to
  leak into the public repo. Investigate before pushing.
- **UNREGISTERED** — a nested repo isn't listed in `_private/repos.md`, so a new-machine bootstrap
  would miss it. Add its row to the manifest.

## The rules (the routine)
1. **Session start →** `sync pull`. Fast-forward every repo before touching anything.
2. **Per repo, commit independently.** They have separate histories. A change that spans repos
   (e.g. promoting a generic doc *and* updating a book) = one commit in **each** affected repo,
   cross-referenced in the messages. Prose commits → author identity, no Claude trailer;
   scaffolding/notes → Claude trailer (see `_private/author.md`).
3. **Before you stop →** `sync status`. Every repo must be **clean or intentionally committed** —
   no silent dirty subfolder.
4. **Then →** `sync push`. "Committed" is not "backed up" until pushed; the bootstrap relies on
   every repo being on its remote.
5. **New book →** `git init` + first commit + create the private remote, then **add its row to
   `_private/repos.md`** (the UNREGISTERED check enforces this).
6. **Before pushing `Writing` →** heed the PRIVACY warning; the public repo must track only the
   allow-listed paths.
