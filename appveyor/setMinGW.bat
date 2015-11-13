if "%GENERATOR%"=="MinGW Makefiles" (
  set SH_COMMAND=gulash
  move "%PROGRAMFILES%\Git\usr\bin\sh.exe" "%PROGRAMFILES%\Git\usr\bin\%SH_COMMAND%.exe"
  set PATH=%PATH%;%ProgramFiles(x86)%\Windows Kits\10\bin\x86
  echo %PATH%
) else (
  set SH_COMMAND=sh 
)
