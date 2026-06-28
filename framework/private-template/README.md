# private-template — your personal & bootstrap repo (copy this)

*Copy this whole folder to `_private/` (a sibling of `framework/`, inside your Writing clone), fill it in, then make it **its own private git repo**. The Writing repo already gitignores `_private/`, so your personal content never enters the shareable pipeline — and your own private repo backs it up and becomes the **one clone** that reassembles your whole workspace on a new machine.*

## Set it up (from a clean Writing clone)
1. `cp -R framework/private-template/ _private/`
2. Fill in `author.md` (identity + git/GitHub) and `repos.md` (your repos). Drop ideas in `seeds.md`.
3. Make it its own private repo + offsite backup:
   ```bash
   cd _private
   git init && git add -A && git commit -m "Initialize my private writing repo"
   gh repo create <your-username>/<your-private-repo> --private --source=. --push
   ```
4. Add a row for it (and each book) to `repos.md`.

## What's in here
- `CLAUDE.md` — control/bootstrap agent (used when Claude is launched *in this repo*).
- `author.md` — your identity + preferences (the pipeline agent reads this each session).
- `repos.md` — manifest of all your repos (pipeline + books + this one): remotes + clone paths.
- `bootstrap.md` — rebuild the whole workspace on a new machine from one clone.
- `seeds.md` · `blind-spots-personal.md` · `projects.md` — your private working notes.
