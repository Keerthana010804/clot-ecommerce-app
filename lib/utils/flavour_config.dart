enum Flavor { dev, staging, prod }

class FlavorConfig {
  final Flavor flavor;
  final String baseUrl;
  final String name;

  static late FlavorConfig instance;

  FlavorConfig({
    required this.flavor,
    required this.baseUrl,
    required this.name,
  }) {
    instance = this;
  }

  static bool isDev() => instance.flavor == Flavor.dev;
  static bool isProd() => instance.flavor == Flavor.prod;
  static bool isStaging() => instance.flavor == Flavor.staging;
}
