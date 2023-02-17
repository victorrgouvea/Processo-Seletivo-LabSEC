import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:pointycastle/export.dart';

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

  var _privateKey;
  get privateKey => _privateKey;

  void setPrivateKey(key) {
    _privateKey = key;
    notifyListeners();
  }

  var _publicKey;
  get publicKey => _publicKey;

  void setPublicKey(key) {
    _publicKey = key;
    notifyListeners();
  }

  final bool _keysGenerated = false;
  bool get keysGenerated => _keysGenerated;
}
