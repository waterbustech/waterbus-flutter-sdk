import 'dart:io';

Future<bool> isIpv6Supported({
  Duration timeout = const Duration(seconds: 3),
}) async {
  try {
    final socket = await Socket.connect(
      'ipv6.google.com',
      80,
      timeout: timeout,
      sourceAddress: InternetAddress.anyIPv6,
    );
    socket.destroy();
    return true;
  } catch (_) {
    return false;
  }
}
