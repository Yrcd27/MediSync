class AppConfig {
  static const String baseUrl =
      'http://10.0.2.2:8080'; // Use 10.0.2.2 for Android emulator (maps to host localhost)
  static const String apiVersion =
      ''; // Remove API version prefix since backend doesn't use it

  // Endpoints
  static const String usersEndpoint = '/users';
  static const String fbcEndpoint = '/fbc';
  static const String fbsEndpoint = '/fbs';
  static const String bpEndpoint = '/bp';
  static const String lipidEndpoint = '/lipid';
  static const String liverEndpoint = '/liver';
  static const String urineEndpoint = '/urine';
  static const String reportsEndpoint = '/reports';

  static String get fullBaseUrl => baseUrl + apiVersion;
}
