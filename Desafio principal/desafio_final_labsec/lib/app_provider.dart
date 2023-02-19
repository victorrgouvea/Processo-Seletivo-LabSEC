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

  var _privateKey = null;
  get privateKey => _privateKey;

  void setPrivateKey(key) {
    _privateKey = key;
    notifyListeners();
  }

  var _publicKey = null;
  get publicKey => _publicKey;

  void setPublicKey(key) {
    _publicKey = key;
    notifyListeners();
  }

  var _signature;
  get signature => _signature;

  void setSignature(sig) {
    _signature = sig;
    notifyListeners();
  }
}
