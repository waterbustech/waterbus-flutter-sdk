class BaseUrl {
  final String url;
  final String suffixUrl;
  String? apiKey;

  BaseUrl({required this.url, required this.suffixUrl, this.apiKey});

  String get baseUrlApi => url + suffixUrl;
}
