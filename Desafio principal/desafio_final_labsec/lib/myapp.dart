import 'package:flutter/material.dart';
import 'home_page.dart';
import 'ble_devices_page.dart';
import 'rsa_key_page.dart';
import 'generate_key_page.dart';
import 'sign_list_page.dart';
import 'verify_signature_page.dart';

// Classe com a raiz do aplicativo, onde são
// definidas as rotas que levam a cada tela do app
// através do Navigator, começando pela home page

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/BLE': (context) => const BleDevicesPage(),
        '/RSA_key': (context) => const RsaKeyPage(),
        '/gen_key': (context) => const GenerateKeyPage(),
        '/sign_list': (context) => const SignListPage(),
        '/verify_sign': (context) => const VerifySignaturePage(),
      },
    );
  }
}
