import 'package:flutter/material.dart';
import 'package:fidelity/const/color.dart';
import '../model/get_device_config.dart';

class DeviceConfigVM with ChangeNotifier {
  DeviceConfig? deviceConfig;
  
  final configRepository = ConfigRepository();

  fetchDeviceConfig() async {
    deviceConfig = await configRepository.fetchDeviceConfig();
    isKitchenIsActive = deviceConfig!.isKitchenIsActive;

    notifyListeners();
  }
}