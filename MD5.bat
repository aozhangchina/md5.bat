@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title MD5/SHA256计算工具
echo 张敖制作 https://datahold.cn
echo 把本软件放在测试文件相同的目录下运行
echo 更新 2024年2月16日

if "%~1" == "" (
    @REM echo Please drag and drop a file onto this batch file.
    goto n2
)
@REM echo Dragged file information:
@REM echo File name: %~n1
@REM echo File extension: %~x1
@REM echo Full path: "%~f1"
@REM echo Directory: %~dp1

set "filename=%~f1"

echo Selected file: "%filename%"

:: Using CertUtil to calculate MD5 and SHA256 hash values for the selected file
echo 名称：%~n1%~x1

:: 获取并显示所选文件的大小（以KB为单位）
for %%I in ("%filename%") do (
    set /a fileSizeKB=%%~zI / 1024
    echo 大小：!fileSizeKB! KB
)

set "md5hash="
set "sha256hash="

for /f "tokens=* skip=1" %%a in ('CertUtil -hashfile "%filename%" MD5') do (
    set "md5hash=%%a"
    goto displayMD5
)
:displayMD5
echo MD5：%md5hash%

for /f "tokens=* skip=1" %%a in ('CertUtil -hashfile "%filename%" SHA256') do (
    set "sha256hash=%%a"
    goto displaySHA256
)
:displaySHA256
echo SHA256：%sha256hash%
goto eof

:n2
:: 初始化变量
set /a count=1

:: 列出当前目录下所有文件，并给它们编号
echo Available files:
for %%f in (*) do (
    echo !count! - %%f
    set "file!count!=%%f"
    set /a count+=1
)

:: 获取用户输入
set /p choice="Select a file number: "
if "!choice!"=="" goto eof

:: 通过编号获取文件名
set "selectedFile=!file%choice%!"

:: 检查用户是否选择了有效编号
if "!selectedFile!"=="" (
    !selectedFile! = %1
    goto eof
)

:start
:: 使用CertUtil计算所选文件的MD5哈希值，并只显示MD5哈希值

echo 名称："!selectedFile!"

:: 获取并显示所选文件的大小（以KB为单位）
for %%I in ("!selectedFile!") do (
    set /a fileSizeKB=%%~zI / 1024
    echo 大小：!fileSizeKB! KB
)
for /f "tokens=* skip=1" %%a in ('CertUtil -hashfile "!selectedFile!" MD5') do (
    set "md5hash=%%a"
    goto displayMD52
)
:displayMD52
echo MD5：!md5hash!

:: 使用CertUtil计算所选文件的SHA256哈希值，并只显示SHA256哈希值
for /f "tokens=* skip=1" %%a in ('CertUtil -hashfile "!selectedFile!" SHA256') do (
    set "sha256hash=%%a"
    goto displaySHA2562
)

:displaySHA2562
echo SHA256：!sha256hash!

:eof
endlocal

echo 按任意键退出/Press any key to exit.
pause >nul