import 'package:http/http.dart' as http;

Future<bool> isIpv6Supported({
  Duration timeout = const Duration(seconds: 3),
}) async {
  try {
    final uri = Uri.parse('https://api6.ipify.org?format=json');
    final response = await http.get(uri).timeout(timeout);

    if (response.statusCode == 200) {
      final body = response.body;
      return body.contains('ip') && body.contains(':');
    }
    return false;
  } catch (_) {
    return false;
  }
}
