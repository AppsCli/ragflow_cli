# 应用商店自动发布配置说明

本仓库在推送版本 tag（如 `v1.0.1`）时会触发 [Release workflow](.github/workflows/release.yml)，除生成 GitHub Release 外，还可自动将应用提交到以下商店（需在 GitHub 中配置对应 Secrets）：

- **Snap Store**（Linux）
- **Google Play**（Android）
- **Microsoft Store**（Windows）
- **Apple App Store / TestFlight**（iOS 与 macOS）

只有在配置了相应 Secret 时，对应的商店发布 job 才会执行，未配置的商店会被跳过。

---

## 一、在 GitHub 中配置 Secrets

路径：仓库 **Settings → Secrets and variables → Actions**，点击 **New repository secret** 添加以下项。

### 1. Snap Store

| Secret 名称 | 说明 | 获取方式 |
|-------------|------|----------|
| `SNAPCRAFT_TOKEN` | Snap Store 登录令牌 | 本机执行：`snapcraft export-login --snaps ragflow-cli --channels edge -`，将输出内容完整粘贴为 Secret。 |

- 发布通道：当前 workflow 使用 `stable`。若希望先发到 `edge`/`candidate`，可修改 release.yml 中 `snapcraft upload --release=...`。
- 若未设置 `SNAPCRAFT_TOKEN`，Snap Store 的构建与上传步骤会被跳过。

---

### 2. Google Play

