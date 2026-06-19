class AppConfig {
  static const String baseUrl       = "https://playroom-junction-kick.ngrok-free.dev";

  static const String taskFeed      = "$baseUrl/api/tasks/feed";
  static const String taskRequester = "$baseUrl/api/tasks/requester";
  static const String taskCreate    = "$baseUrl/api/tasks/create";
  static const String login         = "$baseUrl/api/auth/login";

  static const String uploadBukti   = "$baseUrl/api/payment";
  static const String ambilTugas    = "$baseUrl/api/tasks/take";

  static const String taskHistory   = "$baseUrl/api/tasks/history";
}
