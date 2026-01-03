import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration class สำหรับจัดการ environment variables
/// อ่านค่าจาก .env file ครั้งเดียวตอน app start
class AppConfig {
  final String geminiApiKey;
  final String pmApiKey;
  final String baseUrl;

  AppConfig({
    required this.geminiApiKey,
    required this.pmApiKey,
    this.baseUrl = 'https://api.waqi.info',
  });

  /// Factory สำหรับอ่านค่าจาก .env file
  factory AppConfig.fromEnv() {
    return AppConfig(
      geminiApiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
      pmApiKey: dotenv.env['PM_API_KEY'] ?? '',
      baseUrl: dotenv.env['BASE_URL'] ?? 'https://api.waqi.info',
    );
  }

  /// Factory สำหรับ testing (ไม่ต้องพึ่ง .env)
  factory AppConfig.fromTest({
    String geminiApiKey = 'test_gemini_key',
    String pmApiKey = 'test_pm_key',
    String baseUrl = 'https://test.api.com',
  }) {
    return AppConfig(
      geminiApiKey: geminiApiKey,
      pmApiKey: pmApiKey,
      baseUrl: baseUrl,
    );
  }

  /// ตรวจสอบว่า config ครบถ้วนหรือไม่
  bool get isValid {
    return geminiApiKey.isNotEmpty && pmApiKey.isNotEmpty;
  }

  @override
  String toString() {
    return 'AppConfig(gemini: ${geminiApiKey.isNotEmpty ? "***" : "empty"}, '
        'pm: ${pmApiKey.isNotEmpty ? "***" : "empty"}, '
        'baseUrl: $baseUrl)';
  }
}
