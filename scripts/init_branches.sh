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
BRANCHES=(
  android-arm64-v8a android-armeabi-v7a android-x86_64 android-x86
  linux-x86_64 linux-x86 linux-arm64 linux-armv7 linux-mips linux-mips64 linux-mips64le linux-mipsle linux-ppc64le linux-s390x linux-riscv64
  macos-arm64 macos-x86_64
  windows-x64 windows-x86
  ios-arm64 ios-x86_64
)
remote_url() { git -C "$REPO_ROOT" remote get-url origin; }
has_artifacts() {
  local branch="$1" dir="$2"
  case "$branch" in
    android-*) [[ -f "$dir/libxray_go.so" || -f "$dir/README.md" ]] && return 0 || return 1 ;;
    linux-*)   [[ -f "$dir/xray" || -f "$dir/README.md" ]] && return 0 || return 1 ;;
    macos-*)   [[ -f "$dir/xray" || -f "$dir/README.md" ]] && return 0 || return 1 ;;
    windows-*) [[ -f "$dir/xray.exe" || -f "$dir/README.md" ]] && return 0 || return 1 ;;
    ios-*)     [[ -f "$dir/README.md" ]] && return 0 || return 1 ;;
    *)         [[ -f "$dir/README.md" ]] && return 0 || return 1 ;;
  esac
}
# Ensure a README exists for every target dir so branches get published
prepare_readmes() {
  for b in "${BRANCHES[@]}"; do
    case "$b" in
      android-*) dir="$FINAL_DIR/android/${b#android-}" ; title="Android ${b#android-}" ;;
      linux-*)   dir="$FINAL_DIR/linux/${b#linux-}"   ; title="Linux ${b#linux-}" ;;
      macos-*)   dir="$FINAL_DIR/macos/${b#macos-}"   ; title="macOS ${b#macos-}" ;;
      windows-*) dir="$FINAL_DIR/windows/${b#windows-}" ; title="Windows ${b#windows-}" ;;
      ios-*)     dir="$FINAL_DIR/ios/${b#ios-}"       ; title="iOS ${b#ios-}" ;;
      *)         dir="$FINAL_DIR/$b" ; title="$b" ;;
    esac
    mkdir -p "$dir"
    cat > "$dir/README.md" <<EORMD
# Xray Binaries - $title

This branch contains Xray build artifacts for $title.

- Built by DPI Warrior scripts from vendored `source/xray-core`.
- See `main` branch README for usage and build instructions.
EORMD
  done
}

push_main
prepare_readmes
for b in "${BRANCHES[@]}"; do
  case "$b" in
    android-*) dir="$FINAL_DIR/android/${b#android-}" ;;
    linux-*)   dir="$FINAL_DIR/linux/${b#linux-}" ;;
    macos-*)   dir="$FINAL_DIR/macos/${b#macos-}" ;;
    windows-*) dir="$FINAL_DIR/windows/${b#windows-}" ;;
    ios-*)     dir="$FINAL_DIR/ios/${b#ios-}" ;;
    *)         dir="$FINAL_DIR/$b" ;;
  esac
  (
    cd "$dir"
    git init >/dev/null 2>&1 || true
    git checkout -B "$b" >/dev/null 2>&1 || true
    git add -A || true
    git commit -m "docs: add README for $b" >/dev/null 2>&1 || true
    git remote remove origin >/dev/null 2>&1 || true
    git remote add origin "$(remote_url)"
    git push -u origin "$b" -f || true
  )
 done
