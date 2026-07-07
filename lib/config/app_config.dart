class AppConfig {
  static const String baseUrl         = "https://serve.bagusdevstudio.xyz";

  static const String osrmServer      = "https://osrm.bagusdevstudio.xyz";

  static const String taskFeed = "$baseUrl/api/tasks/feed";
  static const String taskRequester = "$baseUrl/api/tasks/requester";
  static const String taskCreate = "$baseUrl/api/tasks/create";
  static const String taskHistory = "$baseUrl/api/taskHistory";
  static const String historyUser = "$baseUrl/api/historyUser";
  static const String updateStatus = "$baseUrl/api/tasks/update-status";
  static const String historyHelper = "$baseUrl/api/taskHistory";

  static const String login = "$baseUrl/api/auth/login";
  static const String register = "$baseUrl/api/auth/register";
  static const String forgotPassword = "$baseUrl/api/forgot-password";
  static const String resetPassword = "$baseUrl/api/reset-password";
  static const String changePassword = "$baseUrl/api/users/change-password";

  static const String uploadBukti = "$baseUrl/api/payment";
  static const String ambilTugas = "$baseUrl/api/tasks/take";

  static const String chat = "$baseUrl/api/chat";

  static const String notif = "$baseUrl/api/notifikasi";
}
