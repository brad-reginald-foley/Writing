# Repo manifest — your whole writing setup

*Infra map for rebuilding on any machine. Creative project *status* lives in `projects.md`; this file
is just **what repos exist, where they live, how to clone them.** Keep them all private.*

**Target layout (any machine):**
```
~/Documents/Writing/                 ← the pipeline meta-repo
├── _private/                        ← THIS repo (your private notes + bootstrap)
├── <Book-One>/                      ← a book repo
└── <Book-Two>/                      ← a book repo
```

| Repo | Role | Remote | Clones to | Visibility |
|---|---|---|---|---|
| Writing | pipeline: framework + agent + intake | `github.com/<you>/Writing` | `~/Documents/Writing` | private |
| `<your-private-repo>` | THIS repo — private notes + bootstrap | `github.com/<you>/<your-private-repo>` | `~/Documents/Writing/_private` | private |
| `<book-one-repo>` | `<Book One>` | `github.com/<you>/<book-one-repo>` | `~/Documents/Writing/<Book-One>` | private |

→ Clone steps: `bootstrap.md`. **Add a row when you start a new book.**
