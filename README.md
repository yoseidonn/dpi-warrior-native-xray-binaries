# DPI Warrior - Linux ARM64

**DPI Warrior Edition** - Xray v25.6.8 Native Build for Linux ARM64

## 📋 Branch Information
- **Branch**: `linux-arm64`
- **Platform**: Linux
- **Architecture**: ARM64
- **Version**: Xray v25.6.8
- **Edition**: DPI Warrior
- **Repository**: [dpi-warrior-native-xray-binaries](https://github.com/yoseidonn/dpi-warrior-native-xray-binaries)

## 🚀 Quick Start

### Download This Branch
```bash
git clone -b linux-arm64 https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git
```

### Download as ZIP
1. Go to: https://github.com/yoseidonn/dpi-warrior-native-xray-binaries
2. Click on branch dropdown
3. Select: `linux-arm64`
4. Click "Code" → "Download ZIP"

## 📁 Contents

Native binary for ARM64 Linux systems

## 🔧 Integration

### Linux Integration
1. Include the binary in your application
2. Run the install.sh script for system installation:
   ```bash
   sudo ./install.sh
   ```
3. Execute using Process.run() or similar

### Flutter Example
```dart
import 'dart:io';

class XrayLinux {
  static Future<void> start(String configPath) async {
    final process = await Process.start('./xray', ['-config', configPath]);
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
