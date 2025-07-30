# DPI Warrior - Android ARM64

**DPI Warrior Edition** - Xray v25.6.8 Native Build for Android ARM64

## 📋 Branch Information
- **Branch**: `android-arm64-v8a`
- **Platform**: Android
- **Architecture**: ARM64
- **Version**: Xray v25.6.8
- **Edition**: DPI Warrior
- **Repository**: [dpi-warrior-native-xray-binaries](https://github.com/yoseidonn/dpi-warrior-native-xray-binaries)

## 🚀 Quick Start

### Download This Branch
```bash
git clone -b android-arm64-v8a https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git
```

### Download as ZIP
1. Go to: https://github.com/yoseidonn/dpi-warrior-native-xray-binaries
2. Click on branch dropdown
3. Select: `android-arm64-v8a`
4. Click "Code" → "Download ZIP"

## 📁 Contents

NDK structure with libxray.so for ARM64 architecture

## 🔧 Integration

### Android NDK Integration
1. Copy the contents to your Android project
2. Use the provided `Android.mk` and `Application.mk` files
3. Access through JNI or Flutter FFI

### Flutter FFI Example
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

## 🔧 Notes

- **DPI Warrior Edition** includes optimizations for DPI bypass scenarios
- All binaries are for Xray version 25.6.8
- Check the main repository for comprehensive documentation

## 📞 Support

- **Repository**: https://github.com/yoseidonn/dpi-warrior-native-xray-binaries
- **Main Documentation**: Check the `main` branch for detailed guides
- **Issues**: Use GitHub Issues for bug reports

---

**DPI Warrior Edition** - Empowering network freedom through optimized Xray builds 🚀
