# 网络权限配置说明

本文档说明 RAGFlow Flutter 客户端在各平台上的网络权限配置。

## 已配置的平台

### ✅ Android

**文件**: `android/app/src/main/AndroidManifest.xml`

已添加以下权限：
- `INTERNET` - 允许应用访问互联网
- `ACCESS_NETWORK_STATE` - 允许应用检查网络连接状态

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

**网络安全配置**: `android/app/src/main/res/xml/network_security_config.xml`

已配置网络安全策略，允许 HTTP (明文) 流量，这对于连接本地开发的服务器是必需的。Android 9 (API 28) 及以上版本默认禁止 HTTP 流量。

```xml
<base-config cleartextTrafficPermitted="true">
    <trust-anchors>
        <certificates src="system" />
    </trust-anchors>
</base-config>
```

该配置已在 `AndroidManifest.xml` 中通过 `android:networkSecurityConfig="@xml/network_security_config"` 引用。

### ✅ iOS

**文件**: `ios/Runner/Info.plist`

已配置 `NSAppTransportSecurity`，允许 HTTP 连接（用于连接本地服务器）：
- `NSAllowsArbitraryLoads: true` - 允许任意 HTTP 连接

**注意**: 此配置允许所有 HTTP 连接，这对于连接本地开发的 RAGFlow 服务器（通常使用 HTTP）是必要的。

如果需要更严格的配置，可以在注释中使用 `NSExceptionDomains` 来限制特定域或 IP 段。

### ✅ macOS

**文件**: `macos/Runner/Info.plist`

已配置与 iOS 相同的网络传输安全设置：
- `NSAllowsArbitraryLoads: true` - 允许任意 HTTP 连接

**Entitlements 文件**: `macos/Runner/DebugProfile.entitlements` 和 `macos/Runner/Release.entitlements`

macOS 应用启用了 App Sandbox，需要网络客户端权限才能连接服务器：
- `com.apple.security.network.client: true` - 允许应用作为客户端连接到网络服务器

**重要**: 如果没有此权限，应用会显示 "Operation not permitted" 错误，无法连接到 localhost 或其他服务器。

### ✅ Windows

Windows 平台默认允许网络访问，无需额外配置。

**文件**: `windows/runner/runner.exe.manifest` - 仅用于应用程序兼容性设置

### ✅ Linux

Linux 平台默认允许网络访问，无需额外配置。

### ✅ Web

Web 平台由浏览器处理网络请求，但需要注意：

1. **CORS 配置**: 如果 RAGFlow 服务器需要跨域访问，需要在服务器端配置 CORS 策略
2. **Mixed Content**: 如果 Web 应用使用 HTTPS，而 RAGFlow 服务器使用 HTTP，可能需要允许混合内容（不推荐生产环境）

## 使用建议

### 生产环境配置

对于生产环境，建议：

1. **使用 HTTPS**: 确保 RAGFlow 服务器使用 HTTPS
2. **限制 HTTP 访问**: 在 iOS/macOS 中使用 `NSExceptionDomains` 替代 `NSAllowsArbitraryLoads`
3. **网络状态检查**: 在发起网络请求前检查网络连接状态

### 开发环境配置

当前配置适合开发环境，因为：
- 允许连接本地 HTTP 服务器（如 `http://192.168.1.100:9380`）
- 简化了开发测试流程

## 测试网络连接

在应用中使用时，建议：

1. **检查网络状态**: 在发起 API 请求前检查设备是否联网
2. **错误处理**: 处理网络超时和连接失败的情况
3. **用户提示**: 在无法连接服务器时给用户明确的提示

## 配置文件位置总结

| 平台 | 配置文件 | 状态 |
|------|---------|------|
| Android | `android/app/src/main/AndroidManifest.xml` + `network_security_config.xml` | ✅ 已配置 |
| iOS | `ios/Runner/Info.plist` | ✅ 已配置 |
| macOS | `macos/Runner/Info.plist` + `DebugProfile.entitlements` + `Release.entitlements` | ✅ 已配置 |
| Windows | 无需配置 | ✅ 默认支持 |
| Linux | 无需配置 | ✅ 默认支持 |
| Web | 浏览器处理 | ⚠️ 需注意 CORS |

## 验证配置

所有平台的配置文件已验证：

- ✅ iOS Info.plist 格式正确
- ✅ macOS Info.plist 格式正确
- ✅ macOS Entitlements 文件格式正确
- ✅ Android Manifest 格式正确
- ✅ Android 网络安全配置格式正确

配置完成后，应用可以在所有支持的平台上正常访问网络资源。

## macOS 特殊说明

如果遇到 "Operation not permitted" 错误：

1. **检查 Entitlements**: 确保 `com.apple.security.network.client` 权限已添加到 entitlements 文件
2. **重新构建**: 修改 entitlements 后需要重新构建应用
3. **清理构建**: 如果问题仍然存在，尝试清理并重新构建：
   ```bash
   flutter clean
   flutter pub get
   flutter run -d macos
   ```
