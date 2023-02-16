import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class AppProvider with ChangeNotifier {
  final List<BluetoothDevice> _devicesList = [];
  List<BluetoothDevice> get devicesList => _devicesList;

  void addDevicesList(BluetoothDevice device) {
    _devicesList.add(device);
    notifyListeners();
  }

  void cleanDevicesList() {
    _devicesList.clear();
    notifyListeners();
  }

  String _lastScanDate = 'Nunca';
  String get lastScanDate => _lastScanDate;

  void setLastScanDate(String date) {
    _lastScanDate = date;
    notifyListeners();
  }
}
