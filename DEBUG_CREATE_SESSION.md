# 🐛 Debug Guide - Chat AI Create Session

## Perubahan yang Sudah Dibuat

### 1. ✅ Error Handling & Feedback
- **Dialog validasi**: Minimal 3 karakter untuk judul session
- **SnackBar notification**: Tampil saat success/error
- **Debug logging**: Print statements di console untuk tracking

### 2. ✅ Loading States
- Tombol + disabled saat loading
- Loading indicator dengan text "Memuat..."
- Better UI flow

### 3. ✅ Debug Logs
Sekarang Anda bisa lihat di console/logcat:
- 🟢 = Start process
- 🔵 = Network request
- ✅ = Success
- ❌ = Error

## Cara Test Ulang

### 1. Restart Flutter App
```bash
# Di terminal Flutter, tekan 'r' untuk hot reload
# Atau 'R' untuk hot restart
# Atau stop dan run lagi
flutter run
```

### 2. Test Create Session
1. Buka Chat AI page
2. Tekan tombol `+` di kanan atas
3. **Dialog harus muncul** dengan:
   - Title "Percakapan Baru"
   - Text field dengan hint "Contoh: Curhat Hari Ini"
   - Tombol "Batal" dan "Buat"

4. **Test validasi**:
   - Coba klik "Buat" tanpa isi → Harus muncul error "Judul tidak boleh kosong"
   - Ketik "ab" → Klik "Buat" → Error "Judul minimal 3 karakter"
   - Ketik "Test" → Klik "Buat" → **HARUS SUCCESS**

5. **Setelah success**:
   - ✅ SnackBar hijau muncul: "Session 'Test' berhasil dibuat!"
   - ✅ Halaman berubah dari kosong ke chat interface
   - ✅ Title di AppBar berubah jadi "Test"
   - ✅ Text input di bawah aktif

### 3. Check Console Logs

Lihat di **Debug Console** / **Logcat**:

#### ✅ Jika SUCCESS, akan muncul:
```
🟢 ChatNotifier: Creating session with title: Test
🔵 Creating session with title: Test
🔵 Response status: 200
🔵 Response data: {success: true, message: ..., data: {...}}
✅ Session created: <uuid>
✅ ChatNotifier: Session created successfully: <uuid>
✅ ChatNotifier: State updated. Current session: Test
```

#### ❌ Jika ERROR, akan muncul:
```
🟢 ChatNotifier: Creating session with title: Test
🔵 Creating session with title: Test
❌ DioException: <error message>
❌ Response: <error data>
❌ ChatNotifier: Failed to create session: <error>
```

## Troubleshooting

### Dialog Tidak Muncul
**Kemungkinan**: Tombol + tidak berfungsi
- Check: Tombol + disabled (abu-abu) = sedang loading
- Solusi: Tunggu loading selesai, atau restart app

### Dialog Muncul, Tapi "Buat" Tidak Respon
**Kemungkinan**: Validasi tidak lolos atau input kosong
- Check: Apakah ada error text merah di bawah TextField?
- Solusi: Ketik minimal 3 karakter

### Session Tidak Terbuat
**Check Console Logs**:

#### Error: "Network error" / "Connection refused"
- Backend tidak running
- Ngrok mati
- URL salah di `api_constants.dart`
- **Solusi**: 
  ```bash
  # Check backend
  cd d:\Spatium\Spatium-Backend
  go run main.go
  
  # Check ngrok (jika pakai)
  ngrok http 8080
  
  # Update api_constants.dart dengan URL ngrok baru
  ```

#### Error: "Unauthorized" / 401
- Token expired atau invalid
- **Solusi**: Logout dan login ulang

#### Error: "Failed to create session"
- Backend error
- Database error
- **Check**: Backend console log untuk error detail

### SnackBar Tidak Muncul
- **Normal**: Kadang tertutup keyboard
- **Solusi**: Scroll ke atas atau tap di luar keyboard

## Test Checklist

Setelah fix:
- [ ] Hot reload/restart app berhasil
- [ ] Masuk ke Chat AI page
- [ ] Tekan tombol + → Dialog muncul
- [ ] Input kurang dari 3 char → Error muncul
- [ ] Input "Test Session" → Klik Buat
- [ ] SnackBar hijau muncul (success)
- [ ] Halaman berubah ke chat interface
- [ ] Title AppBar = "Test Session"
- [ ] Bisa ketik pesan di text field
- [ ] Console log menunjukkan success (✅)

## Jika Masih Tidak Berfungsi

1. **Copy console log** yang ada ❌ (error)
2. **Screenshot** UI saat error
3. **Share** ke saya untuk analisis lebih lanjut

---

**Status**: Debug logs aktif, validasi enabled, error handling lengkap
**Next**: Test di real device dan monitor console
