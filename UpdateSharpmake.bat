@echo off

COLOR

set curdir=%~dp0
set smroot=%~dp0\..\%1Sharpmake

set smproj=Sharpmake.Application\Sharpmake.Application.csproj
set framework=net5.0

echo Initializing Sharpmake
pushd %smroot%
call %smroot%\bootstrap.bat
popd smroot
if %errorlevel% NEQ 0 goto error
COLOR

call :build win-x64
if %errorlevel% NEQ 0 goto error
call :build osx-x64
if %errorlevel% NEQ 0 goto error
call :build linux-x64
if %errorlevel% NEQ 0 goto error

goto success

:build
echo Compiling for %1
pushd %smroot%
call CompileSharpmake.bat %smproj% Release %1 %framework%
popd
if %errorlevel% NEQ 0 exit /b 1

echo Copying Binaries for %1
del /F /Q %curdir%\%1\
mkdir %curdir%\%1
copy %smroot%\Sharpmake.Application\bin\%1\Release\%framework%\%1\publish\*.* %curdir%\%1
exit /b %errorlevel%

@REM -----------------------------------------------------------------------
:success
COLOR 2F
echo Update succeeded^!
timeout /t 5
set ERROR_CODE=0
goto end

@REM -----------------------------------------------------------------------
:error
COLOR 4F
echo Update failed^!
pause
set ERROR_CODE=1
goto end

@REM -----------------------------------------------------------------------
:end
:: restore caller current directory
cd %curdir%
exit /b %ERROR_CODE%
