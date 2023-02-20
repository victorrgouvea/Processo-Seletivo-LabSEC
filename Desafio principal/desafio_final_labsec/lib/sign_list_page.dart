import 'dart:typed_data';
import 'package:desafio_final_labsec/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' hide State;
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
    var signature = context.watch<AppProvider>().signature;

    void signList() {
      // Concatenamos a lista de dispositivos em uma String
      var conc = devicesList.join('');

      // Transformamos a string da lista no formato
      // necessário para gerar a assinatura
      Uint8List list = Uint8List.fromList(conc.codeUnits);

      // Calculamos o hash SHA256 da lista
      final sha256 = SHA256Digest();
      final listHash = sha256.process(list);

      // Criação do objeto que gera a assinatura
      // incialiazado com a chave privada já gerada anteriormente
      final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
      signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));

      // Geração da assinatura com o hash SHA256 da lista de dispositivos
      final sig = signer.generateSignature(listHash);

      // Guarda a assinatura e o hash no provider
      context.read<AppProvider>().setSignature(sig);
      context.read<AppProvider>().setHashedList(listHash);
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
            SizedBox(
              height: 300,
              width: 350,
              child: (signature == null)
                  ? const SingleChildScrollView(
                      child: Text(
                        'Assinatura: Inexistente',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Text(
                        'Assinatura: ${base64.encode(signature.bytes)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20),
                      ),
                    ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                if (devicesList == []) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'A sua lista de dispositivos não existe ou está vazia')));
                } else if (privateKey == null) {
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
