import 'package:flutter/foundation.dart';

/// Custom logger ที่แสดงแค่ใน debug mode
/// ใน production (release build) จะไม่แสดงอะไรเลย
class AppLogger {
  // Private constructor
  AppLogger._();

  /// Log message - แสดงแค่ใน debug mode
  static void log(String message) {
    if (kDebugMode) {
      debugPrint('ddd = 🔵 LOG: $message');
    }
  }

  /// Log error - แสดงแค่ใน debug mode
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('ddd = 🔴 ERROR: $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }
  }

  /// Log warning - แสดงแค่ใน debug mode
  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('ddd = 🟡 WARNING: $message');
    }
  }

  /// Log success - แสดงแค่ใน debug mode
  static void success(String message) {
    if (kDebugMode) {
      debugPrint('ddd = 🟢 SUCCESS: $message');
    }
  }

  /// Log info - แสดงแค่ใน debug mode
  static void info(String message) {
    if (kDebugMode) {
      debugPrint('ddd = ℹ️ INFO: $message');
    }
  }

  /// Log debug - แสดงแค่ใน debug mode พร้อม timestamp
  static void debug(String message) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      debugPrint('🐛 DEBUG [$timestamp]: $message');
    }
  }
}

// ==================== Shorthand Functions ====================
// ใช้สำหรับเรียกแบบสั้น

/// Log message - shorthand
void log(String message) => AppLogger.log(message);

/// Log error - shorthand
void logError(String message, [Object? error, StackTrace? stackTrace]) {
  AppLogger.error(message, error, stackTrace);
}

/// Log warning - shorthand
void logWarning(String message) => AppLogger.warning(message);

/// Log success - shorthand
void logSuccess(String message) => AppLogger.success(message);

/// Log info - shorthand
void logInfo(String message) => AppLogger.info(message);

/// Log debug - shorthand
void logDebug(String message) => AppLogger.debug(message);
