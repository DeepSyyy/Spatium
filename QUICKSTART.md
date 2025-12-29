# 🚀 Quick Start Guide - Spatium Frontend

## ✅ Apa yang Sudah Diimplementasikan

### 1. **Clean Architecture** ✅
- ✅ Data Layer (models, datasources, repositories)
- ✅ Domain Layer (entities, usecases, repository interfaces)
- ✅ Presentation Layer (providers, state management)

### 2. **State Management** ✅
- ✅ Flutter Riverpod setup
- ✅ AuthNotifier untuk manage auth state
- ✅ Providers untuk dependency injection

### 3. **Networking** ✅
- ✅ Dio HTTP client dengan interceptors
- ✅ Automatic JWT token attachment
- ✅ Error handling & logging

### 4. **Security** ✅
- ✅ Flutter Secure Storage untuk JWT
- ✅ Encrypted storage (Android & iOS)
- ✅ Auto-logout on 401

### 5. **Auth Feature** ✅
- ✅ Register user
- ✅ Login with recovery code
- ✅ Logout
- ✅ Get current user
- ✅ Check login status

## 📋 Langkah-Langkah Setup

### 1. Dependencies sudah terinstall ✅
```bash
flutter pub get
```

### 2. Code generation sudah berjalan ✅
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Update API Base URL

Edit [lib/core/constants/api_constants.dart](lib/core/constants/api_constants.dart):

```dart
// Untuk development local
static const String baseUrl = 'http://localhost:8080/api/v1';

// Untuk production (Railway)
// static const String baseUrl = 'https://spatium-backend.railway.app/api/v1';
```

## 🎯 Cara Menggunakan Auth

### Contoh 1: Register User

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/features/auth/presentation/providers/auth_notifier.dart';

class RegisterPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _aliasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Listen untuk perubahan state
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.when(
        authenticated: (authResponse) {
          // Berhasil register
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registrasi berhasil!')),
          );
          // Show recovery code
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Recovery Code Anda'),
              content: Text(authResponse.recoveryCode),
            ),
          );
          // Navigate to home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        error: (message) {
          // Error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        },
        initial: () {},
        loading: () {},
        unauthenticated: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _aliasController,
              decoration: InputDecoration(
                labelText: 'Alias',
                hintText: 'Masukkan nama alias Anda',
              ),
            ),
            SizedBox(height: 16),
            authState.maybeWhen(
              loading: () => CircularProgressIndicator(),
              orElse: () => ElevatedButton(
                onPressed: () {
                  final alias = _aliasController.text.trim();
                  if (alias.isNotEmpty) {
                    ref.read(authNotifierProvider.notifier).register(alias);
                  }
                },
                child: Text('Daftar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Contoh 2: Login dengan Recovery Code

```dart
class LoginPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _recoveryCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.when(
        authenticated: (authResponse) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        },
        initial: () {},
        loading: () {},
        unauthenticated: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _recoveryCodeController,
              decoration: InputDecoration(
                labelText: 'Recovery Code',
                hintText: 'Masukkan recovery code',
              ),
            ),
            SizedBox(height: 16),
            authState.maybeWhen(
              loading: () => CircularProgressIndicator(),
              orElse: () => ElevatedButton(
                onPressed: () {
                  final code = _recoveryCodeController.text.trim();
                  if (code.isNotEmpty) {
                    ref.read(authNotifierProvider.notifier).login(code);
                  }
                },
                child: Text('Masuk'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Contoh 3: Check Login Status di Splash Screen

```dart
class SplashScreenPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends ConsumerState<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2));
    
    final isLoggedIn = await ref.read(isLoggedInProvider.future);
    
    if (mounted) {
      if (isLoggedIn) {
        // User sudah login, langsung ke home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainNavigationPage()),
        );
      } else {
        // Belum login, ke welcome page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
```

### Contoh 4: Logout Button

```dart
class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Logout
            await ref.read(authNotifierProvider.notifier).logout();
            
            // Navigate to login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
```

## 📂 File Structure Reference

```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart        ← Edit BASE_URL di sini
│   │   └── storage_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── api_client.dart           ← Dio setup dengan interceptors
│   ├── storage/
│   │   └── secure_storage_service.dart
│   └── providers/
│       └── core_providers.dart
│
└── features/auth/
    ├── data/
    │   ├── datasources/
    │   │   ├── auth_remote_data_source.dart
    │   │   └── auth_local_data_source.dart
    │   ├── models/
    │   │   ├── user_model.dart
    │   │   ├── auth_response_model.dart
    │   │   ├── register_request.dart
    │   │   └── login_request.dart
    │   └── repositories/
    │       └── auth_repository_impl.dart
    ├── domain/
    │   ├── entities/
    │   │   ├── user_entity.dart
    │   │   └── auth_response_entity.dart
    │   ├── repositories/
    │   │   └── auth_repository.dart
    │   └── usecases/
    │       ├── register_usecase.dart
    │       ├── login_usecase.dart
    │       ├── logout_usecase.dart
    │       └── get_current_user_usecase.dart
    └── presentation/
        ├── providers/
        │   ├── auth_providers.dart   ← Providers untuk DI
        │   ├── auth_state.dart       ← State definition
        │   └── auth_notifier.dart    ← State management
        └── page/
            └── (UI pages Anda)
```

## 🎨 Next Steps

### Integrate ke UI yang sudah ada:

1. **Update WelcomePage**: Tambah navigation ke register/login
2. **Create RegisterPage**: Implement UI register dengan auth notifier
3. **Create LoginPage**: Implement UI login dengan auth notifier
4. **Update SplashScreen**: Check login status
5. **Add Logout**: Di profile page

### Implement Features Lain:

Sekarang Anda bisa copy pattern yang sama untuk:
- Posts/Timeline
- Chat AI
- Mood Tracking
- Comments
- dll

## 🐛 Troubleshooting

### Error: Cannot connect to backend
- Pastikan backend running di `http://localhost:8080`
- Update `baseUrl` di [api_constants.dart](lib/core/constants/api_constants.dart)

### Error: Build runner failed
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Error: State not updating
- Pastikan widget menggunakan `ConsumerWidget` atau `ConsumerStatefulWidget`
- Gunakan `ref.watch()` untuk listen changes
- Gunakan `ref.read()` untuk one-time read

## 📚 Dokumentasi Lengkap

Lihat [ARCHITECTURE.md](ARCHITECTURE.md) untuk penjelasan lengkap arsitektur.

---

**Status**: ✅ **SIAP DIGUNAKAN!**

Sekarang Anda tinggal integrate auth flow ke UI yang sudah ada, lalu implement features lainnya dengan pattern yang sama! 🚀
