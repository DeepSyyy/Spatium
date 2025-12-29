# Chat AI Feature - Integration Guide

## Fitur Chat AI Sudah Terimplementasi! 🎉

Fitur Chat AI telah berhasil diintegrasikan antara backend (Go) dan frontend (Flutter). Berikut adalah informasi lengkap tentang implementasi dan cara testing.

## Struktur Implementasi

### Backend (Go)
- **Endpoints**:
  - `POST /api/v1/chat/session` - Buat session chat baru
  - `GET /api/v1/chat/session` - Ambil semua session user
  - `DELETE /api/v1/chat/session/:id` - Hapus session
  - `POST /api/v1/chat/:session_id` - Kirim pesan ke AI
  - `GET /api/v1/chat/:session_id/messages` - Ambil semua pesan dalam session
  - `GET /api/v1/chat/:session_id/last` - Ambil pesan terakhir

- **AI Integration**: Menggunakan OpenAI API (GPT-4o-mini) untuk generate response otomatis
- **Models**:
  - `ChatSession` - Session percakapan
  - `ChatMessage` - Individual message (user/ai)

### Frontend (Flutter)
- **Architecture**: Clean Architecture dengan Riverpod
- **Files Created**:
  ```
  lib/features/chat_ai/
  ├── data/
  │   ├── models/
  │   │   ├── chat_session_model.dart
  │   │   └── chat_message_model.dart
  │   ├── datasources/
  │   │   └── chat_remote_data_source.dart
  │   └── repositories/
  │       └── chat_repository_impl.dart
  ├── presentation/
  │   ├── providers/
  │   │   ├── chat_providers.dart
  │   │   ├── chat_state.dart
  │   │   └── chat_notifier.dart
  │   ├── page/
  │   │   └── chat_ai_page.dart
  │   └── widgets/
  │       ├── chat_message_bubble.dart
  │       └── new_session_dialog.dart
  ```

## Cara Testing

### 1. Pastikan Backend Berjalan

```bash
cd Spatium-Backend

# Pastikan .env sudah diatur dengan:
# - DATABASE_URL
# - JWT_SECRET
# - OPENAI_API_KEY (WAJIB untuk AI)

# Jalankan backend
go run main.go
```

Backend akan berjalan di `http://localhost:8080`

### 2. Konfigurasi Frontend

Pastikan `ApiConstants.baseUrl` di `lib/core/constants/api_constants.dart` sudah benar:

```dart
// Untuk Android Emulator
static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

// Untuk iOS Simulator atau Web
// static const String baseUrl = 'http://localhost:8080/api/v1';
```

### 3. Jalankan Flutter App

```bash
cd Spatium

# Install dependencies jika belum
flutter pub get

# Run app (Android/iOS)
flutter run

# Atau untuk web
# flutter run -d chrome
```

### 4. Testing Flow

1. **Login** terlebih dahulu dengan akun yang sudah terdaftar
2. **Navigasi** ke halaman Chat AI (dari menu/navigation)
3. **Buat Session Baru**:
   - Tekan tombol `+` di app bar
   - Masukkan judul session (contoh: "Curhat Hari Ini")
   - Tekan "Buat"
4. **Kirim Pesan**:
   - Ketik pesan di text field bawah
   - Tekan icon send atau Enter
   - Tunggu response AI (akan muncul indikator "AI sedang mengetik...")
5. **Response AI** akan muncul otomatis setelah beberapa detik

### 5. Troubleshooting

#### Error: "Failed to get sessions"
- **Solusi**: Pastikan user sudah login dan token valid
- Cek di log backend apakah request sampai

#### Error: "Network error" / "Connection refused"
- **Solusi**: 
  - Pastikan backend berjalan
  - Cek URL di `api_constants.dart` sudah benar
  - Untuk Android Emulator gunakan `10.0.2.2` bukan `localhost`

#### AI Tidak Merespons
- **Solusi**:
  - Pastikan `OPENAI_API_KEY` ada di `.env` backend
  - Cek log backend untuk error AI
  - Pastikan ada balance di OpenAI account

#### Messages Tidak Muncul
- **Solusi**:
  - Reload messages dengan pull-to-refresh (jika ada)
  - Atau buat session baru

## API Request Examples (untuk Testing Manual)

### 1. Create Session
```bash
curl -X POST http://localhost:8080/api/v1/chat/session \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Session"}'
```

### 2. Send Message
```bash
curl -X POST http://localhost:8080/api/v1/chat/SESSION_ID \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"content":"Halo AI, apa kabar?","sender":"user"}'
```

### 3. Get Messages
```bash
curl -X GET http://localhost:8080/api/v1/chat/SESSION_ID/messages?limit=20 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Features Implemented

✅ Create chat session dengan custom title
✅ Send message ke AI
✅ Receive AI response otomatis
✅ Load chat history
✅ Delete session
✅ Real-time message updates
✅ Loading indicators
✅ Error handling
✅ Beautiful UI dengan robot animation

## Next Steps (Optional)

- [ ] Add pull-to-refresh untuk reload messages
- [ ] Add session list sidebar/drawer
- [ ] Add typing indicator animation
- [ ] Add message timestamps
- [ ] Add message read status
- [ ] Add voice input
- [ ] Add image support
- [ ] Add chat export feature

## Notes

- AI menggunakan GPT-4o-mini untuk efisiensi cost
- AI context limited ke 6 pesan terakhir
- Session tidak auto-delete, user harus hapus manual
- Messages stored in database permanently (sampai session dihapus)

---

**Status**: ✅ Ready for Testing
**Last Updated**: 2025-01-28
