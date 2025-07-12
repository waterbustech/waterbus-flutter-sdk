class ServerConfig {
  final String url;
  final String suffixUrl;
  String apiKey;

  ServerConfig({
    required this.url,
    required this.suffixUrl,
    this.apiKey = 'open@waterbus',
  });

  String get baseUrlApi => url + suffixUrl;
}
