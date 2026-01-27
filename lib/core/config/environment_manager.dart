import 'app_environment.dart';

/// Global environment manager singleton
///
/// Provides centralized access to current environment configuration
class EnvironmentManager {
  // Singleton instance
  static final EnvironmentManager _instance = EnvironmentManager._internal();

  // Current environment configuration
  late EnvironmentConfig _config;

  // Private constructor
  EnvironmentManager._internal();

  /// Get singleton instance
  factory EnvironmentManager() => _instance;

  /// Initialize environment
  ///
  /// Must be called at app startup before using any API
  void initialize(AppEnvironment environment) {
    _config = EnvironmentConfig.forEnvironment(environment);
    print('🌍 Environment initialized: ${_config.displayName}');
    print('📡 Server URL: ${_config.serverUrl}');
  }

  /// Get current environment configuration
  EnvironmentConfig get config {
    try {
      return _config;
    } catch (e) {
      throw StateError(
        'EnvironmentManager not initialized! '
        'Call EnvironmentManager().initialize(environment) first.',
      );
    }
  }

  /// Quick access to server URL
  String get serverUrl => config.serverUrl;

  /// Quick access to image URL
  String get imageUrl => config.imageUrl;

  /// Quick access to environment name
  String get environmentName => config.displayName;

  /// Check if production
  bool get isProduction => config.isProduction;

  /// Check if development
  bool get isDevelopment => config.isDevelopment;

  /// Check if staging
  bool get isStaging => config.isStaging;
}
