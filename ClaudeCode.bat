@echo off
pushd "%~DP0"
set "CCROOT=D:\Prog\ProgIDE\ClaudeCode"
set "CCEXE=%CCROOT%\App\node_modules\@anthropic-ai\claude-code\bin\claude.exe"
set "CFG=%CCROOT%\Home\settings.json"

if not exist "%CCEXE%" goto MISSING_EXE
if not exist "%CFG%" goto MISSING_CFG

set "CLAUDE_CONFIG_DIR=%CCROOT%\Home"
set "PATH=%CCROOT%\Runtime;%PATH%"

set "DISABLE_AUTOUPDATER=1"
set "DISABLE_TELEMETRY=1"
set "ANTHROPIC_DISABLE_TELEMETRY=true"
set "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1"
rem 下面这条代表--permission-mode bypassPermissions
set "CLAUDE_CODE_EVEN_MORE_DANGEROUSLY_SKIP_PERMISSIONS=1"
set "CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE=0"
set "NO_PROXY=opencode.ai,api.deepseek.com"
set "no_proxy=opencode.ai,api.deepseek.com"
echo 以下文字已复制，请在Claude Code Cli中粘贴让他开始执行：
echo.
echo 请对全局设置以下操作要求，确保对以后本机上的每个项目都有效：
echo 1.请设置升级、查询源为国内源；
echo 2.所有记忆信息保存在本文件夹而不要保存到任何其他文件夹；如果本文件夹已有保存的记忆请复用
echo 3.所有项目的提示和选项请用中文显示
echo.
(
echo 请对全局设置以下操作要求，确保对以后本机上的每个项目都有效：
echo 1.请设置升级、查询源为国内源；
echo 2.所有记忆信息保存在本文件夹而不要保存到任何其他文件夹；如果本文件夹已有保存的记忆请复用
echo 3.所有项目的提示和选项请用中文显示
) | clip
set continue=--permission-mode bypassPermissions
dir claude.md>nul 2>nul&& set continue=--permission-mode bypassPermissions  --continue||echo ok>claude.md
"%CCEXE%" %* %continue%


set "RC=%ERRORLEVEL%"
endlocal & exit /b %RC%

:MISSING_EXE
echo ERROR: Claude Code binary not found:
echo   %CCEXE%
echo Reinstall, or run the environment check tool.
exit /b 1

:MISSING_CFG
echo ERROR: settings.json not found:
echo   %CFG%
echo Run one of the key config .py scripts in this folder.
exit /b 1
