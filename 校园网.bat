@REM 本脚本由chen6019编写,用于登陆重庆化工职业学院校园网,生成开机自动链接脚本,一键打开开机自启文件夹,一键退出功能
@REM 感谢使用,如果有问题请联系我,邮箱:mc_chen6019@qq.com
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
echo 生成开机自动登陆脚本?注意:需要你获取到登陆链接(打开校园网的登陆网址,打开开发者工具按F12,选择网络(英文为network),然后登陆校园网,找到第一个get请求的网址就是了),注意:再次生成会覆盖旧的文件!您是否要继续此操作?(Y/N)
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
echo 是否需要添加 pause?添加会在登陆成功后保留结果窗口(一般由于调试)(Y/N或y/n)
set /p addPause=


set "scriptPath=%~dp0登陆校园网.bat"
echo @echo off > %scriptPath%
echo chcp 65001 >> %scriptPath%
echo setlocal EnableDelayedExpansion >> %scriptPath%
echo echo. >> %scriptPath%
echo echo 正在登录校园网... >> %scriptPath%
echo echo. >> %scriptPath%
echo REM 发送请求 >> %scriptPath%
echo for /f "delims=" %%%%a in ('curl "%url%"') do set response=%%%%a >> %scriptPath%
echo echo ^^!response^^! ^| findstr /C:"\"result\":\"ok\"" ^>nul >> %scriptPath%
echo if %%errorlevel%% EQU 0 ( >> %scriptPath%
echo     color 0A >> %scriptPath%
echo     echo 登录成功 >> %scriptPath%
echo     echo. >> %scriptPath%
echo     echo 将于3秒后关闭本脚本 >> %scriptPath%
echo     timeout /t 3 >> %scriptPath%
if /I "%addPause%"=="Y" (
    echo    echo 按任意键退出   >> %scriptPath%
    echo    pause   >> %scriptPath%
) else (
    echo.
    echo 你没有添加pause,所以登陆后会自动退出脚本
    echo.
)
echo ) else ( >> %scriptPath%
echo     color 04 >> %scriptPath%
echo     echo 登陆失败! >> %scriptPath%
echo     echo 返回值中不包含 "result":"ok" 字样！ >> %scriptPath%
echo     echo 请检登陆网址和网络连接是否正确！ >> %scriptPath%
echo     echo 或联系开发者！ >> %scriptPath%
echo     echo. >> %scriptPath%
echo     echo. >> %scriptPath%
echo     echo 输入任意键退出... >> %scriptPath%
echo     pause >> %scriptPath%
echo ) >> %scriptPath%



REM 定义源路径和目标路径
set "source=%~dp0登陆校园网.bat"
set "destination=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\登陆校园网.bat"

echo 正在将文件复制到系统自启动目录
copy "%source%" "%destination%"
REM 检查文件是否成功复制
if exist "%destination%" (
    echo 文件成功复制到目标路径
) else (
    echo 文件复制失败，请检查源路径和目标路径是否正确
)
echo.
set /p choice=是否删除原文件?(输入Y/N) 
echo.
if /i "%choice%"=="Y" (
    del "%source%"
    echo 以删除原文件
    echo.
) else (
    echo 没有删除原文件
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