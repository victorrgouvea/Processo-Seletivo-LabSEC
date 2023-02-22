import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

// Classe que utiliza o ChangeNotifier da biblioteca Provider
// para armazenar dados do app que vão ser utilizados em diversas
// páginas. A classe, além de armazenar esses dados, também notifica
// as páginas que usam esses dados de eventuais mudanças nos valores
// das variáveis, com o objetivo de manter o estado da página mesmo
// após retornar a página principal ou visitar outras páginas e 
// também permitir a utilização de variáveis em uma página que foram
// geradas em outra página, como por exemplo utilizar a lista de 
// dispositivos BLE e as chaves RSA (geradas em outras páginas)
// para gerar a assinatura da lista na página 'Assinar lista'
class AppProvider with ChangeNotifier {
  // Lista de dispositivos BLE
  final List<BluetoothDevice> _devicesList = [];
  List<BluetoothDevice> get devicesList => _devicesList;

  // Adiciona um dispositivo na lista
  void addDevicesList(BluetoothDevice device) {
    _devicesList.add(device);
    notifyListeners();
  }

  // Limpa a lista de dispositivos
  void cleanDevicesList() {
    _devicesList.clear();
    notifyListeners();
  }

  // Data e hora da última lista gerada
  // (iniciada em nunca antes da primeira lista)
  String _lastScanDate = 'Nunca';
  String get lastScanDate => _lastScanDate;

  void setLastScanDate(String date) {
    _lastScanDate = date;
    notifyListeners();
  }

  // Objeto da chave RSA privada
  var _privateKey = null;
  get privateKey => _privateKey;

  void setPrivateKey(key) {
    _privateKey = key;
    notifyListeners();
  }

  // Objeto da chave RSA pública
  var _publicKey = null;
  get publicKey => _publicKey;

  void setPublicKey(key) {
    _publicKey = key;
    notifyListeners();
  }

  // Objeto da assinatura da lista de dispositivos 
  var _signature = null;
  get signature => _signature;

  void setSignature(sig) {
    _signature = sig;
    notifyListeners();
  }

  // Hash SHA256 da lista de dispositivos 
  var _hashedList;
  get hashedList => _hashedList;

  void setHashedList(hash) {
    _hashedList = hash;
    notifyListeners();
  }

  // Estado da assinatura
  // se a assinatura ainda não foi verificada, contém uma string vazia
  // se ja foi verificada, contém 'válida' ou 'inválida'
  String _signatureState = '';
  get signatureState => _signatureState;

  void setSignatureState(sigState) {
    _signatureState = sigState;
    notifyListeners();
  }
}
