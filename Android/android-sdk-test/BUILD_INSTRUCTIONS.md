# 构建说明

由于当前系统使用Java 8，而现代Android Gradle插件需要Java 11或更高版本，建议使用Android Studio来构建项目。

## 推荐方法：使用Android Studio

### 1. 下载并安装Android Studio
- 访问 [Android Developer](https://developer.android.com/studio) 下载最新版本
- 安装时选择"Standard"安装，这会自动安装合适的JDK版本

### 2. 打开项目
- 启动Android Studio
- 选择"Open an existing Android Studio project"
- 导航到项目目录，选择要打开的项目：
  - `webview-library/` - WebView库项目
  - `main-app/` - 主应用项目

### 3. 构建项目
- 等待Gradle同步完成
- 点击"Build" → "Make Project"或使用快捷键
- 对于库项目，选择"Build" → "Make Module 'app'"

## 手动构建方法（需要Java 11+）

如果您想手动构建，需要先安装Java 11或更高版本：

### 安装Java 11 (macOS)
```bash
# 使用Homebrew安装
brew install openjdk@11

# 设置JAVA_HOME
export JAVA_HOME=$(/usr/libexec/java_home -v 11)
export PATH=$JAVA_HOME/bin:$PATH
```

### 验证Java版本
```bash
java -version
# 应该显示Java 11或更高版本
```

### 然后运行构建脚本
```bash
./build.sh
```

## 项目结构说明

### webview-library (库项目)
- 生成AAR文件：`app/build/outputs/aar/app-release.aar`
- 包含闪屏页面和WebView功能
- 支持自定义Logo和URL

### main-app (应用项目)
- 生成APK文件：`app/build/outputs/apk/debug/app-debug.apk`
- 引用webview-library的AAR包
- 提供启动WebView的界面

## 故障排除

### 常见问题
1. **Java版本不兼容**: 确保使用Java 11+
2. **Gradle版本不兼容**: 项目已配置为使用兼容的Gradle版本
3. **依赖下载失败**: 检查网络连接，或使用Android Studio的自动依赖管理

### 获取帮助
- 查看Android Studio的错误日志
- 检查Gradle Console输出
- 参考Android官方文档

## 注意事项
- 第一个项目必须先构建成功，才能构建第二个项目
- 确保网络连接正常，以便下载依赖
- 建议使用Android Studio进行开发，它会自动处理大部分配置问题