| Secret 名称 | 说明 | 获取方式 |
|-------------|------|----------|
| `PLAY_STORE_SERVICE_ACCOUNT_JSON` | 服务账号 JSON 全文 | 在 [Google Cloud Console](https://console.cloud.google.com/) 创建服务账号，为 Google Play Android 开发者 API 启用并授权，下载 JSON 密钥，将**整个文件内容**粘贴为 Secret。 |

- 包名：`cloud.iothub.ragflow_cli`（与 `android/app/build.gradle.kts` 中一致）。
- 当前 workflow 将 AAB 上传到 **internal** 轨道；要发到 **production**，修改 release.yml 中 `track: internal` 为 `track: production`。
- 若未设置 `PLAY_STORE_SERVICE_ACCOUNT_JSON`，Google Play 上传步骤会被跳过。

---

### 3. Microsoft Store

需要先在 [Partner Center](https://partner.microsoft.com) 将应用与 Azure AD 应用关联，并创建一次提交。以下 Secrets 需全部配置后，Microsoft Store 提交 job 才会运行。

| Secret 名称 | 说明 | 获取方式 |
|-------------|------|----------|
| `MICROSOFT_STORE_SELLER_ID` | 卖家 ID | Partner Center → 右上角齿轮 → Account settings → Legal info。 |
| `MICROSOFT_STORE_PRODUCT_ID` | 产品 ID（Partner Center 应用 ID） | 在 Partner Center 中打开应用，在概述页复制「Partner Center ID」。 |
| `MICROSOFT_STORE_TENANT_ID` | Azure AD 租户 ID | Partner Center → Manage users → 添加的 Azure AD 应用 → 复制 Tenant ID。 |
| `MICROSOFT_STORE_CLIENT_ID` | Azure AD 应用（客户端）ID | 同上，复制 Client ID。 |
| `MICROSOFT_STORE_CLIENT_SECRET` | Azure AD 应用密钥 | 在 Azure AD 应用中「Certificates & secrets」创建新密钥，复制 Value（只显示一次）。 |

- 提交时使用的 MSIX 来自**同一次 Release** 中 Windows job 上传的 `ragflow_cli.msix`，URL 为：  
  `https://github.com/<owner>/<repo>/releases/download/<tag>/ragflow_cli.msix`
- 若任一上述 Secret 未设置，Microsoft Store 提交步骤会被跳过。

---

### 4. Apple App Store / TestFlight（iOS 与 macOS）

#### 4.1 App Store Connect API（上传时必填）

| Secret 名称 | 说明 | 获取方式 |
|-------------|------|----------|
| `APPSTORE_ISSUER_ID` | Issuer ID | App Store Connect → Users and Access → Keys → 页面上的 Issuer ID。 |
| `APPSTORE_API_KEY_ID` | API Key ID | 创建新 Key 后显示的 Key ID。 |
| `APPSTORE_API_PRIVATE_KEY` | API 私钥内容 | 创建 Key 时下载的 `.p8` 文件**完整内容**（含 `-----BEGIN PRIVATE KEY-----` 与 `-----END PRIVATE KEY-----`）。 |

- 若未配置上述三个 API 相关 Secret，iOS/macOS 商店上传 job 不会运行。

#### 4.2 代码签名（用于构建可上传的 IPA / macOS 应用）

**iOS：**

| Secret 名称 | 说明 | 获取方式 |
|-------------|------|----------|
| `APPLE_SIGNING_CERTIFICATE` | 分发证书 .p12 的 Base64 | 在 Keychain Access 中导出「Apple Distribution」证书为 .p12，执行：`base64 -i YourCertificate.p12 | pbcopy`，粘贴为 Secret。 |
| `APPLE_SIGNING_CERTIFICATE_PASSWORD` | .p12 密码 | 导出时设置的密码。 |
| `APPLE_PROVISIONING_PROFILE` | 描述文件 Base64 | 下载的 .mobileprovision 文件：`base64 -i profile.mobileprovision \| pbcopy`。 |
| `APPLE_KEYCHAIN_PASSWORD` | 临时 keychain 密码 | 任意随机字符串，CI 中用于创建/解锁临时 keychain。 |

**macOS（Mac App Store）：**

| Secret 名称 | 说明 |
|-------------|------|
| `APPLE_SIGNING_CERTIFICATE_MAC` | macOS 分发证书 .p12 的 Base64。 |
| `APPLE_SIGNING_CERTIFICATE_PASSWORD_MAC` | 上述 .p12 的密码。 |
| `APPLE_PROVISIONING_PROFILE_MAC` | macOS 用 .provisionprofile 的 Base64。 |
| `APPLE_KEYCHAIN_PASSWORD_MAC` | macOS job 用的临时 keychain 密码。 |

- 若未配置签名相关 Secret，iOS/macOS job 仍会运行，但会执行无签名构建并**跳过**上传到 TestFlight/App Store 的步骤。
- 首次在 App Store Connect 创建应用、Bundle ID、描述文件与证书的步骤需在 Apple 开发者后台与 App Store Connect 中完成，此处不赘述。

---

## 二、Android 签名（Google Play 与 Release AAB/APK）

当前 Release workflow 中 Android 构建已使用以下 Secrets 做 release 签名（若未配置，Android 构建会失败）：

| Secret 名称 | 说明 |
|-------------|------|
| `KEY_STORE` | 签名 keystore 文件（.jks）的 **Base64** 编码。本机：`base64 -i your.jks \| pbcopy`。 |
| `STORE_PASSWORD` | Keystore 密码。 |
| `KEY_PASSWORD` | Key 密码。 |
| `KEY_ALIAS` | Key 别名。 |

这些在「Settings → Secrets and variables → Actions」中配置即可。

---

## 三、触发方式与行为摘要

- **触发条件**：向仓库推送符合 `v*.*.*` 的 tag（例如 `v1.0.2`）。
- **Snap Store**：若有 `SNAPCRAFT_TOKEN`，会从 tag 解析版本、构建 snap 并执行 `snapcraft upload --release=stable`。
- **Google Play**：若有 `PLAY_STORE_SERVICE_ACCOUNT_JSON`，会在 Android job 产出 AAB 后上传到 internal 轨道。
- **Microsoft Store**：若已配置全部 `MICROSOFT_STORE_*`，会在 Windows job 将 MSIX 上传到 GitHub Release 后，用 Partner Center API 创建/更新提交并发布。
- **Apple**：若有 `APPSTORE_*` 三个 API Secret，会运行 iOS/macOS 商店 job；若再配置对应平台的签名 Secret，会构建签名包并上传到 TestFlight/App Store。

---

## 四、需要你在各平台完成的配置（非 GitHub 内）

1. **Snap Store**：在 [snapcraft.io](https://snapcraft.io) 注册并创建 snap 名称 `ragflow-cli`，再导出登录令牌。
2. **Google Play**：在 Google Play Console 创建应用、启用 Google Play Android Developer API，并在 Google Cloud 创建服务账号并绑定。
3. **Microsoft Store**：在 Partner Center 创建应用、完成至少一次提交、在「Manage users」中关联 Azure AD 应用并拿到 Tenant ID / Client ID / Client secret；在应用概述页拿到 Product ID，在账户设置拿到 Seller ID。
4. **Apple**：在 App Store Connect 创建 iOS/macOS 应用、配置 Bundle ID、在「Users and Access → Keys」创建 API Key、在开发者后台创建分发证书与描述文件并导出 .p12 / .mobileprovision，再按上表做 Base64 填入 GitHub Secrets。

按需配置上述 Secret 与平台侧设置后，每次打 tag 发布即可自动构建并推送到对应商店。
