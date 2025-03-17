class ApiConstants {
  static const bool isProduction = false;
  
  // Use 10.0.2.2 for Android emulator, localhost for web/iOS
  static const String baseUrl = isProduction 
      ? 'http://localhost:8081'
      : 'http://10.0.2.2:8081';
      
  static const String apiVersion = '/api';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String checkUser = '/auth/check-user';
  
  // Family endpoints
  static const String family = '/families';
  static const String members = '/members';
  static const String pendingMembers = '/members/pending';
  
  // S3 endpoints
  static const String s3PresignedUrl = '/s3/presigned-url';
  
  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
} 