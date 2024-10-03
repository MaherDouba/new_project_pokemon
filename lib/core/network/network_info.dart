import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    if (kIsWeb) {
      return _checkConnectionWeb();
    } else {
      return _checkConnectionMobile();
    }
  }

  Future<bool> _checkConnectionMobile() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<bool> _checkConnectionWeb() async {
    try {
      final response = await http.get(
        Uri.parse('https://httpbin.org/get'),
        headers: {'Access-Control-Allow-Origin': '*'},
      );
      print("Web connection check status code: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print("Web connection check error: $e");
      return false;
    }
  }
}
