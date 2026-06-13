class AppConfig {
  // Cukup ganti di satu baris ini aja kalau ngrok ganti!
  static const String baseUrl = "https://lyricism-conch-sheath.ngrok-free.dev";

  // Endpoint tinggal gabungin dari baseUrl
  static const String taskFeed = "$baseUrl/api/tasks/feed";
  static const String taskCreate = "$baseUrl/api/tasks/create";
  static const String login = "$baseUrl/api/auth/login";
}
