# Script to extract binaries from Docker containers and pack as zip
# Run this after docker-compose up -d

Write-Host "=== Extracting CTF Challenge Binaries ===" -ForegroundColor Cyan

# Create output directory
$outputDir = ".\binaries"
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Extract x86 binary
Write-Host "[*] Extracting x86 challenge..." -ForegroundColor Yellow
docker cp pwn-challenge-x86:/home/ctf/challenge "$outputDir\challenge_x86"

# Extract x64 binary
Write-Host "[*] Extracting x64 challenge..." -ForegroundColor Yellow
docker cp pwn-challenge-x64:/home/ctf/challenge "$outputDir\challenge_x64"

# Create README for participants
$readme = @"
# CTF Challenge Binaries

## Connection Info
| Challenge | Command |
|-----------|---------|
| x86 (32-bit) | nc bore.pub 31337 |
| x64 (64-bit) | nc bore.pub 31338 |

## Files
- challenge_x86 - 32-bit binary
- challenge_x64 - 64-bit binary

## Hints
- Buffer size: 32 bytes
- Find the hidden function!
- For x64: Remember stack alignment

Good luck! 🚩
"@

$readme | Out-File -FilePath "$outputDir\README.md" -Encoding UTF8

# Create zip file with password using 7-Zip
$zipPath = ".\ctf_challenges.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath
}

Write-Host "[*] Creating password-protected zip file..." -ForegroundColor Yellow

# Check if 7-Zip is available
$7zipPath = "C:\Program Files\7-Zip\7z.exe"
if (Test-Path $7zipPath) {
    # Use 7-Zip with password
    & $7zipPath a -tzip -p"htb2025" $zipPath "$outputDir\*"
} else {
    # Fallback: try 7z from PATH
    try {
        7z a -tzip -p"htb2025" $zipPath "$outputDir\*"
    } catch {
        Write-Host "[!] 7-Zip not found. Creating zip without password..." -ForegroundColor Red
        Write-Host "[!] Install 7-Zip to create password-protected zips" -ForegroundColor Red
        Compress-Archive -Path "$outputDir\*" -DestinationPath $zipPath
    }
}

Write-Host ""
Write-Host "=== Done! ===" -ForegroundColor Green
Write-Host "Zip file created: $zipPath" -ForegroundColor Green
Write-Host "Password: htb2025" -ForegroundColor Yellow
Write-Host ""
Write-Host "Share this zip with participants!" -ForegroundColor Cyan
