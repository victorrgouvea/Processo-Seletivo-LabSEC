import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart'; // biblioteca para formatar a data
import 'package:provider/provider.dart';
import 'app_provider.dart';

class BleDevicesPage extends StatefulWidget {
  const BleDevicesPage({super.key});

  @override
  State<BleDevicesPage> createState() => _BleDevicesPageState();
}

class _BleDevicesPageState extends State<BleDevicesPage> {
  FlutterBlue flutter_blue = FlutterBlue.instance;
  bool all_permissions = true;
  bool enableButton = true;

  // Checa todas as permissões
  void checkPermission() async {
    // Permissões para o bluetooth
    PermissionStatus bluetoothScan = await Permission.bluetoothScan.request();

    PermissionStatus bluetoothConnect =
        await Permission.bluetoothConnect.request();

    PermissionStatus bluetoothAdv =
        await Permission.bluetoothAdvertise.request();

    // Se a permissão foi negada, uma mensagem de aviso é exibida
    if (bluetoothScan == PermissionStatus.permanentlyDenied ||
        bluetoothConnect == PermissionStatus.permanentlyDenied ||
        bluetoothAdv == PermissionStatus.permanentlyDenied) {
      all_permissions = false;
    } else {
      all_permissions = true;
    }
  }

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var devices = context.watch<AppProvider>().devicesList;
    var dateTime = context.watch<AppProvider>().lastScanDate;

    void bluetoothScan() {
      setState(() {
        enableButton = false;
      });
      context.read<AppProvider>().cleanDevicesList();
      var idList = [];
      // Caso as permissões sejam concedidas, inicia a
      // procura por dispositivos BLE
      // Armazenamos os dados dos dispositivos detectados

      var scanResults = flutter_blue.scanResults.listen((results) {
        for (ScanResult r in results) {
          if (!idList.contains(r.device.id.toString())) {
            idList.add(r.device.id.toString());
            context.read<AppProvider>().addDevicesList(r.device);
          }
        }
      });
      flutter_blue.startScan(timeout: Duration(seconds: 1));
      flutter_blue.stopScan();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          enableButton = true;
        });
      });
    }

    void resetSignature() {
      context.read<AppProvider>().setSignature(null);
      context.read<AppProvider>().setSignatureState('');
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
              'Dispositivos detectados: ${devices.length} \nÚltima varredura: $dateTime',
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
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
              onPressed: (!enableButton)
                  ? null
                  : () {
                      // Pega e formata data e hora da varredura
                      DateTime now = DateTime.now();
                      String formatedDate =
                          DateFormat('dd/MM/yyyy - HH:mm:ss').format(now);
                      context.read<AppProvider>().setLastScanDate(formatedDate);

                      if (!all_permissions) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'As permissôes de bluetooth e dispositivos próximos é necessária para listar os dispositivos BLE. Ative-a nas configurações do seu celular')));
                      } else {
                        resetSignature();
                        // Faz o scan por dispositivos BLE
                        try {
                          bluetoothScan();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Algum erro ocoreu, tente atualizar a lista novamente')));
                        }
                      }
                    },
              // Texto do botão
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
