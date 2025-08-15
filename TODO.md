# TODO (Xray Native Binaries - DPI Warrior)

Status snapshot
- Layout in place: scripts/, working_directory/, final_builds/ (ignored).
- Upstream Xray cloned at working_directory/xray-core.
- Android JNI stub builds into final_builds/android/* via scripts/build_all.sh.
- init_branches.sh creates and pushes per-ABI/platform branches from final_builds.

Immediate next steps
1) Android JNI binaries (real core)
   - Replace working_directory/xray-core/jni_main.go stub with proper JNI entry that wires StartXray/StopXray/IsXrayRunning/GetVersion to Xray’s runtime (or your existing Go wrapper).
   - Validate exported symbols with: nm -D final_builds/android/<abi>/libxray_go.so | grep -E "StartXray|StopXray|IsXrayRunning|GetVersion".

2) One-shot build and branch push
   - Android only:
     ANDROID_NDK_HOME=$HOME/Android/Sdk/ndk/25.1.8937393 ./scripts/build_all.sh android
   - All platforms:
     ANDROID_NDK_HOME=$HOME/Android/Sdk/ndk/25.1.8937393 ./scripts/build_all.sh all
   - Then push branches from final_builds:
     ./scripts/init_branches.sh
     (Set GITHUB_USER and authenticated git if required.)

3) Linux/macOS/Windows builds (real core)
   - Current scripts build CLI xray from ./main. Ensure final_builds/* artifacts run (./xray, xray.exe). If you need shared libraries instead, switch to -buildmode=c-shared and export JNI as needed.

4) iOS targets
   - Add iOS directories under final_builds/ios/{arm64,x86_64} (simulator). Implement Go mobile or c-shared flow if needed.

5) CI (optional)
   - Add GitHub Actions to run scripts/build_all.sh on tags and auto-push branches from artifacts.

6) Secrets policy
   - Do not commit tokens in scripts. Use local git credential helper or environment variables when pushing.

7) App integration check
   - Android app now loads xray_jni and uses StartXray/StopXray/IsXrayRunning via JNI. Ensure libxray_go.so from branches matches the app ABI config (arm64-v8a, armeabi-v7a, x86_64).

Known gaps / decisions
- The JNI entry (jni_main.go) is still a stub. Replace with production logic.
- No iOS build yet; add if required.
- Current Linux/macOS/Windows outputs are static binaries; confirm if .so/.dylib/.dll are needed.
- Protect socket logic: With the app excluded from VPN, Xray processes are already bypassed; if you embed Xray in-process, consider adding a protect callback in Go layer if needed by your design. 