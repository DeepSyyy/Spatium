/// API Constants
/// Contains all API-related constants including base URL, endpoints, and timeouts
class ApiConstants {
  // ============================================
  // 🔧 PILIH SALAH SATU BASE URL SESUAI KEBUTUHAN
  // ============================================

  // 1️⃣ ANDROID EMULATOR (AVD) - localhost laptop
  // static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

  // 2️⃣ ANDROID DEVICE (HP via USB) - Gunakan salah satu:
  //    a) Ngrok URL (jika pakai ngrok)
  static const String baseUrl = 'http://72.62.124.125:4419/api/v1';
  //    b) WiFi IP laptop (jika di network yang sama)
  // static const String baseUrl = 'http://192.168.1.100:8080/api/v1';

  // 3️⃣ iOS SIMULATOR / WEB - localhost
  // static const String baseUrl = 'http://localhost:8080/api/v1';

  // 4️⃣ PRODUCTION (Railway/Cloud)
  // static const String baseUrl = 'https://your-app.railway.app/api/v1';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Auth Endpoints
  static const String register = '/register';
  static const String login = '/login';
  static const String googleLogin = '/auth/google';

  // Posts Endpoints
  static const String posts = '/posts';
  static const String userPosts = '/user/posts';
  static String postDetail(String postId) => '/posts/$postId';

  // Comments Endpoints
  static const String comments = '/comments';
  static String postComments(String postId) => '/posts/$postId/comments';
  static String deleteComment(String commentId) => '/comments/$commentId';

  // Reactions Endpoints
  static String postReactions(String postId) => '/posts/$postId/reactions';

  // Chat Session Endpoints
  static const String chatSession = '/chat/session';
  static String deleteChatSession(String sessionId) =>
      '/chat/session/$sessionId';

  // Chat Message Endpoints
  static String sendMessage(String sessionId) => '/chat/$sessionId';
  static String sessionMessages(String sessionId) =>
      '/chat/$sessionId/messages';
  static String lastMessages(String sessionId) => '/chat/$sessionId/last';

  // Moods Endpoints
  static const String moods = '/moods';
  static const String moodsToday = '/moods/today';
  static const String moodsWeekly = '/moods/weekly';
  static const String moodsStatistics = '/moods/statistics';
  static const String moodsChart = '/moods/chart';

  // AI Reflection Endpoints
  static const String aiReflection = '/ai/reflection';

  // Report Endpoints (Content Moderation)
  static const String reports = '/reports';
  static const String reportReasons = '/reports/reasons';
  static const String myReports = '/reports/me';

  // Block Endpoints (User Safety)
  static const String blockUser = '/users/block';
  static const String blockedUsers = '/users/blocked';
  static String unblockUser(String userId) => '/users/block/$userId';

  // User Profile Endpoints
  static const String updateAlias = '/user/alias';

  // Headers
  static const String contentTypeJson = 'application/json';
  static const String acceptJson = 'application/json';
}
