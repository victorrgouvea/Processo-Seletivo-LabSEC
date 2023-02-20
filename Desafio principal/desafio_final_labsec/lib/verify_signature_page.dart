import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' hide State;
import 'package:provider/provider.dart';
import 'app_provider.dart';

class VerifySignaturePage extends StatefulWidget {
  const VerifySignaturePage({super.key});

  @override
  State<VerifySignaturePage> createState() => _VerifySignaturePageState();
}

class _VerifySignaturePageState extends State<VerifySignaturePage> {
  @override
  Widget build(BuildContext context) {
    var publicKey = context.watch<AppProvider>().publicKey;
    var signature = context.watch<AppProvider>().signature;
    var signedData = context.watch<AppProvider>().hashedList;
    String signatureState = context.watch<AppProvider>().signatureState;

    bool verifySignature() {
      // Cria o objeto RSASigner, agora utilizando a chave pública
      // e passando false no init para indicar que é um verificador
      final verifier = RSASigner(SHA256Digest(), '0609608648016503040201');
      verifier.init(false, PublicKeyParameter<RSAPublicKey>(publicKey));

      // Utiliza o hash criado a partir da lista de dispositivos e
      // a assinatura gerada para verificar se a assinatura é valida
      bool isValid;
      try {
        isValid = verifier.verifySignature(signedData, signature);
      } on ArgumentError {
        isValid = false;
      }

      return isValid;
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
              'Verificar assinatura',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            // Condição para escolher o texto antes ou depois da verificação
            (signatureState == '')
                ? const Text(
                    'Assinatura não verificada',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                  )
                : Text(
                    'Assinatura $signatureState',
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 20),
                  ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                bool isValid = verifySignature();
                String result = (isValid) ? 'válida' : 'inválida';
                context.read<AppProvider>().setSignatureState(result);
              },
              child: const Text(
                'Verificar novamente',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
