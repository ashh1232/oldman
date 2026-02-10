/// Application environment configuration
///
/// Defines different environments (dev, staging, prod) and their settings
enum AppEnvironment {
  /// Development environment - for local testing
  development,

  /// Staging environment - for pre-production testing
  staging,

  /// Production environment - for end users
  production,
}

/// Environment-specific configuration
///
/// Contains all environment-specific settings like API URLs, image URLs, etc.
class EnvironmentConfig {
  final AppEnvironment environment;
  final String serverUrl;
  final String imageUrl;
  final String displayName;

  const EnvironmentConfig({
    required this.environment,
    required this.serverUrl,
    required this.imageUrl,
    required this.displayName,
  });

  /// Development configuration
  static const EnvironmentConfig development = EnvironmentConfig(
    environment: AppEnvironment.development,
    serverUrl: 'http://10.176.169.148/doc/docana-back',
    imageUrl: 'http://10.176.169.148/img',
    // serverUrl: 'http://192.168.0.113/doc/docana-back',
    // imageUrl: 'http://192.168.0.113/img',
    displayName: 'Development',
  );

  /// Staging configuration
  /// TODO: Update with actual staging server URL
  static const EnvironmentConfig staging = EnvironmentConfig(
    environment: AppEnvironment.staging,
    serverUrl: 'http://192.168.1.66/docana-back', // PLACEHOLDER - Update this
    imageUrl: 'http://192.168.1.66/img', // PLACEHOLDER - Update this
    displayName: 'Staging',
  );

  /// Production configuration
  /// TODO: Update with actual production server URL
  static const EnvironmentConfig production = EnvironmentConfig(
    environment: AppEnvironment.production,
    serverUrl: 'https://api.yourdomain.com', // PLACEHOLDER - Update this
    imageUrl: 'https://img.yourdomain.com', // PLACEHOLDER - Update this
    displayName: 'Production',
  );

  /// Factory method to get config for specific environment
  factory EnvironmentConfig.forEnvironment(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.development:
        return EnvironmentConfig.development;
      case AppEnvironment.staging:
        return EnvironmentConfig.staging;
      case AppEnvironment.production:
        return EnvironmentConfig.production;
    }
  }

  /// Check if running in production
  bool get isProduction => environment == AppEnvironment.production;

  /// Check if running in development
  bool get isDevelopment => environment == AppEnvironment.development;

  /// Check if running in staging
  bool get isStaging => environment == AppEnvironment.staging;

  @override
  String toString() => 'EnvironmentConfig($displayName)';
}
