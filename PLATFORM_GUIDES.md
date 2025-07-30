# Platform-Specific Integration Guides

## Android NDK Integration

### Prerequisites
- Android NDK installed
- Android Studio or command line tools

### Steps
1. Copy the architecture-specific folder to your project
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

## iOS Integration

### Using Static Libraries
1. Add .a files to Xcode project
2. Link in Build Settings
3. Use Swift bridging

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

## Security Considerations

### Android
- Use VPNService for proper VPN integration
- Handle permissions properly
- Consider using isolated processes

### iOS
- Follow App Store guidelines
- Use proper entitlements
- Handle network extension permissions

### Desktop
- Validate configuration files
- Handle file permissions
- Consider code signing for distribution
