# 🚀 QUICK START - Android Device Testing

## Masalah Anda
HP Android tidak bisa akses `localhost` laptop. Perlu cara agar HP connect ke backend.

## ✅ Solusi Tercepat: NGROK (2 Menit Setup)

### Step 1: Download & Install Ngrok
1. Download: https://ngrok.com/download
2. Extract file zip
3. Simpan `ngrok.exe` di folder mudah diakses (misal: `C:\ngrok\`)

### Step 2: Sign Up & Get Auth Token (Free)
1. Sign up di: https://dashboard.ngrok.com/signup
2. Copy **Auth Token** dari dashboard
3. Authenticate (jalankan sekali):
```bash
C:\ngrok\ngrok.exe config add-authtoken YOUR_TOKEN_HERE
```

### Step 3: Jalankan Backend
**Terminal 1:**
```bash
cd d:\Spatium\Spatium-Backend
go run main.go
```
Backend akan running di `localhost:8080`

### Step 4: Start Ngrok Tunnel
**Terminal 2 (PowerShell BARU):**
```bash
cd d:\Spatium\Spatium
.\start-ngrok.ps1
```

Atau manual:
```bash
C:\ngrok\ngrok.exe http 8080
```

Anda akan melihat:
```
Forwarding    https://abc123.ngrok-free.app -> http://localhost:8080
```

**COPY URL** yang `https://abc123.ngrok-free.app`

### Step 5: Update API URL di Flutter
Buka file: `lib\core\constants\api_constants.dart`

Ganti baris ini:
```dart
// SEBELUM (comment yang lama):
// static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

// SETELAH (paste URL ngrok + /api/v1):
static const String baseUrl = 'https://abc123.ngrok-free.app/api/v1';
```

**SAVE FILE**

### Step 6: Run Flutter di HP
**Terminal 3:**
```bash
cd d:\Spatium\Spatium

# Colok HP via USB
# Enable USB Debugging di HP

# Check device terdeteksi
flutter devices

# Run app
flutter run
```

### Step 7: Test di HP
1. Login di app
2. Buka Chat AI
3. Kirim pesan ke AI
4. ✅ **BERHASIL!**

---

## 🔄 Catatan Penting

### Setiap Kali Restart Ngrok:
- URL ngrok akan **BERUBAH** (contoh: `abc123` jadi `xyz789`)
- Anda harus **UPDATE `api_constants.dart`** dengan URL baru
- Lalu **restart Flutter app** (`r` di terminal atau `flutter run` lagi)

### Ngrok URL Tetap (Optional):
- Free tier: URL berubah tiap restart
- Paid tier ($8/month): URL tetap selamanya

---

## 🆘 Troubleshooting

### Error: "ngrok not found"
```bash
# Gunakan full path
C:\ngrok\ngrok.exe http 8080
```

### Error: "Connection refused" di HP
- ✅ Pastikan ngrok masih running
- ✅ Pastikan backend masih running
- ✅ Check URL di `api_constants.dart` sudah benar
- ✅ Test URL di browser laptop: https://abc123.ngrok-free.app/api/v1/health

### Backend tidak response
- Check console log backend
- Pastikan database PostgreSQL running
- Check `.env` file ada `OPENAI_API_KEY`

### Flutter tidak connect
1. Stop app (Ctrl+C)
2. Update `api_constants.dart`
3. `flutter run` lagi

---

## 📱 Alternative: WiFi Local IP

Jika laptop dan HP di **WiFi yang sama**:

### Cari IP Laptop:
```bash
ipconfig
```
Cari **IPv4 Address** WiFi adapter (contoh: `192.168.1.100`)

### Update Flutter:
```dart
static const String baseUrl = 'http://192.168.1.100:8080/api/v1';
```

### Allow Firewall:
- Windows Firewall → Inbound Rules → New Rule
- Port → TCP → 8080 → Allow

**DONE!**

---

## ✅ Checklist

Before testing:
- [ ] Ngrok downloaded & authenticated
- [ ] Backend running (`go run main.go`)
- [ ] Ngrok running (`ngrok http 8080`)
- [ ] URL copied dari ngrok
- [ ] `api_constants.dart` updated dengan URL ngrok
- [ ] HP connected via USB & USB debugging enabled
- [ ] `flutter run` executed

---

**Need help?** Check: `CONNECT_ANDROID_TO_BACKEND.md` untuk detail lengkap
