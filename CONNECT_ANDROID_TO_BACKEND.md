# 🔌 Cara Menghubungkan HP Android ke Backend

## Masalah
- Backend running di **localhost:8080** di laptop
- HP Android tidak bisa akses **localhost** laptop
- Perlu cara agar HP bisa connect ke backend via internet/network

## ✅ SOLUSI 1: Ngrok Tunneling (PALING MUDAH)

### Kelebihan:
- ✅ Tidak perlu WiFi yang sama
- ✅ Bisa diakses dari mana saja
- ✅ Cepat setup (2 menit)
- ✅ Gratis untuk testing

### Cara Setup:

#### 1. Install Ngrok
Download dari: https://ngrok.com/download
Extract dan simpan di folder yang mudah diakses.

#### 2. Sign Up (Free)
- Buka https://dashboard.ngrok.com/signup
- Copy Auth Token dari dashboard

#### 3. Authenticate Ngrok
```bash
# Di command prompt/powershell
.\ngrok.exe authtoken YOUR_AUTH_TOKEN
```

#### 4. Jalankan Backend
```bash
cd d:\Spatium\Spatium-Backend
go run main.go
```
Backend akan running di **localhost:8080**

#### 5. Expose Backend dengan Ngrok
**Buka terminal/cmd baru**, jalankan:
```bash
ngrok http 8080
```

Anda akan melihat output seperti:
```
Forwarding   https://abc123.ngrok-free.app -> http://localhost:8080
```

#### 6. Update API URL di Flutter
Copy URL ngrok (contoh: `https://abc123.ngrok-free.app`)

Buka `lib/core/constants/api_constants.dart` dan ganti:
```dart
// Ganti baseUrl dengan URL ngrok
static const String baseUrl = 'https://abc123.ngrok-free.app/api/v1';
```

#### 7. Run Flutter App di HP
```bash
cd d:\Spatium\Spatium
flutter run
```

**DONE!** HP Anda sekarang bisa connect ke backend via ngrok tunnel.

---

## ✅ SOLUSI 2: IP Address WiFi (Jika di Network Sama)

### Kelebihan:
- ✅ Tidak perlu install apa-apa
- ✅ Koneksi lebih cepat
- ✅ Tidak perlu internet

### Syarat:
- Laptop dan HP harus di **WiFi yang sama**

### Cara Setup:

#### 1. Cari IP Address Laptop
**Windows:**
```bash
ipconfig
```
Cari **IPv4 Address** di **WiFi adapter** (contoh: `192.168.1.100`)

#### 2. Update API URL di Flutter
Buka `lib/core/constants/api_constants.dart`:
```dart
// Ganti dengan IP laptop
static const String baseUrl = 'http://192.168.1.100:8080/api/v1';
```

#### 3. Allow Firewall (Windows)
Pastikan port 8080 tidak diblokir firewall:
- Buka **Windows Defender Firewall**
- **Advanced Settings** → **Inbound Rules**
- **New Rule** → Port → TCP → 8080 → Allow

#### 4. Run Backend & Flutter
```bash
# Terminal 1: Backend
cd d:\Spatium\Spatium-Backend
go run main.go

# Terminal 2: Flutter
cd d:\Spatium\Spatium
flutter run
```

**DONE!** HP akan connect via WiFi local.

---

## ✅ SOLUSI 3: Deploy Backend ke Railway (Production-Ready)

### Kelebihan:
- ✅ Backend online 24/7
- ✅ Bisa diakses dari mana saja
- ✅ Gratis tier cukup untuk testing
- ✅ Professional setup

### Cara Deploy:

#### 1. Sign Up Railway
- Buka https://railway.app/
- Sign up dengan GitHub

#### 2. Deploy Backend
```bash
cd d:\Spatium\Spatium-Backend

# Install Railway CLI
# Download dari: https://docs.railway.app/develop/cli

# Login
railway login

# Deploy
railway up
```

#### 3. Set Environment Variables di Railway Dashboard
- Buka project di Railway
- Tambahkan env variables:
  - `DATABASE_URL` (Railway PostgreSQL)
  - `JWT_SECRET`
  - `OPENAI_API_KEY`

#### 4. Get Public URL
Railway akan berikan URL seperti: `https://your-app.railway.app`

#### 5. Update API URL di Flutter
```dart
static const String baseUrl = 'https://your-app.railway.app/api/v1';
```

---

## 🎯 REKOMENDASI SAYA: Gunakan Ngrok

Untuk testing cepat, **ngrok adalah pilihan terbaik**:
1. Setup cepat (2 menit)
2. Tidak perlu setting network
3. Gratis dan mudah

### Quick Start Ngrok:

1. **Download ngrok**: https://ngrok.com/download
2. **Jalankan backend**: `go run main.go`
3. **Expose dengan ngrok**: `ngrok http 8080`
4. **Copy URL ngrok** (contoh: `https://abc123.ngrok-free.app`)
5. **Update `api_constants.dart`**

---

## 📱 Troubleshooting

### Error: "Connection refused" / "Network error"
- ✅ Pastikan backend running
- ✅ Pastikan URL sudah benar
- ✅ Test URL di browser laptop dulu
- ✅ Check firewall tidak block

### Error: "Invalid Host header" (ngrok)
Tambahkan di backend (jika pakai Express/Node):
```go
// Di file main.go atau server setup, tambahkan CORS
```

Untuk Go Fiber sudah otomatis handle, tapi pastikan CORS enabled.

### URL Ngrok Berubah Terus
- Ngrok free tier URL berubah tiap restart
- Untuk URL tetap, upgrade ke paid plan ($8/month)
- Atau deploy ke Railway untuk permanent URL

---

## 🔐 SECURITY NOTES

⚠️ **Untuk Production:**
- Jangan expose backend production dengan ngrok
- Gunakan HTTPS
- Set proper CORS
- Gunakan environment variables
- Deploy ke cloud service (Railway, Heroku, etc)

---

## Next Steps

Setelah pilih salah satu cara di atas, test dengan:
1. ✅ Login di app
2. ✅ Buka Chat AI
3. ✅ Kirim pesan
4. ✅ Cek response AI

Good luck! 🚀
