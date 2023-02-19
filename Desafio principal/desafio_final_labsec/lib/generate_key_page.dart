import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' hide Padding, State;
import 'package:pointycastle/src/platform_check/platform_check.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';

class GenerateKeyPage extends StatefulWidget {
  const GenerateKeyPage({super.key});

  @override
  State<GenerateKeyPage> createState() => _GenerateKeyPageState();
}

class _GenerateKeyPageState extends State<GenerateKeyPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController number_controller = TextEditingController();

    void generateRsaKeys(int keySize) {
      final seedGen = Random.secure();
      final secureRandom = SecureRandom('Fortuna')
        ..seed(KeyParameter(
            Platform.instance.platformEntropySource().getBytes(32)));

      final keyGen = RSAKeyGenerator();

      keyGen.init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), keySize, 64),
          secureRandom));

      final keyPair = keyGen.generateKeyPair();

      final public = keyPair.publicKey as RSAPublicKey;
      final private = keyPair.privateKey as RSAPrivateKey;

      context.read<AppProvider>().setPublicKey(public);
      context.read<AppProvider>().setPrivateKey(private);
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
              'Gerar novas chaves',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: TextField(
                controller: number_controller,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                    hintText: 'Tamanho da chave', border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                var key_size = int.tryParse(number_controller.text);
                if (key_size == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'O tamanho da chave deve ser um número inteiro')));
                } else {
                  if (key_size < 12) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'O tamanho da chave deve ser um número positivo e maior que 11')));
                  } else {
                    try {
                      generateRsaKeys(key_size);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Chaves geradas!')));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'As chaves não podem ser geradas com esse tamanho, tente outro número válido')));
                    }
                  }
                }
              },
              child: const Text(
                'Gerar chaves',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
