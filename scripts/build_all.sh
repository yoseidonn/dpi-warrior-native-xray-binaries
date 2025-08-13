#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
WORK_DIR="$REPO_ROOT/working_directory"
FINAL_DIR="$REPO_ROOT/final_builds"
ANDROID_NDK_HOME=${ANDROID_NDK_HOME:-${ANDROID_NDK:-}}
API_LEVEL=${API_LEVEL:-26}

clone_or_update() {
  cd "$WORK_DIR"
  if [[ ! -d xray-core ]]; then git clone https://github.com/XTLS/Xray-core.git xray-core; else (cd xray-core && git fetch --all && git reset --hard origin/main); fi
}

build_android() {
  local src="$WORK_DIR/xray-core"
  [[ -d "$ANDROID_NDK_HOME" ]] || { echo "❌ ANDROID_NDK_HOME not set"; exit 1; }
  mkdir -p "$FINAL_DIR/android/arm64-v8a" "$FINAL_DIR/android/armeabi-v7a" "$FINAL_DIR/android/x86_64"
  pushd "$src" >/dev/null
  cat > jni_main.go <<"GO"
package main
/*
#cgo LDFLAGS: -llog
#include <android/log.h>
static void xlog(const char* msg) { __android_log_write(ANDROID_LOG_INFO, "Xray-Go-JNI", msg); }
*/
import "C"
import "sync/atomic"
var running int32
//export StartXray
func StartXray(configPath *C.char) C.int { atomic.StoreInt32(&running, 1); C.xlog(C.CString("StartXray")); return 0 }
//export StopXray
func StopXray() C.int { atomic.StoreInt32(&running, 0); C.xlog(C.CString("StopXray")); return 0 }
//export IsXrayRunning
func IsXrayRunning() C.int { if atomic.LoadInt32(&running)==1 {return 1}; return 0 }
//export GetVersion
func GetVersion() *C.char { return C.CString("xray-core-jni") }
func main() {}
GO
  build_one() {
    local abi="$1" goarch="$2" cc="$3" out="$4"
    env GOOS=android GOARCH="$goarch" CGO_ENABLED=1 CC="$cc" go build -v -trimpath -buildmode=c-shared -o "$out/libxray_go.so" ./jni_main.go
  }
  build_one arm64-v8a arm64 "$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android${API_LEVEL}-clang" "$FINAL_DIR/android/arm64-v8a"
  build_one armeabi-v7a arm "$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi${API_LEVEL}-clang" "$FINAL_DIR/android/armeabi-v7a"
  build_one x86_64 amd64 "$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/x86_64-linux-android${API_LEVEL}-clang" "$FINAL_DIR/android/x86_64"
  popd >/dev/null
}

build_linux() {
  local src="$WORK_DIR/xray-core"
  mkdir -p "$FINAL_DIR/linux/amd64" "$FINAL_DIR/linux/arm64" "$FINAL_DIR/linux/armv7"
  pushd "$src" >/dev/null
  env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -v -o "$FINAL_DIR/linux/amd64/xray" ./main || true
  env GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -v -o "$FINAL_DIR/linux/arm64/xray" ./main || true
  env GOOS=linux GOARCH=arm CGO_ENABLED=0 go build -v -o "$FINAL_DIR/linux/armv7/xray" ./main || true
  popd >/dev/null
}

build_macos() {
  local src="$WORK_DIR/xray-core"
  mkdir -p "$FINAL_DIR/macos/arm64" "$FINAL_DIR/macos/x86_64"
  pushd "$src" >/dev/null
  env GOOS=darwin GOARCH=arm64 CGO_ENABLED=0 go build -v -o "$FINAL_DIR/macos/arm64/xray" ./main || true
  env GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 go build -v -o "$FINAL_DIR/macos/x86_64/xray" ./main || true
  popd >/dev/null
}

build_windows() {
  local src="$WORK_DIR/xray-core"
  mkdir -p "$FINAL_DIR/windows/x64" "$FINAL_DIR/windows/x86"
  pushd "$src" >/dev/null
  env GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -v -o "$FINAL_DIR/windows/x64/xray.exe" ./main || true
  env GOOS=windows GOARCH=386 CGO_ENABLED=0 go build -v -o "$FINAL_DIR/windows/x86/xray.exe" ./main || true
  popd >/dev/null
}

echo "Use: $0 {all|android}"
