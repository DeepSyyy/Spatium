# Spatium Frontend - Clean Architecture Implementation

## 📚 Arsitektur

Project ini menggunakan **Clean Architecture** dengan pembagian layer sebagai berikut:

```
lib/
├── core/                       # Core utilities & shared code
│   ├── constants/             # API & storage constants
│   ├── errors/                # Error handling (failures & exceptions)
│   ├── network/               # API client (Dio)
│   ├── storage/               # Secure storage service
│   └── providers/             # Core Riverpod providers
│
├── features/                   # Feature modules
│   └── auth/                  # Authentication feature
│       ├── data/              # Data layer
│       │   ├── datasources/   # Remote & local data sources
│       │   ├── models/        # Data models (JSON serialization)
│       │   └── repositories/  # Repository implementations
│       ├── domain/            # Domain layer (Business logic)
│       │   ├── entities/      # Business entities
│       │   ├── repositories/  # Repository interfaces
│       │   └── usecases/      # Use cases
│       └── presentation/      # Presentation layer (UI)
│           ├── page/          # UI pages
│           ├── widgets/       # UI widgets
│           └── providers/     # State management (Riverpod)
```

## 🛠️ Tech Stack

### State Management
- **Flutter Riverpod** (2.6.1) - Modern, powerful state management

### Networking
- **Dio** (5.7.0) - HTTP client with interceptors
- **Retrofit** (4.4.1) - Type-safe API client (optional, sudah setup)

### Security
- **Flutter Secure Storage** (9.2.2) - Secure token & data storage

### Code Generation
- **Freezed** (2.5.7) - Immutable models & union types
- **JSON Serializable** (6.8.0) - JSON serialization

### Functional Programming
- **Dartz** (0.10.1) - Either type for error handling

### Utilities
- **Logger** (2.5.0) - Advanced logging
- **Intl** (0.19.0) - Internationalization

## 🚀 Setup & Installation

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Code (Freezed & JSON Serializable)

**Windows:**
```bash
generate.bat
```

**Linux/Mac:**
```bash
chmod +x generate.sh
./generate.sh
```

**Or manually:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Configure API Base URL

Edit `lib/core/constants/api_constants.dart`:

```dart
// Development
static const String baseUrl = 'http://localhost:8080/api/v1';

// Production (Railway)
static const String baseUrl = 'https://your-app.railway.app/api/v1';
```

## 📱 Features Implemented

### ✅ Core Architecture
- [x] Clean Architecture folder structure
- [x] Dependency injection with Riverpod
- [x] Error handling with Either<Failure, Success>
- [x] API client with Dio + interceptors
- [x] Secure storage for JWT tokens
- [x] Logging system

### ✅ Authentication
- [x] Domain layer (entities, repositories, use cases)
- [x] Data layer (models, data sources, repository impl)
- [x] Presentation layer (providers, state management)
- [x] Register use case
- [x] Login use case
- [x] Logout use case
- [x] Get current user use case

## 🎯 Usage Examples

### 1. Using Auth Notifier in UI

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/features/auth/presentation/providers/auth_notifier.dart';

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return authState.when(
      initial: () => LoginForm(onLogin: authNotifier.login),
      loading: () => LoadingWidget(),
      authenticated: (authResponse) {
        // Navigate to home
        return HomeScreen();
      },
      unauthenticated: () => LoginForm(onLogin: authNotifier.login),
      error: (message) => ErrorWidget(message),
    );
  }
}
```

### 2. Register User

```dart
// In your widget
final authNotifier = ref.read(authNotifierProvider.notifier);
await authNotifier.register('MyAlias');

// Listen to state changes
ref.listen<AuthState>(authNotifierProvider, (previous, next) {
  next.when(
    authenticated: (authResponse) {
      // Show success & navigate
      showSuccess('Registrasi berhasil! Recovery code: ${authResponse.recoveryCode}');
      navigateToHome();
    },
    error: (message) => showError(message),
    initial: () {},
    loading: () {},
    unauthenticated: () {},
  );
});
```

### 3. Login User

```dart
final authNotifier = ref.read(authNotifierProvider.notifier);
await authNotifier.login('RECOVERY-CODE-123');
```

### 4. Logout

```dart
final authNotifier = ref.read(authNotifierProvider.notifier);
await authNotifier.logout();
```

### 5. Check Login Status

```dart
final isLoggedInAsync = ref.watch(isLoggedInProvider);

isLoggedInAsync.when(
  data: (isLoggedIn) {
    if (isLoggedIn) {
      return MainNavigationPage();
    } else {
      return WelcomePage();
    }
  },
  loading: () => LoadingScreen(),
  error: (error, stack) => ErrorScreen(),
);
```

## 🔐 Security Features

### JWT Token Management
- Automatic token attachment to requests via interceptor
- Secure storage using flutter_secure_storage
- Automatic token refresh on 401 (can be extended)
- Auto-logout on unauthorized

### Encrypted Storage
- All sensitive data stored with encryption
- Platform-specific security:
  - **Android**: EncryptedSharedPreferences
  - **iOS**: Keychain

## 🎨 Best Practices Implemented

1. **Separation of Concerns**: Clear separation between data, domain, and presentation
2. **Dependency Injection**: Using Riverpod providers
3. **Immutability**: Using Freezed for immutable models
4. **Type Safety**: Strong typing throughout
5. **Error Handling**: Functional error handling with Either
6. **Code Generation**: Automated JSON serialization
7. **Logging**: Comprehensive logging for debugging
8. **Single Responsibility**: Each class has one responsibility

## 📝 Next Steps

### To Implement:
1. **Posts/Timeline Feature**
   - Create models, entities, use cases
   - Implement CRUD operations
   - Add pagination

2. **Chat AI Feature**
   - WebSocket integration for real-time
   - Message state management
   - Session management

3. **Mood Tracking**
   - Daily mood CRUD
   - Statistics & charts
   - Calendar view

4. **UI Integration**
   - Connect existing UI to state management
   - Add loading states
   - Add error handling
   - Add form validation

## 🐛 Debugging

### Enable Logging
Logger sudah terintegrasi di API client. Check console untuk:
- Request logs (method, path, headers, data)
- Response logs (status, data)
- Error logs

### Check Stored Data
```dart
final storage = ref.read(secureStorageServiceProvider);
final allData = await storage.getAllData();
print(allData); // Print all stored data
```

## 🤝 Contributing

Saat menambahkan feature baru:
1. Ikuti struktur Clean Architecture yang sudah ada
2. Buat models dengan Freezed
3. Implement repository pattern
4. Create use cases untuk business logic
5. Setup Riverpod providers
6. Generate code dengan build_runner

## 📚 Resources

- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Riverpod Docs](https://riverpod.dev/)
- [Freezed Package](https://pub.dev/packages/freezed)
- [Dio HTTP Client](https://pub.dev/packages/dio)

---

**Status**: ✅ Architecture Layer COMPLETE
**Next**: Implement remaining features (Posts, Chat, Mood)
