@REM 本脚本由chen6019编写,用于登陆重庆化工职业学院校园网,生成开机自动链接脚本,一键打开开机自启文件夹,一键退出功能
@REM 感谢使用,如果有问题请联系我,qq:2430914975
@echo off
@chcp 65001
@setlocal EnableDelayedExpansion


:menu
echo.
echo 请选择操作
echo.
choice /c 1234 /m "【1】打开登陆网址 【2】生成开机自动链接脚本【3】一键打开开自启文件夹【4】一键退出"
set "userChoice="
set /a userChoice=%errorlevel%


if %userChoice% equ 1 (
    call :setShutdown
) else if %userChoice% equ 2 (
    call :cancelShutdown
)  else if %userChoice% equ 3 (
    call :open
) else if %userChoice% equ 4 (
    call :exitScript
)

:setShutdown
echo.
echo 打开浏览器访问校园网登陆网址？您是否要继续此操作？(Y/N)
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
set "url=http://172.17.100.200/a70.htm"
start "" %url%
goto :menu

:cancelShutdown
echo.
color 04
echo ====================================================
echo 生成开机自动链接脚本？注意:需要你获取到登陆链接(打开校园网登陆网址,打开开发者工具F12,选择网络,打开保留日志,然后登陆校园网,找到第一个get的网址就是了),再次生成会覆盖旧的文件!您是否要继续此操作？(Y/N)
echo ====================================================
set /p choice=
set choice=!choice:~0,1!
if /I "%choice%"=="Y" (
    echo.
    color 07
    goto createScript
) else if /I "%choice%"=="N" (
    echo 您选择了取消
    color 07
    goto :menu
)


:createScript
echo 请输入登陆链接:
set /p url=
echo 是否需要添加 pause？添加会在登陆成功后保留命令提示符窗口(一般由于调试)(Y/N)
set /p addPause=

set "scriptPath=%~dp0登陆校园网.bat"
echo @echo off   > %scriptPath%
echo chcp 65001  >> %scriptPath%
echo setlocal EnableDelayedExpansion >> %scriptPath%
echo echo.  >> %scriptPath%
echo curl "%url%" >> %scriptPath%
echo echo.   >> %scriptPath%
echo echo 有"result":"ok"字样表示已经登陆成功了,诶嘿(o゜▽゜)o☆~(如果没有出现问题的话)!>> %scriptPath%
echo echo.   >> %scriptPath%
if /I "%addPause%"=="Y" (
    echo echo 按任意键退出   >> %scriptPath%
    echo pause   >> %scriptPath%
) else (
    echo 你没有添加 pause,所以登陆后会自动退出脚本
)
REM 定义源路径和目标路径
set "source=%~dp0登陆校园网.bat"
set "destination=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\登陆校园网.bat"

copy "%source%" "%destination%"
echo 将文件复制到系统自启动目录
echo.
set /p choice=是否删除原文件？(输入Y/N) 
echo.
if /i "%choice%"=="Y" (
    del "%source%"
    echo 脚本已复制到系统自启动目录并删除原文件
    echo.
) else (
    echo 脚本已复制到系统自启动目录没有删除原文件
    echo.
)
echo 如果没有出现文件,请把脚本放到一个没有权限问题的目录下再次尝试(如下载目录和桌面)
echo.
goto :menu

:open
start "" shell:startup
goto :menu

:exitScript
exit