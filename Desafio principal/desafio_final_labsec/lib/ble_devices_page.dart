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
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {

                flutter_blue.startScan(timeout: Duration(seconds: 5));

                var scan_results = flutter_blue.scanResults.listen((results) {
                  for (ScanResult r in results) {
                    print('${r.device.name} found! rssi: ${r.rssi}');
                  }
                });

                flutter_blue.stopScan();
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
