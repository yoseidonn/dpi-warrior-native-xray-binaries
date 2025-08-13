#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
FINAL_DIR="$REPO_ROOT/final_builds"

BRANCHES=(
  android-arm64-v8a android-armeabi-v7a android-x86_64 android-x86
  linux-x86_64 linux-x86 linux-arm64 linux-armv7 linux-mips linux-mips64 linux-mips64le linux-mipsle linux-ppc64le linux-s390x linux-riscv64
  macos-arm64 macos-x86_64
  windows-x64 windows-x86
  ios-arm64 ios-x86_64
)

remote_url() {
  echo "https://github.com/${GITHUB_USER:-origin}/dpi-warrior-native-xray-binaries.git"
}

for b in "${BRANCHES[@]}"; do
  case "$b" in
    android-*) dir="$FINAL_DIR/android/${b#android-}" ;;
    linux-*) dir="$FINAL_DIR/linux/${b#linux-}" ;;
    macos-*) dir="$FINAL_DIR/macos/${b#macos-}" ;;
    windows-*) dir="$FINAL_DIR/windows/${b#windows-}" ;;
    ios-*) dir="$FINAL_DIR/ios/${b#ios-}" ;;
  esac
  mkdir -p "$dir"
  (cd "$dir" && git init && git checkout -B "$b" && git add -A && git commit -m "build: $b artifacts" || true && git remote remove origin || true && git remote add origin "$(remote_url "$b")" && git push -u origin "$b" -f || true)
done
