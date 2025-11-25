import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String? get googleApiKey {
    final key = dotenv.env['GOOGLE_API_KEY'];
    // Debug: Log the key (first 10 chars only for security)
    if (kDebugMode) {
      debugPrint('API Key loaded: ${key != null ? "${key.substring(0, key.length > 10 ? 10 : key.length)}..." : "NULL"}');
    }
    return key;
  }

  static bool get isConfigured => googleApiKey != null && googleApiKey!.isNotEmpty;

  static void validate() {
    if (!isConfigured) {
      throw Exception(
        'Google API key is not configured. Please check your .env file.',
      );
    }
    
    // Debug: Check if key matches expected format
    if (kDebugMode && googleApiKey != null) {
      if (!googleApiKey!.startsWith('AIzaSy')) {
        debugPrint('WARNING: API key format looks incorrect');
      }
    }
  }
}

