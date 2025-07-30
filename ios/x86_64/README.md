# DPI Warrior - iOS x86_64

**DPI Warrior Edition** - Xray v25.6.8 Native Build for iOS x86_64

## 📋 Branch Information
- **Branch**: `ios-x86_64`
- **Platform**: iOS
- **Architecture**: x86_64
- **Version**: Xray v25.6.8
- **Edition**: DPI Warrior
- **Repository**: [dpi-warrior-native-xray-binaries](https://github.com/yoseidonn/dpi-warrior-native-xray-binaries)

## 🚀 Quick Start

### Download This Branch
```bash
git clone -b ios-x86_64 https://github.com/yoseidonn/dpi-warrior-native-xray-binaries.git
```

### Download as ZIP
1. Go to: https://github.com/yoseidonn/dpi-warrior-native-xray-binaries
2. Click on branch dropdown
3. Select: `ios-x86_64`
4. Click "Code" → "Download ZIP"

## 📁 Contents

Static libraries and frameworks for x86_64 architecture

## 🔧 Integration

### iOS Integration
1. Add the framework to your Xcode project
2. Import in Swift/Objective-C
3. Use the provided headers

### Swift Example
```swift
import Foundation

guard let framework = Bundle.main.loadFramework(named: "Xray") else {
    fatalError("Could not load Xray framework")
}

typealias XrayInitFunc = @convention(c) (UnsafePointer<CChar>?) -> Int32
guard let xrayInit = framework.symbol(named: "xray_init") as? XrayInitFunc else {
    fatalError("Could not find xray_init function")
}

let result = xrayInit("/path/to/config.json")
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
