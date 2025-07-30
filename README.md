# DPI Warrior - Xray v25.6.8 Native Builds

This repository contains native builds of Xray for different platforms and architectures, organized for easy integration into various applications. **DPI Warrior Edition** provides optimized builds for DPI bypass and network freedom.

## 🌐 Repository Information
- **Repository**: [dpi-warrior-native-xray-binaries](https://github.com/yoseidonn/dpi-warrior-native-xray-binaries)
- **Version**: Xray v25.6.8
- **Edition**: DPI Warrior
- **Status**: Public repository with platform-specific branches

## 📋 Available Branches

Each branch contains platform-specific native builds ready for download:

### 🤖 Android NDK Builds
- `android-arm64-v8a` - ARM64 Android builds with NDK structure
- `android-armeabi-v7a` - ARMv7 Android builds with NDK structure  
- `android-x86` - x86 Android builds with NDK structure
- `android-x86_64` - x86_64 Android builds with NDK structure

### 🍎 iOS Builds
- `ios-arm64` - ARM64 iOS builds (static libraries and frameworks)
- `ios-x86_64` - x86_64 iOS builds (static libraries and frameworks)

### 🖥️ macOS Builds
- `macos-arm64` - Apple Silicon (M1/M2) builds
- `macos-x86_64` - Intel Mac builds

### 🪟 Windows Builds
- `windows-x86` - 32-bit Windows builds
- `windows-x64` - 64-bit Windows builds

### 🐧 Linux Builds
- `linux-x86_64` - x86_64 Linux builds
- `linux-arm64` - ARM64 Linux builds
- `linux-armv7` - ARMv7 Linux builds
- `linux-armv6` - ARMv6 Linux builds
- `linux-ppc64le` - PowerPC 64-bit Little Endian builds
- `linux-s390x` - IBM S390x builds
- `linux-mips64` - MIPS64 builds
- `linux-mips64le` - MIPS64 Little Endian builds
- `linux-mips32` - MIPS32 builds
- `linux-mips32le` - MIPS32 Little Endian builds
- `linux-riscv64` - RISC-V 64-bit builds

## 📁 Directory Structure

### Android NDK Builds
Each Android directory contains:
- `jniLibs/` - Native libraries for JNI integration
- `libs/` - Alternative library location
- `Android.mk` - NDK build configuration
- `Application.mk` - NDK application configuration
- `build.gradle.snippet` - Gradle configuration snippet

### iOS Builds
Each iOS directory contains:
- `lib/` - Static libraries (.a files)
- `framework/` - iOS frameworks for easy integration

### macOS Builds
Each macOS directory contains:
- `xray` - Native binary
- `codesign.sh` - Script for code signing

### Windows Builds
Each Windows directory contains:
- `xray.exe` - Windows executable
- `xray_no_window.ps1` - PowerShell script for background execution
- `xray_no_window.vbs` - VBScript for background execution
- `run_xray.bat` - Batch script for easy execution

### Linux Builds
Each Linux directory contains:
- `xray` - Native binary
- `xray.service` - Systemd service file
- `install.sh` - Installation script

## 🚀 Quick Start

### Download Specific Platform
```bash
# Clone specific branch for your platform
git clone -b [branch-name] https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git

# Example: Android ARM64
git clone -b android-arm64-v8a https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git

# Example: Linux x86_64
git clone -b linux-x86_64 https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git
```

### Download as ZIP
1. Go to the repository: https://github.com/yoseidonn/dpi-warrior-native-xray-binaries
2. Click on the branch dropdown
3. Select your platform branch
4. Click "Code" → "Download ZIP"

## Platform-Specific Instructions

### Android Integration

#### Using NDK
1. Copy the appropriate architecture folder to your Android project
2. Use the NDK build files (Android.mk, Application.mk) to integrate
3. Access through JNI

#### Using Flutter FFI
```dart
import 'dart:ffi';
import 'dart:io';

class XrayAndroid {
  static final DynamicLibrary _lib = Platform.isAndroid
      ? DynamicLibrary.open('libxray.so')
      : throw UnsupportedError('Platform not supported');
      
  static final int Function(Pointer<Utf8>) _xrayInit = _lib
      .lookupFunction<Int32 Function(Pointer<Utf8>), int Function(Pointer<Utf8>)>('xray_init');
}
```

### iOS Integration

#### Using Static Libraries
1. Add the .a files to your Xcode project
2. Link against the libraries in Build Settings
3. Use Swift bridging or Objective-C to interface

#### Using Frameworks
1. Add the framework to your Xcode project
2. Import the framework in your Swift/Objective-C code
3. Use the provided headers for function declarations

#### Using Flutter FFI
```dart
import 'dart:ffi';
import 'dart:io';

class XrayIOS {
  static final DynamicLibrary _lib = Platform.isIOS
      ? DynamicLibrary.process()
      : throw UnsupportedError('Platform not supported');
}
```

### macOS Integration
1. Include the binary in your app bundle
2. Run the codesign.sh script for distribution
3. Execute using Process.run() or similar

### Windows Integration
1. Include the .exe file in your application
2. Execute using Process.run() or similar
3. Use the provided batch scripts for easy execution

### Linux Integration
1. Include the binary in your application
2. Run the install.sh script for system installation
3. Execute using Process.run() or similar

## 🔧 Notes

- **Android**: Requires NDK integration due to platform restrictions
- **iOS**: Requires static library or framework integration due to app sandboxing
- **Windows/Linux**: Can use binaries directly
- **macOS**: Requires code signing for distribution
- All binaries are for Xray version 25.6.8
- **DPI Warrior Edition** includes optimizations for DPI bypass scenarios

## 🛠️ Building from Source

If you need to build from source for specific platforms:

### Android NDK
```bash
# Install Android NDK
# Use go-ndk or similar tools to build Go code for Android
```

### iOS
```bash
# Use gomobile or compile Go code into static libraries
gomobile bind -target=ios -o xray.framework ./cmd/xray
```

### Cross-platform
```bash
# Build for different platforms using Go
GOOS=linux GOARCH=amd64 go build -o xray-linux-amd64 ./cmd/xray
GOOS=windows GOARCH=amd64 go build -o xray-windows-amd64.exe ./cmd/xray
GOOS=darwin GOARCH=amd64 go build -o xray-darwin-amd64 ./cmd/xray
```

## 📞 Support

- **Repository**: https://github.com/yoseidonn/dpi-warrior-native-xray-binaries
- **Issues**: Use GitHub Issues for bug reports and feature requests
- **Documentation**: Check the `PLATFORM_GUIDES.md` file for detailed integration guides

---

**DPI Warrior Edition** - Empowering network freedom through optimized Xray builds 🚀
