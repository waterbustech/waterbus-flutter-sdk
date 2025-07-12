class ServerConfig {
  final String url;
  final String apiPath;
  String apiKey;

  ServerConfig({
    required this.url,
    required this.apiPath,
    this.apiKey = 'open@waterbus',
  });

  String get baseUrlApi => url + apiPath;
}
