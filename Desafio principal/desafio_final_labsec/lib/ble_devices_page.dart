import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class BleDevicesPage extends StatefulWidget {
  const BleDevicesPage({super.key});

  @override
  State<BleDevicesPage> createState() => _BleDevicesPageState();
}

class _BleDevicesPageState extends State<BleDevicesPage> {
  FlutterBlue flutter_blue = FlutterBlue.instance;
  var date_time;
  var devices_name = [];
  bool all_permissions = true;

  // Checa todas as permissões
  checkPermission() async {
    // Permissões para o bluetooth
    PermissionStatus bluetooth_scan = await Permission.bluetoothScan.request();

    PermissionStatus bluetooth_connect =
        await Permission.bluetoothConnect.request();

    PermissionStatus bluetooth_adv =
        await Permission.bluetoothAdvertise.request();

    // Se a permissão foi negada, uma mensagem de aviso é exibida
    if (bluetooth_scan == PermissionStatus.permanentlyDenied) {
      all_permissions = false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'As permissôes de bluetooth e dispositivos próximos é necessária para listar os dispositivos BLE. Ative-a nas configurações do seu celular')));
    } else {
      all_permissions = true;
    }
  }

  // https://blog.kuzzle.io/communicate-through-ble-using-flutter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LabSEC - Desafio principal'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: const Color.fromARGB(255, 188, 198, 203),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Dispositivos BLE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: devices_name.length,
                itemBuilder: (context, index) {
                  var iter = devices_name[index];
                  return ListTile(
                    title: Text('- $iter'),
                  );
                }),
            // Botão que faz a listagem dos dispositivos BLE próximos
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                checkPermission();
                if (all_permissions) {
                  devices_name = [];
                  // Caso as permissões sejam concedidas, inicia a
                  // procura por dispositivos BLE
                  flutter_blue.startScan(timeout: Duration(seconds: 3));
                  setState(() {
                    // Armazenamos os dados dos dispositivos detectados
                    var scan_results =
                        flutter_blue.scanResults.listen((results) {
                      print(results);
                      for (ScanResult r in results) {
                        devices_name.add(r.device.name);
                        print('${r.device.name} found! rssi: ${r.rssi}');
                      }
                    });

                    flutter_blue.stopScan();
                  });
                }
              },
              child: const Text(
                'Atualizar lista',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
