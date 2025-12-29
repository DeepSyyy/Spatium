/// Storage Keys Constants
/// Contains all secure storage keys used throughout the app
class StorageConstants {
  // Auth Keys
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userAlias = 'user_alias';
  static const String userEmail = 'user_email';
  static const String userPhotoUrl = 'user_photo_url';
  static const String recoveryCode = 'recovery_code';
  static const String isLoggedIn = 'is_logged_in';
  
  // User Preferences
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String firstTimeUser = 'first_time_user';
  
  // Cache Keys
  static const String cachedPosts = 'cached_posts';
  static const String cachedUserData = 'cached_user_data';
  static const String lastSyncTime = 'last_sync_time';
}
