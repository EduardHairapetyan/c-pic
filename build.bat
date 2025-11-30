@echo off
setlocal enabledelayedexpansion

set OPTIMIZATION_LEVEL=-Os

rmdir /s /q bin 2>nul

rem ==== Windows classic builds  =====

@REM call compiler.bat   bin\windows i386-pc-windows-msvc ^
@REM                     windows_i386  ^
@REM                     src\*.c ^
@REM                     -DARCHITECTURE_I386 ^
@REM                     -DPLATFORM_WINDOWS ^
@REM                     -DPLATFORM_WINDOWS_I386 ^
@REM                     %OPTIMIZATION_LEVEL%
@REM if errorlevel 1 goto :end

@REM call compiler.bat   bin\windows x86_64-pc-windows-msvc ^
@REM                     windows_amd64 ^
@REM                     src\*.c ^
@REM                     -DARCHITECTURE_AMD64 ^
@REM                     -DPLATFORM_WINDOWS ^
@REM                     -DPLATFORM_WINDOWS_AMD64 ^
@REM                     %OPTIMIZATION_LEVEL% 
@REM if errorlevel 1 goto :end
@REM goto :end

@REM call compiler.bat   bin\windows aarch64-pc-windows-msvc ^
@REM                     windows_arm64 ^
@REM                     src\*.c ^
@REM                     -DARCHITECTURE_ARM64 ^
@REM                     -DPLATFORM_WINDOWS ^
@REM                     -DPLATFORM_WINDOWS_ARM64 ^
@REM                     %OPTIMIZATION_LEVEL%
@REM if errorlevel 1 goto :end
@REM call compiler.bat   bin\windows armv7a-pc-windows-msvc ^
@REM                     windows_arm32 ^
@REM                     src\*.c ^
@REM                     -DARCHITECTURE_ARM32 ^
@REM                     -DPLATFORM_WINDOWS ^
@REM                     -DPLATFORM_WINDOWS_ARM32 ^
@REM                     %OPTIMIZATION_LEVEL%
@REM if errorlevel 1 

rem ===== Windows payloads (built with linux triples, but PLATFORM_WINDOWS macros) =====
call pic-compiler.bat  bin\windows i386-unknown-linux-gnu ^
                    windows_i386  ^
                    src\*.c ^
                    -DARCHITECTURE_I386 ^
                    -DPLATFORM_WINDOWS ^
                    -DPLATFORM_WINDOWS_I386 ^
                    %OPTIMIZATION_LEVEL% ^
                    -fshort-wchar 
if errorlevel 1 goto :end

call pic-compiler.bat  bin\windows x86_64-unknown-linux-gnu ^
                    windows_amd64 ^
                    src\*.c ^
                    -DARCHITECTURE_AMD64 ^
                    -DPLATFORM_WINDOWS ^
                    -DPLATFORM_WINDOWS_AMD64 ^
                    %OPTIMIZATION_LEVEL% ^
                    -fshort-wchar
if errorlevel 1 goto :end

call pic-compiler.bat  bin\windows thumbv7a-none-linux-gnueabi ^
                    windows_arm32 ^
                    src\*.c ^
                    -DARCHITECTURE_ARM32 ^
                    -DPLATFORM_WINDOWS ^
                    -DPLATFORM_WINDOWS_ARM32 ^
                    %OPTIMIZATION_LEVEL% ^
                    -fshort-wchar
if errorlevel 1 goto :end

call pic-compiler.bat  bin\windows aarch64-unknown-linux-gnu ^
                    windows_arm64 ^
                    src\*.c ^
                    -DARCHITECTURE_ARM64 ^
                    -DPLATFORM_WINDOWS ^
                    -DPLATFORM_WINDOWS_ARM64 ^
                    %OPTIMIZATION_LEVEL% ^
                    -fshort-wchar
if errorlevel 1 goto :end

rem ===== Linux payloads =====
call pic-compiler.bat  bin\linux i386-unknown-linux-gnu ^
                    linux_i386 ^
                    src\*.c ^
                    -DARCHITECTURE_I386 ^
                    -DPLATFORM_LINUX ^
                    -DPLATFORM_LINUX_I386 ^
                    %OPTIMIZATION_LEVEL%
if errorlevel 1 goto :end

call pic-compiler.bat  bin\linux x86_64-unknown-linux-gnu ^
                    linux_amd64 ^
                    src\*.c ^
                    -DARCHITECTURE_AMD64 ^
                    -DPLATFORM_LINUX ^
                    -DPLATFORM_LINUX_AMD64 ^
                    %OPTIMIZATION_LEVEL%
if errorlevel 1 goto :end

call pic-compiler.bat  bin\linux aarch64-unknown-linux-gnu ^
                    linux_arm64 ^
                    src\*.c ^
                    -DARCHITECTURE_ARM64 ^
                    -DPLATFORM_LINUX ^
                    -DPLATFORM_LINUX_ARM64 ^
                    %OPTIMIZATION_LEVEL%
if errorlevel 1 goto :end

:end
endlocal
