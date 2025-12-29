# Quick Setup Script untuk Android Device Testing
# Gunakan PowerShell untuk run script ini

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SPATIUM - Android Device Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to check if command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

Write-Host "Pilih metode koneksi:" -ForegroundColor Yellow
Write-Host "1. Ngrok Tunnel (Recommended for USB device)" -ForegroundColor Green
Write-Host "2. WiFi Local IP (Jika laptop dan HP di WiFi yang sama)" -ForegroundColor Green
Write-Host "3. Show current IP addresses" -ForegroundColor Green
Write-Host ""

$choice = Read-Host "Pilih (1/2/3)"

if ($choice -eq "1") {
    Write-Host ""
    Write-Host "=== SETUP NGROK ===" -ForegroundColor Cyan
    
    # Check if ngrok installed
    if (Test-Command ngrok) {
        Write-Host "✓ Ngrok sudah terinstall" -ForegroundColor Green
    } else {
        Write-Host "✗ Ngrok belum terinstall" -ForegroundColor Red
        Write-Host ""
        Write-Host "Download ngrok dari: https://ngrok.com/download" -ForegroundColor Yellow
        Write-Host "Setelah download:" -ForegroundColor Yellow
        Write-Host "1. Extract file zip" -ForegroundColor White
        Write-Host "2. Copy ngrok.exe ke folder yang ada di PATH" -ForegroundColor White
        Write-Host "   Atau jalankan dari folder download: .\ngrok.exe http 8080" -ForegroundColor White
        Write-Host ""
        exit
    }
    
    Write-Host ""
    Write-Host "Langkah selanjutnya:" -ForegroundColor Yellow
    Write-Host "1. Pastikan backend sudah running di port 8080" -ForegroundColor White
    Write-Host "   cd d:\Spatium\Spatium-Backend" -ForegroundColor Gray
    Write-Host "   go run main.go" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Jalankan ngrok di terminal BARU:" -ForegroundColor White
    Write-Host "   ngrok http 8080" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Copy URL dari output ngrok (contoh: https://abc123.ngrok-free.app)" -ForegroundColor White
    Write-Host ""
    Write-Host "4. Update file: lib\core\constants\api_constants.dart" -ForegroundColor White
    Write-Host "   Ganti baseUrl dengan URL ngrok + /api/v1" -ForegroundColor White
    Write-Host "   Contoh: https://abc123.ngrok-free.app/api/v1" -ForegroundColor Gray
    Write-Host ""
    Write-Host "5. Run Flutter app:" -ForegroundColor White
    Write-Host "   flutter run" -ForegroundColor Gray
    Write-Host ""
    
} elseif ($choice -eq "2") {
    Write-Host ""
    Write-Host "=== SETUP WIFI LOCAL IP ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "IP Addresses laptop Anda:" -ForegroundColor Yellow
    Write-Host ""
    
    # Get WiFi IP
    $wifiIP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Wi-Fi*" -ErrorAction SilentlyContinue).IPAddress
    
    if ($wifiIP) {
        Write-Host "WiFi IP Address: $wifiIP" -ForegroundColor Green
        Write-Host ""
        Write-Host "Gunakan URL berikut di api_constants.dart:" -ForegroundColor Yellow
        Write-Host "http://${wifiIP}:8080/api/v1" -ForegroundColor White
    } else {
        Write-Host "Tidak menemukan WiFi connection" -ForegroundColor Red
        Write-Host "Pastikan laptop terkoneksi ke WiFi" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "Langkah selanjutnya:" -ForegroundColor Yellow
    Write-Host "1. Pastikan HP dan laptop di WiFi yang SAMA" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Update file: lib\core\constants\api_constants.dart" -ForegroundColor White
    Write-Host "   Ganti baseUrl dengan IP di atas" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Allow firewall (jika belum):" -ForegroundColor White
    Write-Host "   - Windows Defender Firewall > Inbound Rules > New Rule" -ForegroundColor Gray
    Write-Host "   - Port > TCP > 8080 > Allow" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. Run backend dan Flutter app" -ForegroundColor White
    Write-Host ""
    
} elseif ($choice -eq "3") {
    Write-Host ""
    Write-Host "=== NETWORK INFORMATION ===" -ForegroundColor Cyan
    Write-Host ""
    
    # Show all IPv4 addresses
    $adapters = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*"}
    
    foreach ($adapter in $adapters) {
        Write-Host "Interface: $($adapter.InterfaceAlias)" -ForegroundColor Yellow
        Write-Host "IP Address: $($adapter.IPAddress)" -ForegroundColor Green
        Write-Host "URL untuk Flutter: http://$($adapter.IPAddress):8080/api/v1" -ForegroundColor White
        Write-Host ""
    }
    
} else {
    Write-Host "Pilihan tidak valid" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Dokumentasi lengkap: CONNECT_ANDROID_TO_BACKEND.md" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
