import 'dart:typed_data';

import 'package:desafio_final_labsec/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' hide State;
import 'package:pointycastle/pointycastle.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class SignListPage extends StatefulWidget {
  const SignListPage({super.key});

  @override
  State<SignListPage> createState() => _SignListPageState();
}

class _SignListPageState extends State<SignListPage> {
  @override
  Widget build(BuildContext context) {
    var devicesList = context.watch<AppProvider>().devicesList;
    var privateKey = context.watch<AppProvider>().privateKey;

    void signList() {
      // Concatenamos a lista de dispositivos em uma String
      // para aplicarmos o SHA256
      final jsonString = jsonEncode(devicesList);
      final jsonBytes = utf8.encode(jsonString);
      final sha256 = SHA256Digest();
      //final digestSHA256 = sha256.process(jsonBytes);

      final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
      signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));

      //final sig = signer.generateSignature();
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
              'Assinar lista',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Text(
              'Assinatura:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                if (devicesList == []) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'A sua lista de dispositivos não existe ou está vazia')));
                }
                if (privateKey == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Você deve gerar suas chaves RSA para assinar a lista de dispositivos')));
                } else {
                  signList();
                }
              },
              child: const Text(
                'Assinar novamente',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
