import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' hide State;
import 'package:provider/provider.dart';
import 'app_provider.dart';

// Tela acessada pelo botão 'Verificar assinatura', onde é feita
// a verificação da assinatura gerada através da lista de dispositivos

class VerifySignaturePage extends StatefulWidget {
  const VerifySignaturePage({super.key});

  @override
  State<VerifySignaturePage> createState() => _VerifySignaturePageState();
}

class _VerifySignaturePageState extends State<VerifySignaturePage> {
  @override
  Widget build(BuildContext context) {
    // Dados do Provider
    var publicKey = context.watch<AppProvider>().publicKey;
    var signature = context.watch<AppProvider>().signature;
    var signedData = context.watch<AppProvider>().hashedList;
    String signatureState = context.watch<AppProvider>().signatureState;

    // Faz a verificação da assinatura usando a chave pública,
    // a assinatura gerada e o hash SHA256 da lista de dispositivos
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

    // Estrutura de widgets
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
                ? const Text(    // Caso a assinatura ainda não tenha sido verificada
                    'Assinatura não verificada',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                  )
                : Text(          // Caso a assinatura já tenha sido verificada
                    'Assinatura $signatureState',
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 20),
                  ),
            // Botão que faz a verificação da assinatura
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                // Caso a assinatura já exista, fazemos a verificação e mudo
                // o estado da assinatura como válida ou inválida no Provider
                // Se a assinatura ainda não exista, a verificação não é
                // feita e um aviso é gerado
                if (signature != null) {
                  bool isValid = verifySignature();
                  String result = (isValid) ? 'válida' : 'inválida';
                  context.read<AppProvider>().setSignatureState(result);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Não existe nenhuma assinatura para ser verificada, assine a lista para fazer a verificação')));
                }
              },
              // Texto do botão
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
