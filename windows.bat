@echo off
setlocal
set "IMAGE=cs240-env"

REM Folder that contains this script and the Dockerfile (works from any folder)
set "SCRIPT_DIR=%~dp0"

if exist "%SCRIPT_DIR%Dockerfile" goto :dockerfile_ok
echo ERROR: Dockerfile not found in:
echo     %SCRIPT_DIR%
echo Copy both windows.bat and Dockerfile into the folder with your code.
goto :fail
:dockerfile_ok

REM Folder to share with Linux: the one given as argument, or the folder this script is in
set "CODE_DIR=%SCRIPT_DIR:~0,-1%"
if not "%~1"=="" set "CODE_DIR=%~f1"
if exist "%CODE_DIR%\" goto :dir_ok
echo ERROR: folder not found: %CODE_DIR%
goto :fail
:dir_ok

REM 1. Is Docker installed?
where docker >nul 2>&1
if not errorlevel 1 goto :docker_installed
echo ERROR: Docker is not installed.
echo Install Docker Desktop: https://www.docker.com/products/docker-desktop/
goto :fail
:docker_installed

REM 2. Is Docker running? If not, open Docker Desktop and wait for it
docker info >nul 2>&1
if not errorlevel 1 goto :docker_ready
echo Docker is not running. Opening Docker Desktop...
echo (If Docker Desktop shows a window asking you to accept terms or sign in, do it.)
start "" "%ProgramFiles%\Docker\Docker\Docker Desktop.exe"
<nul set /p "=Waiting for Docker to start"
for /l %%i in (1,1,90) do (
    docker info >nul 2>&1 && goto :docker_started
    <nul set /p "=."
    timeout /t 2 /nobreak >nul
)
echo.
echo ERROR: Docker did not start.
echo Open Docker Desktop yourself, wait until it says 'Engine running',
echo then run this script again.
goto :fail
:docker_started
echo.
:docker_ready

REM 3. Build the Linux environment (slow only the first time)
docker image inspect %IMAGE% >nul 2>&1
if not errorlevel 1 goto :quick_build
echo First time setup: building the Linux environment.
echo This takes 1-3 minutes. Do not close this window.
docker build -t %IMAGE% "%SCRIPT_DIR%."
if errorlevel 1 goto :build_fail
goto :built
:quick_build
docker build -q -t %IMAGE% "%SCRIPT_DIR%." >nul
if errorlevel 1 goto :build_fail
:built

REM 4. Warn if the shared folder has no C files (usually means wrong folder)
if exist "%CODE_DIR%\*.c" goto :has_c
for /d %%d in ("%CODE_DIR%\*") do if exist "%%d\*.c" goto :has_c
echo WARNING: no .c files found in:
echo     %CODE_DIR%
echo Copy windows.bat and Dockerfile into the folder with your code and run it from there.
set "ANSWER="
set /p "ANSWER=Continue anyway? [y/N] "
if /i not "%ANSWER%"=="y" goto :fail
:has_c

echo ---------------------------------------------------
echo You are now inside Linux.
echo Your folder:  %CODE_DIR%
echo is available here as /code
echo To exit and return to your machine, type 'exit'.
echo ---------------------------------------------------

REM The -v flag mirrors the local folder into the container
docker run --rm -it -v "%CODE_DIR%":/code %IMAGE%
exit /b 0

:build_fail
echo ERROR: could not build the Linux environment. Check your internet connection and try again.
:fail
echo.
pause
exit /b 1
