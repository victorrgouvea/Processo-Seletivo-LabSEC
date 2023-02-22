import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart'; // biblioteca para formatar a data
import 'package:provider/provider.dart';
import 'app_provider.dart';

// Tela acessada pelo botão 'Dispositivos BLE' que
// mostra os dispositivos BLE detectados e a data e hora
// da última detecção

class BleDevicesPage extends StatefulWidget {
  const BleDevicesPage({super.key});

  @override
  State<BleDevicesPage> createState() => _BleDevicesPageState();
}

class _BleDevicesPageState extends State<BleDevicesPage> {
  // Instáncia do flutter blue, que será responsável
  // pela busca de dispositivos BLE
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

    // Verifica se as permissões foram aceitas ou não
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
    // Pede e verifica as permissões bluetooth/dispositivos próximos
    // ao entrar na página
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Variáveis do Provider
    var devices = context.watch<AppProvider>().devicesList;
    var dateTime = context.watch<AppProvider>().lastScanDate;

    // Procura por dispositivos BLE próximos e atualiza a 
    // lista de dispositivos do Provider
    void bluetoothScan() {
      // Desabilita o botão de atualizar lista enquanto o scan é realizado
      setState(() {
        enableButton = false;
      });
      
      // Limpa a lista de dispositivos no Provider e
      // cria uma lista auxiliar para armazenar os id's
      // dos dispositivos que já foram scaneados para evitar
      // cópias na lista
      context.read<AppProvider>().cleanDevicesList();
      var idList = [];

      // Variável que armazena os resultados do scan, faz a 
      // verificação se já estão na lista por id e adiciona 
      // na lista do Provider
      var scanResults = flutter_blue.scanResults.listen((results) {
        for (ScanResult r in results) {
          if (!idList.contains(r.device.id.toString())) {
            idList.add(r.device.id.toString());
            context.read<AppProvider>().addDevicesList(r.device);
          }
        }
      });
      // Começa e termina o scan após 1 segundo
      flutter_blue.startScan(timeout: Duration(seconds: 1));
      flutter_blue.stopScan();

      // Delay de 2 segundos para reativar o botão de atualizar lista
      // para evitar erro de 2 scans ao mesmo tempo que pode ser gerado
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          enableButton = true;
        });
      });
    }

    // Reseta a assinatura e o seu estado de válida/inválida no Provider
    void resetSignature() {
      context.read<AppProvider>().setSignature(null);
      context.read<AppProvider>().setSignatureState('');
    }

    // Estrutura de widgets da tela
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
            // Caixa que mostra a lista de dispositivos
            SizedBox(
              height: 400,
              // Constroi cada item da lista de dispositivos com seu
              // respectivo nome e id. Caso o dispositivo não tenha nome,
              // é indicado que o nome é desconhecido
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
              onPressed: (!enableButton)  // verifica se o botão deve ser ativado ou não
                  ? null  // Botão desativado
                  : () {  // Botão ativado
                      // Pega e formata data e hora da varredura
                      DateTime now = DateTime.now();
                      String formatedDate =
                          DateFormat('dd/MM/yyyy - HH:mm:ss').format(now);
                      context.read<AppProvider>().setLastScanDate(formatedDate);

                      // Gera um aviso caso as permissões bluetooth/dispositivos próximos
                      // não tenham sido aceitas
                      if (!all_permissions) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'As permissôes de bluetooth e dispositivos próximos é necessária para listar os dispositivos BLE. Ative-a nas configurações do seu celular')));
                      } else {
                        // Se as permissões foram aceitas, atualiza a lista de dispositivos BLE
                        // e reseta a assinatura e a sua verfiicação geradas a partir da lista antiga
                        // (Aqui uso um try-catch para tentar evitar diversas exceções
                        //  imprevisiveisque o scan gera)
                        try {
                          bluetoothScan();
                          resetSignature();
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
