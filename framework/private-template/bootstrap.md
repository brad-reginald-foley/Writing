# Bootstrap — rebuild the whole writing workspace on a new machine

*You cloned this repo. Run these steps (or let Claude run them) to get the full setup: the pipeline, your private notes, and every book — each on its own remote.*

## Prerequisites
- **git** + **GitHub auth** (`gh auth login`, or SSH/HTTPS creds).
- *(optional)* **Obsidian** + the **Dataview** plugin (the auto chapter/timeline tables).

## Clone everything (edit URLs to match `repos.md`)
```bash
mkdir -p ~/Documents && cd ~/Documents
git clone https://github.com/<you>/Writing.git Writing
cd Writing
git clone https://github.com/<you>/<your-private-repo>.git _private   # this repo
git clone https://github.com/<you>/<book-one-repo>.git <Book-One>
# …one git clone per book listed in repos.md…
```
*(Already cloned this repo standalone? Just move that clone to `~/Documents/Writing/_private`.)*

## Then
- Open `~/Documents/Writing` in **Claude Code** → loads the pipeline agent (`Writing/CLAUDE.md`).
- For deep work on a book, open its folder as its own **Obsidian vault** (enable Dataview) and/or its own Claude session.
- Keep `repos.md` current when you add a book.
