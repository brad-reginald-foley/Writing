#!/usr/bin/env bash
# Workspace sync for the Writing super-repo + its nested independent repos.
#
# Writing/ gitignores its nested repos (_private/, each book/), so git run inside
# Writing/ is BLIND to them. This walks EVERY repo (super + nested) so a dirty/
# unpushed/unpulled subfolder can never hide. Repos are discovered by scanning for
# .git dirs (new books are picked up automatically; any nested repo missing from
# _private/repos.md is flagged unregistered).
#
# Usage: tools/sync.sh [status|pull|push|check]      (default: status)
set -uo pipefail

CMD="${1:-status}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ALLOW=(.gitignore CLAUDE.md README.md ideas.md framework tools)

# discover repos: super-repo first, then immediate subdirs that are repos
REPOS=()
[ -d "$ROOT/.git" ] && REPOS+=("$ROOT")
for d in "$ROOT"/*/; do
  [ -d "${d}.git" ] && REPOS+=("${d%/}")
done

warnings=()
printf '\n%-14s %-8s %s\n' "REPO" "BRANCH" "STATUS"
printf -- '------------------------------------------------------------\n'

for r in "${REPOS[@]}"; do
  name="$(basename "$r")"
  branch="$(git -C "$r" rev-parse --abbrev-ref HEAD 2>/dev/null)"
  dirty="$(git -C "$r" status --porcelain 2>/dev/null | grep -c . || true)"
  ahead=0; behind=0; upstream=1
  if lr="$(git -C "$r" rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null)"; then
    behind="$(echo "$lr" | awk '{print $1}')"; ahead="$(echo "$lr" | awk '{print $2}')"
  else
    upstream=0
  fi

  bits=()
  [ "$dirty"  -gt 0 ] && bits+=("$dirty uncommitted")
  [ "$upstream" -eq 0 ] && bits+=("NO UPSTREAM")
  [ "$ahead"  -gt 0 ] && bits+=("^$ahead to push")
  [ "$behind" -gt 0 ] && bits+=("v$behind to pull")
  status="clean"; [ ${#bits[@]} -gt 0 ] && status="$(IFS=' | '; echo "${bits[*]}")"
  printf '%-14s %-8s %s\n' "$name" "$branch" "$status"

  [ "$dirty"  -gt 0 ] && warnings+=("DIRTY      $name: $dirty uncommitted change(s)")
  [ "$upstream" -eq 0 ] && warnings+=("NO-UPSTREAM $name: no tracking branch (push with -u to back it up)")
  [ "$ahead"  -gt 0 ] && warnings+=("UNPUSHED   $name: $ahead commit(s) not on the remote (not backed up)")
  [ "$behind" -gt 0 ] && warnings+=("BEHIND     $name: $behind commit(s) to pull")
done

# privacy gate: super-repo allow-list
while IFS= read -r top; do
  [ -z "$top" ] && continue
  ok=0; for a in "${ALLOW[@]}"; do [ "$top" = "$a" ] && ok=1; done
  [ "$ok" -eq 0 ] && warnings+=("PRIVACY    super-repo tracks '$top' (not in allow-list) - personal content may leak")
done < <(git -C "$ROOT" ls-files 2>/dev/null | cut -d/ -f1 | sort -u)

# unregistered nested repos vs _private/repos.md
manifest="$ROOT/_private/repos.md"
if [ -f "$manifest" ]; then
  for r in "${REPOS[@]}"; do
    [ "$r" = "$ROOT" ] && continue
    name="$(basename "$r")"
    grep -qF "$name" "$manifest" || warnings+=("UNREGISTERED $name: not in _private/repos.md (bootstrap will miss it)")
  done
fi

echo
if [ ${#warnings[@]} -gt 0 ]; then
  echo "Warnings:"; printf '  %s\n' "${warnings[@]}"
else
  echo "All repos clean, pushed, and registered."
fi
echo

case "$CMD" in
  pull)
    echo "Pulling (fast-forward only)..."
    for r in "${REPOS[@]}"; do
      git -C "$r" rev-parse '@{upstream}' >/dev/null 2>&1 || { echo "  skip $(basename "$r") (no upstream)"; continue; }
      echo "  $(basename "$r"): $(git -C "$r" pull --ff-only 2>&1 | tr '\n' ' ')"
    done ;;
  push)
    pushed=0
    for r in "${REPOS[@]}"; do
      git -C "$r" rev-parse '@{upstream}' >/dev/null 2>&1 || { echo "  $(basename "$r"): no upstream - git -C '$r' push -u origin <branch>"; continue; }
      a="$(git -C "$r" rev-list --count '@{upstream}..HEAD' 2>/dev/null || echo 0)"
      [ "$a" -gt 0 ] && { echo "  $(basename "$r") (^$a): $(git -C "$r" push 2>&1 | tr '\n' ' ')"; pushed=1; }
    done
    [ "$pushed" -eq 0 ] && echo "Nothing to push." ;;
  check)
    [ ${#warnings[@]} -gt 0 ] && exit 1 || exit 0 ;;
esac
