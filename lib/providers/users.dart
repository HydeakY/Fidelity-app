import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fidelity/services/environement.dart';


var session = SessionManager();

class Users with ChangeNotifier {

  var users = [];
  String mercureUrl = getMercureUrl();
  final String apiUrl = getApiUrl();
  var currentUser;

  Future<void> getUsers() async {
    final url = Uri.parse('$apiUrl/get-customers');
    final token = await session.get('_csrf');
    final headers = {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      logger.d(jsonResponse);
      users = jsonResponse;
      notifyListeners();
    } else if (response.statusCode == 204) {
      logger.i("Aucun user trouvé");
    } else {
      logger.e(jsonDecode(response.body));
      throw Exception('Failed to fetch users');
    }
  }

  Future<void>patchFidelityPoints(int points, String type) async {
    final url = Uri.parse('$apiUrl/get-customers');
    final token = await session.get('_csrf');
    final headers = {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    final body = json.encode({'type': type, 'fidelityPoints': points});

    final response = await http.patch(url, headers: headers, body: body);

    if(response.statusCode == 200) {
      logger.d('Patch successed, $points have been actualized');
    } else {
      throw Exception('Failed to add fidelity points');
    }
  }

  Future<void> getOneUser(String uuid) async {
    final url = Uri.parse('$apiUrl/get-customer');
    final token = await session.get('_csrf');
    final headers = {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    final body = json.encode({'uuid': uuid});

    final response = await http.post(url, headers: headers, body: body);

    if(response.statusCode == 200) {
      final decodeUser = json.decode(response.body);
      currentUser = decodeUser;
      notifyListeners();
      logger.d('User fetched');
    } else {
      throw Exception('Failed to get the user');
    }
  }
}