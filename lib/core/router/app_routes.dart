/// Centralized route management
/// ใช้ class นี้สำหรับเก็บ route paths และ names ทั้งหมด
class AppRoutes {
  // Private constructor - ป้องกันการสร้าง instance
  AppRoutes._();

  // ==================== Route Paths ====================
  static const String login = '/login';
  static const String home = '/home';
  static const String nasaSettings = '/nasa-settings';

  // ==================== Route Names ====================
  // ใช้สำหรับ context.goNamed()
  static const String loginName = 'login';
  static const String homeName = 'home';
  static const String nasaSettingsName = 'nasa-settings';

  // ==================== Helper Methods ====================
  
  /// Navigate to login page
  static String get loginPath => login;
  
  /// Navigate to home page
  static String get homePath => home;
  
  /// Navigate to NASA settings page
  static String get nasaSettingsPath => nasaSettings;
}
