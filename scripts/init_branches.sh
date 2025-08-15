#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
FINAL_DIR="$REPO_ROOT/final_builds"
SECRETS_FILE="$REPO_ROOT/scripts/.secrets"
if [[ -f "$SECRETS_FILE" ]]; then source "$SECRETS_FILE"; fi
push_main() {
  cd "$REPO_ROOT"
  git checkout -B main >/dev/null 2>&1 || true
  git add -A
  if git diff --cached --quiet; then echo "No changes to push on main"; else git commit -m "chore(main): update scripts and sources"; git push -u origin main || git push -u origin main -f; fi
}
BRANCHES=(android-arm64-v8a android-armeabi-v7a android-x86_64)
remote_url() { git -C "$REPO_ROOT" remote get-url origin; }
has_artifacts() { [[ -f "$1/libxray_go.so" ]]; }
push_main
for b in "${BRANCHES[@]}"; do
  dir="$FINAL_DIR/android/${b#android-}"
  mkdir -p "$dir"
  if ! has_artifacts "$dir"; then echo "Skipping $b (no artifacts)"; continue; fi
  (
    cd "$dir"; git init >/dev/null 2>&1 || true; git checkout -B "$b" >/dev/null 2>&1 || true
    git add -A || true; git commit -m "build: $b artifacts" >/dev/null 2>&1 || true
    git remote remove origin >/dev/null 2>&1 || true; git remote add origin "$(remote_url)"
    git push -u origin "$b" -f || true
  )
done
