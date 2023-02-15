import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class BleDevicesPage extends StatefulWidget {
  BleDevicesPage({super.key});

  FlutterBlue flutter_blue = FlutterBlue.instance;
  var devices = [];
  //bool all_permissions = true;

  @override
  State<BleDevicesPage> createState() => _BleDevicesPageState();
}

class _BleDevicesPageState extends State<BleDevicesPage> {
  //FlutterBlue flutter_blue = FlutterBlue.instance;
  //var date_time;
  //var devices = [];
  bool all_permissions = true;

  // Checa todas as permissões
  void checkPermission() async {
    // Permissões para o bluetooth
    PermissionStatus bluetooth_scan = await Permission.bluetoothScan.request();

    PermissionStatus bluetooth_connect =
        await Permission.bluetoothConnect.request();

    PermissionStatus bluetooth_adv =
        await Permission.bluetoothAdvertise.request();

    // Se a permissão foi negada, uma mensagem de aviso é exibida
    if (bluetooth_scan == PermissionStatus.permanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'As permissôes de bluetooth e dispositivos próximos é necessária para listar os dispositivos BLE. Ative-a nas configurações do seu celular')));
      all_permissions = false;
    } else {
      all_permissions = true;
    }
  }

  void bluetooth_scan() {
    if (all_permissions) {
      widget.devices = [];
      var id_list = [];
      // Caso as permissões sejam concedidas, inicia a
      // procura por dispositivos BLE
      // Armazenamos os dados dos dispositivos detectados
      widget.flutter_blue.startScan(timeout: Duration(seconds: 1));

      var scan_results = widget.flutter_blue.scanResults.listen((results) {
        print(results);
        for (ScanResult r in results) {
          if (!id_list.contains(r.device.id.toString())) {
            widget.devices.add(r.device);
            id_list.add(r.device.id.toString());
          }
        }
      });
      widget.flutter_blue.stopScan();
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
                itemCount: widget.devices.length,
                itemBuilder: (context, index) {
                  var nome = widget.devices[index].name;
                  var id = widget.devices[index].id.toString();
                  if (nome == '') {
                    nome = 'Nome desconhecido';
                  }
                  return ListTile(
                    title: Text('- $nome'),
                    subtitle: Text(id),
                  );
                }),
            // Botão que faz a listagem dos dispositivos BLE próximos
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                //late int all_permissions;
                checkPermission();

                bluetooth_scan();

                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {});
                });
                //setState(() {
                /*if (all_permissions) {
                    devices = [];
                    // Caso as permissões sejam concedidas, inicia a
                    // procura por dispositivos BLE
                    flutter_blue.startScan(timeout: Duration(seconds: 3));
                      // Armazenamos os dados dos dispositivos detectados
                      var scan_results =
                          flutter_blue.scanResults.listen((results) {
                        print(results);
                        for (ScanResult r in results) {
                          devices.add(r.device.name);
                        }
                      });

                      flutter_blue.stopScan();
                  }*/
                //});
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
