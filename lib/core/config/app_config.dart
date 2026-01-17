import 'dart:io';

class AppConfig {
  // Base URL configuration - automatically detects platform
  static String get baseUrl {
    // For Android emulator, use 10.0.2.2 to access host machine's localhost
    // For iOS simulator, use localhost
    // For physical devices, use actual server IP
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    } else if (Platform.isIOS) {
      return 'http://localhost:8080';
    } else {
      // For web or other platforms
      return 'http://localhost:8080';
    }
  }

  // For testing with physical device, set your computer's IP here
  static const String physicalDeviceUrl = 'http://192.168.1.100:8080';

  // API Version
  static const String apiVersion = 'v1';

  // Full Base URL with API version
  static String get fullBaseUrl => '$baseUrl/api/$apiVersion';

  // API Endpoints - matching backend exactly
  static const String usersEndpoint = '/users';
  static const String bloodPressureEndpoint = '/blood_pressure';
  static const String fbsEndpoint = '/fbs';
  static const String fbcEndpoint = '/fbc';
  static const String lipidEndpoint = '/lipid_profile';
  static const String liverEndpoint = '/liver_profile';
  static const String urineEndpoint = '/urine_report';
  static const String reportsEndpoint = '/reports';

  // User endpoints
  static const String addUser = '$usersEndpoint/addUser';
  static const String login = '$usersEndpoint/login';
  static const String getAllUsers = '$usersEndpoint/getAllUsers';
  static String getUser(int id) => '$usersEndpoint/getUser/$id';
  static const String updateUser = '$usersEndpoint/updateUser';
  static String deleteUser(int id) => '$usersEndpoint/deleteUser/$id';

  // Blood Pressure endpoints
  static const String addBPRecord =
      '$bloodPressureEndpoint/addBloodPressureRecord';
  static const String getAllBPRecords =
      '$bloodPressureEndpoint/getAllBloodPressureRecords';
  static String getBPRecord(int id) =>
      '$bloodPressureEndpoint/getBloodPressureRecord/$id';
  static String getBPRecordsByUserId(int userId) =>
      '$bloodPressureEndpoint/getBloodPressureRecordsByUserId/$userId';
  static const String updateBPRecord =
      '$bloodPressureEndpoint/updateBloodPressureRecord';
  static String deleteBPRecord(int id) =>
      '$bloodPressureEndpoint/deleteBloodPressureRecord/$id';

  // FBS endpoints
  static const String addFBSRecord = '$fbsEndpoint/addFastingBloodSugarRecord';
  static const String getAllFBSRecords =
      '$fbsEndpoint/getAllFastingBloodSugarRecords';
  static String getFBSRecord(int id) =>
      '$fbsEndpoint/getFastingBloodSugarRecord/$id';
  static String getFBSRecordsByUserId(int userId) =>
      '$fbsEndpoint/getFastingBloodSugarRecordsByUserId/$userId';
  static const String updateFBSRecord =
      '$fbsEndpoint/updateFastingBloodSugarRecord';
  static String deleteFBSRecord(int id) =>
      '$fbsEndpoint/deleteFastingBloodSugarRecord/$id';

  // FBC endpoints
  static const String addFBCRecord = '$fbcEndpoint/addFullBloodCountRecord';
  static const String getAllFBCRecords =
      '$fbcEndpoint/getAllFullBloodCountRecords';
  static String getFBCRecord(int id) =>
      '$fbcEndpoint/getFullBloodCountRecord/$id';
  static String getFBCRecordsByUserId(int userId) =>
      '$fbcEndpoint/getFullBloodCountRecordsByUserId/$userId';
  static const String updateFBCRecord =
      '$fbcEndpoint/updateFullBloodCountRecord';
  static String deleteFBCRecord(int id) =>
      '$fbcEndpoint/deleteFullBloodCountRecord/$id';

  // Lipid Profile endpoints
  static const String addLipidRecord = '$lipidEndpoint/addLipidProfileRecord';
  static const String getAllLipidRecords =
      '$lipidEndpoint/getAllLipidProfileRecords';
  static String getLipidRecord(int id) =>
      '$lipidEndpoint/getLipidProfileRecord/$id';
  static String getLipidRecordsByUserId(int userId) =>
      '$lipidEndpoint/getLipidProfileRecordsByUserId/$userId';
  static const String updateLipidRecord =
      '$lipidEndpoint/updateLipidProfileRecord';
  static String deleteLipidRecord(int id) =>
      '$lipidEndpoint/deleteLipidProfileRecord/$id';

  // Liver Profile endpoints
  static const String addLiverRecord = '$liverEndpoint/addLiverProfileRecord';
  static const String getAllLiverRecords =
      '$liverEndpoint/getAllLiverProfileRecords';
  static String getLiverRecord(int id) =>
      '$liverEndpoint/getLiverProfileRecord/$id';
  static String getLiverRecordsByUserId(int userId) =>
      '$liverEndpoint/getLiverProfileRecordsByUserId/$userId';
  static const String updateLiverRecord =
      '$liverEndpoint/updateLiverProfileRecord';
  static String deleteLiverRecord(int id) =>
      '$liverEndpoint/deleteLiverProfileRecord/$id';

  // Urine Report endpoints
  static const String addUrineRecord = '$urineEndpoint/addUrineReportRecord';
  static const String getAllUrineRecords =
      '$urineEndpoint/getAllUrineReportRecords';
  static String getUrineRecord(int id) =>
      '$urineEndpoint/getUrineReportRecord/$id';
  static String getUrineRecordsByUserId(int userId) =>
      '$urineEndpoint/getUrineReportRecordsByUserId/$userId';
  static const String updateUrineRecord =
      '$urineEndpoint/updateUrineReportRecord';
  static String deleteUrineRecord(int id) =>
      '$urineEndpoint/deleteUrineReportRecord/$id';

  // Reports endpoints
  static String getReportsByUserId(int userId) =>
      '$reportsEndpoint/getReportsByUserId/$userId';
  static const String updateReport = '$reportsEndpoint/updateReport';
  static String deleteReport(int id) => '$reportsEndpoint/deleteReport/$id';
}
