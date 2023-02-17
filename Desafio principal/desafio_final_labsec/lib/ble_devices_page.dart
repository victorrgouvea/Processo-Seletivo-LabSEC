import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // biblioteca para formatar a data
import 'app_provider.dart';

class BleDevicesPage extends StatefulWidget {
  const BleDevicesPage({super.key});

  @override
  State<BleDevicesPage> createState() => _BleDevicesPageState();
}

class _BleDevicesPageState extends State<BleDevicesPage> {
  FlutterBlue flutter_blue = FlutterBlue.instance;
  bool all_permissions = true;


  @override
  Widget build(BuildContext context) {
    var devices = context.watch<AppProvider>().devicesList;
    var date_time = context.watch<AppProvider>().lastScanDate;

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
        context.read<AppProvider>().cleanDevicesList();
        var id_list = [];
        // Caso as permissões sejam concedidas, inicia a
        // procura por dispositivos BLE
        // Armazenamos os dados dos dispositivos detectados
        flutter_blue.startScan(timeout: Duration(seconds: 1));

        var scan_results = flutter_blue.scanResults.listen((results) {
          for (ScanResult r in results) {
            if (!id_list.contains(r.device.id.toString())) {
              context.read<AppProvider>().addDevicesList(r.device);
              id_list.add(r.device.id.toString());
            }
          }
        });
        flutter_blue.stopScan();
      }
    }

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
            Text(
              'Dispositivos detectados: ${devices.length} \n Última varredura: ${date_time}',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
            ),
            SizedBox(
              height: 400,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    var nome = devices[index].name;
                    var id = devices[index].id.toString();
                    if (nome == '') {
                      nome = 'Nome desconhecido';
                    }
                    return ListTile(
                      title: Text('- $nome'),
                      subtitle: Text(id),
                    );
                  }),
            ),
            // Botão que faz a listagem dos dispositivos BLE próximos
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                // Pega e formata data e hora da varredura
                DateTime now = DateTime.now();
                String formated_date =
                    DateFormat('dd/MM/yyyy - HH:mm:ss').format(now);
                context.read<AppProvider>().setLastScanDate(formated_date);

                // Checa as permissões bluetooth
                checkPermission();

                // Faz o scan por dispositivos BLE
                bluetooth_scan();
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
