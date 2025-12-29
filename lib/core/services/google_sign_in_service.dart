import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

/// Google Sign In Service
/// Handles Google authentication flow
class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final Logger _logger = Logger();

  /// Sign in with Google
  Future<GoogleSignInAccount?> signIn() async {
    try {
      _logger.i('🔵 Starting Google Sign In...');
      
      // Try silent sign in first
      GoogleSignInAccount? account = await _googleSignIn.signInSilently();
      
      if (account != null) {
        _logger.i('✅ Silent sign in successful: ${account.email}');
        return account;
      }
      
      // If silent sign in fails, do interactive sign in
      _logger.i('🔵 Silent sign in failed, trying interactive sign in...');
      account = await _googleSignIn.signIn();
      
      if (account != null) {
        _logger.i('✅ Interactive sign in successful: ${account.email}');
        _logger.i('👤 Display Name: ${account.displayName}');
        _logger.i('🆔 ID: ${account.id}');
        _logger.i('📸 Photo URL: ${account.photoUrl}');
      } else {
        _logger.w('⚠️ Sign in returned null - user may have cancelled');
      }
      
      return account;
    } catch (e, stackTrace) {
      _logger.e('❌ Google Sign In failed: $e');
      _logger.e('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _logger.i('Google Sign Out successful');
    } catch (e) {
      _logger.e('Google Sign Out failed: $e');
    }
  }

  /// Disconnect Google account
  Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      _logger.i('Google disconnect successful');
    } catch (e) {
      _logger.e('Google disconnect failed: $e');
    }
  }

  /// Check if user is currently signed in
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Get current signed in user
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
}
