@echo off
setlocal enableextensions enabledelayedexpansion

:: Configuration
set IMAGE_NAME=marketanalysisbackend:latest
set CONTAINER_NAME=marketanalysisbackend
set HOST_PORT=8080
set CONTAINER_PORT=8080

:: Detect docker
where docker >nul 2>&1
if errorlevel 1 (
	echo Docker is not installed or not in PATH.
	exit /b 1
)

:: Build image
echo Building image %IMAGE_NAME% ...
docker build -t %IMAGE_NAME% .
if errorlevel 1 (
	echo Build failed.
	exit /b 1
)

:: Stop and remove any existing container with same name
for /f "tokens=*" %%i in ('docker ps -aq -f name=^%CONTAINER_NAME%$') do set EXISTING=%%i
if defined EXISTING (
	echo Removing existing container %CONTAINER_NAME% ...
	docker rm -f %CONTAINER_NAME% >nul 2>&1
)

:: Run container
echo Running container %CONTAINER_NAME% mapping %HOST_PORT%:%CONTAINER_PORT% ...
docker run -d --name %CONTAINER_NAME% -p %HOST_PORT%:%CONTAINER_PORT% --restart unless-stopped %IMAGE_NAME%
if errorlevel 1 (
	echo Failed to start container.
	exit /b 1
)

echo Container is running. Logs will follow. Press Ctrl+C to stop viewing logs.
docker logs -f %CONTAINER_NAME%

endlocal
