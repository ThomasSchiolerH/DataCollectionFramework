import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        return "DIRECT";
      }
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
