#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
FINAL_DIR="$REPO_ROOT/final_builds"

# Optional secrets file (ignored by git)
SECRETS_FILE="$REPO_ROOT/scripts/.secrets"
if [[ -f "$SECRETS_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$SECRETS_FILE"
fi

# Push main branch with non-ignored changes (scripts/, working_directory/, etc.)
push_main() {
  cd "$REPO_ROOT"
  git checkout -B main >/dev/null 2>&1 || true
  git add -A
  if git diff --cached --quiet; then
    echo "No changes to push on main"
  else
    git commit -m "chore(main): update scripts and working_directory"
    git push -u origin main || git push -u origin main -f
  fi
}

BRANCHES=(
  android-arm64-v8a android-armeabi-v7a android-x86_64 android-x86
  linux-x86_64 linux-x86 linux-arm64 linux-armv7 linux-mips linux-mips64 linux-mips64le linux-mipsle linux-ppc64le linux-s390x linux-riscv64
  macos-arm64 macos-x86_64
  windows-x64 windows-x86
  ios-arm64 ios-x86_64
)

remote_url() {
  local user="${GITHUB_USER:-}" token="${GITHUB_TOKEN:-}" repo="${GITHUB_REPO:-dpi-warrior-native-xray-binaries}"
  if [[ -n "$user" && -n "$token" ]]; then
    echo "https://$user:$token@github.com/$user/$repo.git"
  elif [[ -n "$user" ]]; then
    echo "https://github.com/$user/$repo.git"
  else
    echo "https://github.com/${GITHUB_USER:-origin}/$repo.git"
  fi
}

has_artifacts() {
  local branch="$1" dir="$2"
  case "$branch" in
    android-*) [[ -f "$dir/libxray_go.so" ]] && return 0 || return 1 ;;
    linux-*)   [[ -f "$dir/xray" ]] && return 0 || return 1 ;;
    macos-*)   [[ -f "$dir/xray" ]] && return 0 || return 1 ;;
    windows-*) [[ -f "$dir/xray.exe" ]] && return 0 || return 1 ;;
    ios-*)     # not implemented yet
               return 1 ;;
    *)         return 1 ;;
  esac
}

# First, push main
push_main

for b in "${BRANCHES[@]}"; do
  case "$b" in
    android-*) dir="$FINAL_DIR/android/${b#android-}" ;;
    linux-*) dir="$FINAL_DIR/linux/${b#linux-}" ;;
    macos-*) dir="$FINAL_DIR/macos/${b#macos-}" ;;
    windows-*) dir="$FINAL_DIR/windows/${b#windows-}" ;;
    ios-*) dir="$FINAL_DIR/ios/${b#ios-}" ;;
  esac
  mkdir -p "$dir"
  if ! has_artifacts "$b" "$dir"; then
    echo "Skipping $b (no artifacts)"
    continue
  fi
  (
    cd "$dir"
    git init >/dev/null 2>&1 || true
    git checkout -B "$b" >/dev/null 2>&1 || true
    git add -A || true
    git commit -m "build: $b artifacts" >/dev/null 2>&1 || true
    git remote remove origin >/dev/null 2>&1 || true
    git remote add origin "$(remote_url)"
    git push -u origin "$b" -f || true
  )
 done
