@echo off
echo 开始构建Android项目...

REM 检查是否在正确的目录
if not exist "webview-library" (
    echo 错误：请在项目根目录运行此脚本
    pause
    exit /b 1
)
if not exist "main-app" (
    echo 错误：请在项目根目录运行此脚本
    pause
    exit /b 1
)

REM 构建第一个项目（WebView库）
echo 步骤1：构建WebView库项目...
cd webview-library

REM 检查gradlew.bat是否存在
if not exist "gradlew.bat" (
    echo 创建gradlew.bat脚本...
    echo @echo off > gradlew.bat
    echo gradle %* >> gradlew.bat
)

REM 构建AAR
echo 执行gradle构建...
call gradlew.bat assembleRelease

if %ERRORLEVEL% EQU 0 (
    echo WebView库构建成功！
) else (
    echo WebView库构建失败！
    pause
    exit /b 1
)

REM 检查AAR文件是否生成
set AAR_FILE=app\build\outputs\aar\app-release.aar
if not exist "%AAR_FILE%" (
    echo 错误：AAR文件未生成：%AAR_FILE%
    pause
    exit /b 1
)

echo AAR文件已生成：%AAR_FILE%

REM 返回根目录
cd ..

REM 复制AAR文件到第二个项目
echo 步骤2：复制AAR文件到主应用项目...
if not exist "main-app\app\libs" mkdir "main-app\app\libs"
copy "%AAR_FILE%" "main-app\app\libs\webviewlibrary-release.aar"

if %ERRORLEVEL% EQU 0 (
    echo AAR文件复制成功！
) else (
    echo AAR文件复制失败！
    pause
    exit /b 1
)

REM 构建第二个项目
echo 步骤3：构建主应用项目...
cd main-app

REM 检查gradlew.bat是否存在
if not exist "gradlew.bat" (
    echo 创建gradlew.bat脚本...
    echo @echo off > gradlew.bat
    echo gradle %* >> gradlew.bat
)

REM 构建APK
echo 执行gradle构建...
call gradlew.bat assembleDebug

if %ERRORLEVEL% EQU 0 (
    echo 主应用项目构建成功！
    echo APK文件位置：app\build\outputs\apk\debug\app-debug.apk
) else (
    echo 主应用项目构建失败！
    pause
    exit /b 1
)

REM 返回根目录
cd ..

echo.
echo 所有项目构建完成！
echo.
echo 构建结果：
echo - WebView库AAR：webview-library\app\build\outputs\aar\app-release.aar
echo - 主应用APK：main-app\app\build\outputs\apk\debug\app-debug.apk
echo.
echo 下一步：
echo 1. 将APK安装到Android设备上
echo 2. 或者在Android Studio中打开项目进行调试
pause
