@echo off
chcp 65001
setlocal EnableDelayedExpansion

:menu
echo.
echo 请选择操作
echo.
choice /c 123 /m "【1】设置自动关机 【2】取消自动关机 【3】一键退出"

set "userChoice="
set /a userChoice=%errorlevel%

if not defined userChoice (
    echo 请输入有效的选项（1, 2, 或 3）。
    goto :menu
)

if %userChoice% equ 1 (
    call :setShutdown
) else if %userChoice% equ 2 (
    call :cancelShutdown
) else if %userChoice% equ 3 (
    call :exitScript
) else (
    echo 请输入有效的选项（1, 2, 或 3）。
    goto :menu
)

:setShutdown
echo 设置自动关机？您是否要继续此操作？(Y/N)
set /p choice=
set choice=%choice:~0,1%
if /I "%choice%"=="Y" (
    echo.
    goto Start
) else if /I "%choice%"=="N" (
    echo 您选择了取消
    goto :menu
)
:Start
set /p "shutdownTime=请输入您要设置的关机时间（单位为秒）: "
echo %shutdownTime%| findstr /r "^[0-9]*$">nul
if %errorlevel% equ 0 (
    echo.
    echo 输入的时间为：%shutdownTime%
    shutdown -s -t %shutdownTime%
    echo 已设置自动关机
) else (
    echo 请输入有效的数字。
    goto Start
)

goto :menu

:cancelShutdown
echo 取消自动关机？您是否要继续此操作？(Y/N)
set /p choice=
set choice=!choice:~0,1!

if /I "!choice!"=="Y" (
    echo.
    echo 您选择了是
    shutdown /a
    echo 已取消自动关机
    goto :menu
) else if /I "!choice!"=="N" (
    echo 您选择了取消
)
goto :menu

:exitScript
exit

