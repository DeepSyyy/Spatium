# Ngrok Setup Helper
# Script untuk memudahkan setup ngrok

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  NGROK QUICK START" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if ngrok is installed
$ngrokPath = Get-Command ngrok -ErrorAction SilentlyContinue

if (-not $ngrokPath) {
    Write-Host "❌ Ngrok belum terinstall" -ForegroundColor Red
    Write-Host ""
    Write-Host "Cara install:" -ForegroundColor Yellow
    Write-Host "1. Download dari: https://ngrok.com/download" -ForegroundColor White
    Write-Host "2. Extract zip file" -ForegroundColor White
    Write-Host "3. (Optional) Tambahkan ke PATH atau simpan di folder ini" -ForegroundColor White
    Write-Host ""
    Write-Host "Setelah install, jalankan script ini lagi" -ForegroundColor Yellow
    Write-Host ""
    exit
}

Write-Host "✓ Ngrok sudah terinstall di: $($ngrokPath.Path)" -ForegroundColor Green
Write-Host ""

# Check if backend is running
$backendRunning = $false
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/v1/health" -Method GET -TimeoutSec 2 -ErrorAction SilentlyContinue
    $backendRunning = $true
    Write-Host "✓ Backend sudah running di port 8080" -ForegroundColor Green
} catch {
    Write-Host "⚠ Backend belum running di port 8080" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Jalankan backend dulu di terminal lain:" -ForegroundColor Yellow
    Write-Host "  cd d:\Spatium\Spatium-Backend" -ForegroundColor Gray
    Write-Host "  go run main.go" -ForegroundColor Gray
    Write-Host ""
    
    $continue = Read-Host "Apakah backend sudah running? (y/n)"
    if ($continue -ne "y") {
        Write-Host "Script dibatalkan. Jalankan backend dulu." -ForegroundColor Red
        exit
    }
}

Write-Host ""
Write-Host "🚀 Memulai ngrok tunnel..." -ForegroundColor Cyan
Write-Host ""
Write-Host "CATATAN PENTING:" -ForegroundColor Yellow
Write-Host "- Setelah ngrok start, Anda akan melihat URL seperti: https://abc123.ngrok-free.app" -ForegroundColor White
Write-Host "- COPY URL tersebut" -ForegroundColor White
Write-Host "- Update di: lib\core\constants\api_constants.dart" -ForegroundColor White
Write-Host "- Tambahkan /api/v1 di akhir URL" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C untuk stop ngrok" -ForegroundColor Gray
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Start ngrok
& ngrok http 8080
