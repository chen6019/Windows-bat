@echo off
chcp 65001
setlocal EnableDelayedExpansion

:menu
echo.
echo 请选择操作:
echo.
choice /c 123 /m "【1】查看安装的Linux状态 【2】关闭所有Linux 【3】一键退出"

set "userChoice="
set /a userChoice=%errorlevel%

if not defined userChoice (
    echo 请输入有效的选项（1, 2, 或 3）。
    goto :menu
)

if %userChoice% equ 1 (
    call :View
) else if %userChoice% equ 2 (
    call :Shutdown
) else if %userChoice% equ 3 (
    call :exitScript
) else (
    echo 请输入有效的选项（1, 2, 或 3）。
    goto :menu
)

:View
echo.
echo   名称            状态            版本
wsl --list --verbose

goto :menu

:Shutdown
echo.
echo 关闭所有Linux系统？您是否要继续此操作？(Y/N)
set /p choice=
set choice=!choice:~0,1!

if /I "!choice!"=="Y" (
    echo.
    echo 您选择了是
    echo.
    echo 正在关闭所有Linux系统...
    echo.
    wsl --shutdown
    echo 已关闭所有Linux系统
    goto :menu
) else if /I "!choice!"=="N" (
    echo 您选择了取消
)
goto :menu

:exitScript
exit