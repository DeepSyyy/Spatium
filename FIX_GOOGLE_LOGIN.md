# 🔧 Cara Memperbaiki Google Login Error (ApiException: 10)

Error **ApiException: 10** adalah `DEVELOPER_ERROR` yang terjadi karena konfigurasi OAuth belum lengkap.

## 📋 Langkah-langkah Perbaikan

### 1️⃣ Dapatkan SHA-1 Fingerprint

Jalankan command berikut di terminal:

```bash
cd android
./gradlew signingReport
```

atau gunakan keytool:

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**Windows:**
```bash
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Catat **SHA-1** dan **SHA-256** yang muncul.

### 2️⃣ Konfigurasi di Google Cloud Console

1. Buka [Google Cloud Console](https://console.cloud.google.com/)

2. Pilih project Anda (atau buat project baru)

3. Pergi ke **APIs & Services** > **Credentials**

4. Klik **+ CREATE CREDENTIALS** > **OAuth client ID**

5. Pilih **Application type**: **Android**

6. Isi form:
   - **Name**: `Spatium Android Client` (bebas)
   - **Package name**: `com.example.spatium`
   - **SHA-1 certificate fingerprint**: Paste SHA-1 dari langkah 1

7. Klik **CREATE**

8. **PENTING**: Juga buat OAuth client ID untuk **Web application** (untuk backend):
   - **Application type**: **Web application**
   - **Name**: `Spatium Backend`
   - **Authorized redirect URIs**: (kosongkan dulu)
   - Simpan **Client ID** yang dihasilkan

### 3️⃣ Aktifkan Google Sign-In API

1. Di Google Cloud Console, pergi ke **APIs & Services** > **Library**

2. Cari **"Google+ API"** atau **"Google Sign-In API"**

3. Klik **ENABLE**

### 4️⃣ Download google-services.json (Jika Pakai Firebase)

Jika menggunakan Firebase:

1. Buka [Firebase Console](https://console.firebase.google.com/)

2. Pilih project Anda

3. Pergi ke **Project Settings** (gear icon)

4. Scroll ke bawah, pilih app Android Anda

5. Download `google-services.json`

6. Copy file ke: `android/app/google-services.json`

7. Update `android/build.gradle.kts`:
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") version "4.4.0" apply false  // Tambahkan ini
}
```

8. Update `android/app/build.gradle.kts` (tambahkan di bagian atas):
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // Tambahkan ini
}
```

### 5️⃣ Verifikasi Package Name

Pastikan package name di semua tempat sama: **`com.example.spatium`**

- ✅ `android/app/build.gradle.kts`: `applicationId = "com.example.spatium"`
- ✅ `android/app/src/main/AndroidManifest.xml`: `package="com.example.spatium"`
- ✅ Google Cloud Console OAuth: Package name sama

### 6️⃣ Update Google Sign-In Service (Opsional - Tambah Client ID)

Jika backend Anda butuh Web Client ID, update file ini:

**lib/core/services/google_sign_in_service.dart:**
```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com', // Dari step 2.8
);
```

### 7️⃣ Clean & Rebuild

```bash
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run
```

## 🔍 Troubleshooting

### Jika masih error setelah konfigurasi:

1. **Tunggu 5-10 menit** - Google butuh waktu untuk propagate perubahan OAuth

2. **Uninstall app dari device**, lalu install ulang:
```bash
flutter clean
flutter run
```

3. **Cek package name** di Google Cloud Console harus **persis sama** dengan `applicationId` di `build.gradle.kts`

4. **Untuk testing di real device**, Anda juga perlu SHA-1 dari **release keystore** (jika sudah punya)

### Cek status OAuth:
1. Buka [Google API Console](https://console.cloud.google.com/apis/credentials)
2. Pastikan ada **2 OAuth client IDs**:
   - ✅ Android client (dengan SHA-1)
   - ✅ Web client (untuk backend)

## ✅ Verifikasi Berhasil

Setelah konfigurasi benar, saat login Google:
- Akan muncul popup pemilihan akun Google
- Tidak ada error ApiException
- Login berhasil dan masuk ke aplikasi

## 📞 Butuh Bantuan?

Jika masih error, kirimkan:
1. Screenshot dari Google Cloud Console > Credentials
2. Package name dari `android/app/build.gradle.kts`
3. Error message lengkap dari logcat
