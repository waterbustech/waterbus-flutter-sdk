class ServerConfig {
  final String url;
  final String apiPath;
  String? apiKey;

  ServerConfig({required this.url, required this.apiPath, this.apiKey});

  String get baseUrlApi => url + apiPath;
}
