# RAGFlow Flutter 客户端

基于 RAGFlow 服务端和 Web 端代码开发的 Flutter 移动客户端应用。

## 功能特性

- 📚 **知识库管理** - 浏览和管理知识库
- 💬 **聊天对话** - 与 AI 进行对话交流
- 🔍 **智能搜索** - 基于知识库的搜索功能
- 🤖 **Agent 管理** - 创建和管理 AI Agent
- 📁 **文件管理** - 文件的上传、下载和管理
- 👤 **账号管理** - 用户信息和设置管理

## 主要功能

### 服务器配置
- 支持自定义服务器地址配置
- 登录界面提供服务器地址设置入口
- 账号页面可随时修改服务器地址

### 用户认证
- 邮箱密码登录
- 自动保存登录状态
- Token 自动管理

## 项目结构

```
lib/
├── models/          # 数据模型
│   ├── user.dart
│   ├── knowledge_base.dart
│   ├── dialog.dart
│   └── server_config.dart
├── services/        # API 服务
│   ├── api_client.dart
│   ├── user_service.dart
│   ├── knowledge_service.dart
│   ├── chat_service.dart
│   ├── search_service.dart
│   ├── agent_service.dart
│   └── file_service.dart
├── pages/           # 页面
│   ├── login_page.dart
│   ├── server_config_page.dart
│   ├── home_page.dart
│   ├── knowledge_page.dart
│   ├── chat_page.dart
│   ├── search_page.dart
│   ├── agent_page.dart
│   ├── file_page.dart
│   └── account_page.dart
├── providers/       # 状态管理
│   └── auth_provider.dart
└── utils/           # 工具类
    └── storage.dart
```

## 安装依赖

```bash
flutter pub get
```

## 运行应用

```bash
flutter run
```

## 使用说明

### 首次使用

1. 启动应用后，首先需要配置服务器地址
2. 在登录页面点击"设置服务器地址"按钮
3. 输入你的 RAGFlow 服务器地址，例如：`http://192.168.1.100:9380`
4. 返回登录页面，输入邮箱和密码登录

### 主要操作

- **知识库**: 查看和管理知识库列表，支持创建新知识库
- **聊天**: 浏览对话列表，创建新对话
- **搜索**: 管理搜索配置
- **Agent**: 查看和管理 AI Agent
- **文件**: 上传、下载和管理文件
- **账号**: 查看用户信息、修改服务器设置、退出登录

## API 接口

应用使用 RAGFlow 的 REST API，主要接口包括：

- `/v1/user/login` - 用户登录
- `/v1/kb/list` - 获取知识库列表
- `/v1/dialog/list` - 获取对话列表
- `/v1/conversation/list` - 获取会话列表
- `/v1/file/list` - 获取文件列表
- 等等...

## 技术栈

- **Flutter** - 跨平台移动应用框架
- **Provider** - 状态管理
- **http** - HTTP 客户端
- **shared_preferences** - 本地存储

## 注意事项

- 确保你的 RAGFlow 服务器已正确配置并运行
- 服务器地址必须是完整的 URL（包含 http:// 或 https://）
- 某些功能（如文件上传）需要进一步实现

## 开发计划

- [ ] 实现知识库详情页面
- [ ] 实现聊天详情和消息发送
- [ ] 完善文件上传功能
- [ ] 添加搜索功能
- [ ] 实现 Agent 详情和运行功能
- [ ] 优化 UI/UX
- [ ] 添加错误处理和加载状态
