# DPI Warrior - Windows x86

**DPI Warrior Edition** - Xray v25.6.8 Native Build for Windows x86

## 📋 Branch Information
- **Branch**: `windows-x86`
- **Platform**: Windows
- **Architecture**: x86
- **Version**: Xray v25.6.8
- **Edition**: DPI Warrior
- **Repository**: [dpi-warrior-native-xray-binaries](https://github.com/yoseidonn/dpi-warrior-native-xray-binaries)

## 🚀 Quick Start

### Download This Branch
```bash
git clone -b windows-x86 https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git
```

### Download as ZIP
1. Go to: https://github.com/yoseidonn/dpi-warrior-native-xray-binaries
2. Click on branch dropdown
3. Select: `windows-x86`
4. Click "Code" → "Download ZIP"

## 📁 Contents

Windows executable for 32-bit systems

## 🔧 Integration

### Windows Integration
1. Include the .exe file in your application
2. Execute using Process.run() or similar
3. Use the provided batch scripts for easy execution

### Flutter Example
```dart
import 'dart:io';

class XrayWindows {
  static Future<void> start(String configPath) async {
    final process = await Process.start('xray.exe', ['-config', configPath]);
  }
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
