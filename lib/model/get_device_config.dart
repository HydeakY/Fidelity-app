import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'package:logger/logger.dart';
import 'package:fidelity/const/color.dart';
import 'package:fidelity/services/environement.dart';

var log = Logger(
  printer: PrettyPrinter(),
);

var session = SessionManager();

class DeviceConfig {
  bool? isKitchenIsActive;
  DeviceConfig({
    required this.isKitchenIsActive,
  });
}

class ConfigRepository {
  Future<DeviceConfig> fetchDeviceConfig() async {
    String apiUrl = getApiUrl();
    final url = Uri.parse('$apiUrl/get-device-configuration');

    final token = await session.get('_csrf');
    final headers = {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    final body = json.encode({"deviceType": "production_screen", "ipAddress": ipAddress});
    // final body = json.encode({"deviceType": "production_screen", "ipAddress": "192.168.1.20"});

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      ("avant le 200");

      DeviceConfig? deviceConfig;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        logger.w(data);

        deviceConfig = DeviceConfig(
          isKitchenIsActive: data["is_kitchen_screen_is_active"]["value"] == "1" ? true : false,
        );
      } else {
        log.e("message");
        deviceConfig = DeviceConfig(isKitchenIsActive: false);   //a remettre a true par default
      }

      return deviceConfig;
    } catch (e) {
      throw Exception('Failed to get device . Error: $e');
    }
  }
}
