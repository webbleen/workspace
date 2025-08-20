# Android SDK 测试项目

本项目包含两个Kotlin Android项目：

## 项目结构

```
android-sdk-test/
├── webview-library/          # 第一个项目：WebView库项目
│   ├── app/                  # 库模块
│   │   ├── src/main/
│   │   │   ├── java/        # Kotlin源代码
│   │   │   ├── res/         # 资源文件
│   │   │   └── AndroidManifest.xml
│   │   └── build.gradle.kts # 库模块构建配置
│   └── build.gradle.kts     # 项目级构建配置
└── main-app/                 # 第二个项目：主应用项目
    ├── app/                  # 应用模块
    │   ├── src/main/
    │   │   ├── java/        # Kotlin源代码
    │   │   ├── res/         # 资源文件
    │   │   └── AndroidManifest.xml
    │   └── build.gradle.kts # 应用模块构建配置
    └── build.gradle.kts     # 项目级构建配置
```

## 第一个项目：WebView库项目 (webview-library)

### 功能特性
- 闪屏页面，支持自定义Logo
- 主页面包含WebView，可以加载网页
- 可打包成AAR静态库

### 主要组件
- `SplashActivity`: 闪屏页面，显示Logo和标题
- `MainActivity`: 主页面，包含WebView
- 支持自定义Logo设置
- 支持自定义URL加载

### 构建AAR
```bash
cd webview-library
./gradlew assembleRelease
```
生成的AAR文件位于：`app/build/outputs/aar/app-release.aar`

## 第二个项目：主应用项目 (main-app)

### 功能特性
- 引用第一个项目的AAR包
- 主页面包含两个按钮
- 可以启动WebView页面
- 支持自定义Logo功能

### 主要组件
- `MainActivity`: 主页面，包含启动按钮
- `WebViewActivity`: WebView页面
- 集成第一个项目的功能

### 使用方法
1. 将第一个项目生成的AAR文件复制到 `app/libs/` 目录
2. 重命名为 `webviewlibrary-release.aar`
3. 构建并运行项目

## 构建和运行

### 环境要求
- Android Studio Flamingo | 2022.2.1 或更高版本
- Android SDK 33
- Kotlin 1.8.20
- Gradle 7.6

### 构建步骤

#### 1. 构建WebView库项目
```bash
cd webview-library
./gradlew assembleRelease
```

#### 2. 复制AAR文件
```bash
cp webview-library/app/build/outputs/aar/app-release.aar main-app/app/libs/webviewlibrary-release.aar
```

#### 3. 构建主应用项目
```bash
cd main-app
./gradlew assembleDebug
```

### 运行项目
1. 在Android Studio中打开对应的项目
2. 连接Android设备或启动模拟器
3. 点击运行按钮

## 自定义功能

### 自定义Logo
在第一个项目中，可以通过调用 `SplashActivity.setCustomLogo(resourceId)` 方法来设置自定义Logo。

### 自定义URL
在第一个项目中，可以通过调用 `MainActivity.loadCustomUrl(url)` 方法来加载自定义URL。

## 注意事项

1. **Java版本要求**: 项目需要Java 11或更高版本才能构建
2. 确保网络权限已正确配置
3. WebView需要网络连接才能正常加载网页
4. 第一个项目必须先生成AAR文件，第二个项目才能正常构建
5. 建议使用Android Studio打开项目以获得最佳开发体验

## 重要提示

由于当前系统使用Java 8，无法直接构建项目。请参考 `BUILD_INSTRUCTIONS.md` 文件了解详细的构建说明。

**推荐解决方案**: 使用Android Studio打开项目，它会自动处理Java版本和依赖问题。

## 技术栈

- **语言**: Kotlin
- **UI框架**: Android原生 + Material Design
- **构建工具**: Gradle + Kotlin DSL
- **最低SDK**: API 21 (Android 5.0)
- **目标SDK**: API 33 (Android 13)

