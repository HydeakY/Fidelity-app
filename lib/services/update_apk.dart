import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ota_update/ota_update.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fidelity/services/environement.dart';

var log = Logger(
  printer: PrettyPrinter(),
);
var session = SessionManager();

class UpdateView extends StatefulWidget {
  final dynamic url;
  const UpdateView({
    super.key,
    required this.url,
  });
  @override
  State<UpdateView> createState() => _UpdateViewState();
}

class _UpdateViewState extends State<UpdateView> {
  int currentEvent = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Mise à jour de l'application",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 100),
            Text(
              "${currentEvent.toStringAsFixed(0)}%",
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 111),
            LinearProgressIndicator(
              color: Colors.green,
              backgroundColor: Colors.black54,
              value: currentEvent / 100,
            ),
            const SizedBox(height: 222),
            SizedBox(
                height: 77,
                width: 444,
                child: ElevatedButton(
                  onPressed: () async {
                  

                    update(url: widget.url);
                  },
                  child: const Text(
                    "Mettre à jour",
                    style: TextStyle(fontSize: 33),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future update({required Uri url}) async {
    try {
      OtaUpdate()
          .execute(
        url.toString(),
        destinationFilename: 'app.apk',
      )
          .listen(
        (OtaEvent event) {
          setState(() => currentEvent = int.parse(event.value!));
        },
      );
    } catch (e) {
      ('La mise à jour à échoué. Details: $e');
    }
  }
}

enum DeviceType {
  cashRegister,
  kiosk,
  kitchen,
  pad,
  mobileApp,
  customerScreen,
  productionScreen;

  @override
  String toString() {
    switch (this) {
      case DeviceType.cashRegister:
        return 'cash_register';
      case DeviceType.kiosk:
        return 'kiosk';
      case DeviceType.customerScreen:
        return 'customer_screen';
      case DeviceType.kitchen:
        return 'kitchen_screen';
      case DeviceType.pad:
        return 'pad';
      case DeviceType.mobileApp:
        return 'customer_mobile_app';
      case DeviceType.productionScreen:
        return 'production_screen';
      default:
        return '';
    }
  }
}

updateApk({
  required DeviceType deviceType,
  required String versionApp,
}) async {
  try {
    final body = jsonEncode({
      "deviceType": deviceType.toString(),
      "versionApp": versionApp,
    });
    final data = await Api.post(
      endPoint: "get-update-device",
      body: body,
    );

    if (data["code"] == 500) {
      return {"status": true, "url": Uri.parse(data["url"])};
    }
    return {"status": false};
  } catch (error) {
    return {"status": false, "catch": error};
  }
}

String apiUrl = getApiUrl();

class Api {
  static post({required String endPoint, required String body}) async {
    final url = Uri.parse("$apiUrl/$endPoint");
    final token = await session.get('_csrf');

    final headers = {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $token'};

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to get update. Error: $e');
    }
  }
}