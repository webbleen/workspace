#!/bin/bash

echo "开始构建Android项目..."

# 检查是否在正确的目录
if [ ! -d "webview-library" ] || [ ! -d "main-app" ]; then
    echo "错误：请在项目根目录运行此脚本"
    exit 1
fi

# 构建第一个项目（WebView库）
echo "步骤1：构建WebView库项目..."
cd webview-library

# 检查gradlew是否存在，如果不存在则创建
if [ ! -f "gradlew" ]; then
    echo "创建gradlew脚本..."
    echo '#!/bin/bash
exec "$JAVACMD" "$@"' > gradlew
    chmod +x gradlew
fi

# 构建AAR
echo "执行gradle构建..."
./gradlew assembleRelease

if [ $? -eq 0 ]; then
    echo "WebView库构建成功！"
else
    echo "WebView库构建失败！"
    exit 1
fi

# 检查AAR文件是否生成
AAR_FILE="app/build/outputs/aar/app-release.aar"
if [ ! -f "$AAR_FILE" ]; then
    echo "错误：AAR文件未生成：$AAR_FILE"
    exit 1
fi

echo "AAR文件已生成：$AAR_FILE"

# 返回根目录
cd ..

# 复制AAR文件到第二个项目
echo "步骤2：复制AAR文件到主应用项目..."
mkdir -p main-app/app/libs
cp "$AAR_FILE" "main-app/app/libs/webviewlibrary-release.aar"

if [ $? -eq 0 ]; then
    echo "AAR文件复制成功！"
else
    echo "AAR文件复制失败！"
    exit 1
fi

# 构建第二个项目
echo "步骤3：构建主应用项目..."
cd main-app

# 检查gradlew是否存在，如果不存在则创建
if [ ! -f "gradlew" ]; then
    echo "创建gradlew脚本..."
    echo '#!/bin/bash
exec "$JAVACMD" "$@"' > gradlew
    chmod +x gradlew
fi

# 构建APK
echo "执行gradle构建..."
./gradlew assembleDebug

if [ $? -eq 0 ]; then
    echo "主应用项目构建成功！"
    echo "APK文件位置：app/build/outputs/apk/debug/app-debug.apk"
else
    echo "主应用项目构建失败！"
    exit 1
fi

# 返回根目录
cd ..

echo ""
echo "所有项目构建完成！"
echo ""
echo "构建结果："
echo "- WebView库AAR：webview-library/app/build/outputs/aar/app-release.aar"
echo "- 主应用APK：main-app/app/build/outputs/apk/debug/app-debug.apk"
echo ""
echo "下一步："
echo "1. 将APK安装到Android设备上"
echo "2. 或者在Android Studio中打开项目进行调试"
