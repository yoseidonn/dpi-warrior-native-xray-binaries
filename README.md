# DPI Warrior - Xray Native Binaries

This repository hosts scripts and vendored sources to build Xray native artifacts.

- source/xray-core: Vendored upstream Xray-core (no submodule)
- source/_upstream/xray-core: Upstream cache (ignored by Git)
- jni_workspaces/xray_go: JNI Go wrapper (Android shared library)
- final_builds/: Build outputs by platform/ABI
- scripts/: Build and publishing helpers

Branching model:
- main: scripts + sources only
- <platform-abi> branches: contain only the artifacts for that target (and a README)

Usage:
- ANDROID_NDK_HOME and API_LEVEL must be set (or via scripts/.secrets)
- ./scripts/build_all.sh android
- ./scripts/init_branches.sh
