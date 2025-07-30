# DPI Warrior - Platform-Specific Integration Guides

This guide provides detailed instructions for integrating **DPI Warrior Edition** Xray v25.6.8 native builds into your applications across different platforms.

## 🌐 Repository Information
- **Repository**: [dpi-warrior-native-xray-binaries](https://github.com/yoseidonn/dpi-warrior-native-xray-binaries)
- **Version**: Xray v25.6.8
- **Edition**: DPI Warrior
- **Status**: Public repository with platform-specific branches

## 📋 Quick Branch Reference

### 🤖 Android Branches
- `android-arm64-v8a` - ARM64 Android NDK builds
- `android-armeabi-v7a` - ARMv7 Android NDK builds
- `android-x86` - x86 Android NDK builds
- `android-x86_64` - x86_64 Android NDK builds

### 🍎 iOS Branches
- `ios-arm64` - ARM64 iOS frameworks and static libraries
- `ios-x86_64` - x86_64 iOS frameworks and static libraries

### 🖥️ macOS Branches
- `macos-arm64` - Apple Silicon (M1/M2) native binaries
- `macos-x86_64` - Intel Mac native binaries

### 🪟 Windows Branches
- `windows-x86` - 32-bit Windows executables
- `windows-x64` - 64-bit Windows executables

### 🐧 Linux Branches
- `linux-x86_64` - x86_64 Linux native binaries
- `linux-arm64` - ARM64 Linux native binaries
- `linux-armv7` - ARMv7 Linux native binaries
- `linux-armv6` - ARMv6 Linux native binaries
- `linux-ppc64le` - PowerPC 64-bit LE native binaries
- `linux-s390x` - IBM S390x native binaries
- `linux-mips64` - MIPS64 native binaries
- `linux-mips64le` - MIPS64 LE native binaries
- `linux-mips32` - MIPS32 native binaries
- `linux-mips32le` - MIPS32 LE native binaries
- `linux-riscv64` - RISC-V 64-bit native binaries

## Android NDK Integration

### Prerequisites
- Android NDK installed
- Android Studio or command line tools
- Git access to the repository

### Steps
1. Clone the specific architecture branch:
   ```bash
   git clone -b android-arm64-v8a https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git
   ```

2. Add to your app's build.gradle:
   ```gradle
   android {
       defaultConfig {
           ndk {
               abiFilters 'arm64-v8a', 'armeabi-v7a', 'x86', 'x86_64'
           }
       }
   }
   ```

3. Use JNI to call native functions

### JNI Example
```java
static {
    System.loadLibrary("xray");
}

public native int xrayInit(String configPath);
public native int xrayStart();
public native int xrayStop();
```

### Android.mk Configuration
```makefile
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := xray
LOCAL_SRC_FILES := jniLibs/arm64-v8a/libxray.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)
```

## iOS Integration

### Using Static Libraries
1. Clone the specific architecture branch:
   ```bash
   git clone -b ios-arm64 https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git
   ```

2. Add .a files to Xcode project
3. Link in Build Settings
4. Use Swift bridging

### Using Frameworks
1. Add framework to Xcode project
2. Import in Swift/Objective-C
3. Use provided headers

### Swift Example
```swift
import Foundation

// Load framework
guard let framework = Bundle.main.loadFramework(named: "Xray") else {
    fatalError("Could not load Xray framework")
}

// Define function signatures
typealias XrayInitFunc = @convention(c) (UnsafePointer<CChar>?) -> Int32

// Get function pointer
guard let xrayInit = framework.symbol(named: "xray_init") as? XrayInitFunc else {
    fatalError("Could not find xray_init function")
}

// Use function
let result = xrayInit("/path/to/config.json")
```

### Framework Structure
```
Xray.framework/
├── Headers/
│   └── Xray.h
├── Modules/
│   └── module.modulemap
├── Info.plist
└── Xray
```

## Flutter Integration

### Android
```dart
import 'dart:ffi';
import 'dart:io';

class XrayAndroid {
  static final DynamicLibrary _lib = Platform.isAndroid
      ? DynamicLibrary.open('libxray.so')
      : throw UnsupportedError('Platform not supported');
      
  static final int Function(Pointer<Utf8>) _xrayInit = _lib
      .lookupFunction<Int32 Function(Pointer<Utf8>), int Function(Pointer<Utf8>)>('xray_init');
      
  static final int Function() _xrayStart = _lib
      .lookupFunction<Int32 Function(), int Function()>('xray_start');
      
  static final int Function() _xrayStop = _lib
      .lookupFunction<Int32 Function(), int Function()>('xray_stop');
}
```

### iOS
```dart
import 'dart:ffi';
import 'dart:io';

class XrayIOS {
  static final DynamicLibrary _lib = Platform.isIOS
      ? DynamicLibrary.process()
      : throw UnsupportedError('Platform not supported');
      
  static final int Function(Pointer<Utf8>) _xrayInit = _lib
      .lookupFunction<Int32 Function(Pointer<Utf8>), int Function(Pointer<Utf8>)>('xray_init');
}
```

### Desktop (Windows/macOS/Linux)
```dart
import 'dart:io';
import 'dart:convert';

class XrayDesktop {
  static Process? _process;
  
  static Future<void> start(String configPath) async {
    final executable = Platform.isWindows ? 'xray.exe' : 'xray';
    _process = await Process.start(executable, ['-config', configPath]);
  }
  
  static Future<void> stop() async {
    _process?.kill();
  }
}
```

## Desktop Platform Integration

### Windows Integration
1. Clone the specific architecture branch:
   ```bash
   git clone -b windows-x64 https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git
   ```

2. Include the .exe file in your application
3. Execute using Process.run() or similar
4. Use the provided batch scripts for easy execution

### macOS Integration
1. Clone the specific architecture branch:
   ```bash
   git clone -b macos-arm64 https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git
   ```

2. Include the binary in your app bundle
3. Run the codesign.sh script for distribution:
   ```bash
   ./codesign.sh "Developer ID: Your Name (TEAM_ID)"
   ```
4. Execute using Process.run() or similar

### Linux Integration
1. Clone the specific architecture branch:
   ```bash
   git clone -b linux-x86_64 https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git
   ```

2. Include the binary in your application
3. Run the install.sh script for system installation:
   ```bash
   sudo ./install.sh
   ```
4. Execute using Process.run() or similar

## Security Considerations

### Android
- Use VPNService for proper VPN integration
- Handle permissions properly
- Consider using isolated processes
- **DPI Warrior Edition** includes optimizations for DPI bypass

### iOS
- Follow App Store guidelines
- Use proper entitlements
- Handle network extension permissions
- **DPI Warrior Edition** includes framework optimizations

### Desktop
- Validate configuration files
- Handle file permissions
- Consider code signing for distribution
- **DPI Warrior Edition** includes enhanced security features

## 🚀 Quick Download Commands

### Android
```bash
# ARM64
git clone -b android-arm64-v8a https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git

# ARMv7
git clone -b android-armeabi-v7a https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git
```

### iOS
```bash
# ARM64
git clone -b ios-arm64 https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git

# x86_64
git clone -b ios-x86_64 https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git
```

### Desktop
```bash
# Windows x64
git clone -b windows-x64 https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git

# macOS ARM64
git clone -b macos-arm64 https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git

# Linux x86_64
git clone -b linux-x86_64 https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git
```

## 📞 Support

- **Repository**: https://github.com/yoseidonn/dpi-warrior-native-xray-binaries
- **Issues**: Use GitHub Issues for bug reports and feature requests
- **Documentation**: Check the main `README.md` file for comprehensive guides

---

**DPI Warrior Edition** - Empowering network freedom through optimized Xray builds 🚀
