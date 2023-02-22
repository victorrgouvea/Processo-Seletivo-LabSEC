import 'dart:typed_data';
import 'package:desafio_final_labsec/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' hide State;
import 'package:provider/provider.dart';
import 'dart:convert';

// Tela acessada pelo botão 'Assinar lista', onde pode ser
// feita uma assinatura da lista de dispositivos com as chaves RSA
// geradas e a assinatura é mostrada em formato Base64

class SignListPage extends StatefulWidget {
  const SignListPage({super.key});

  @override
  State<SignListPage> createState() => _SignListPageState();
}

class _SignListPageState extends State<SignListPage> {
  @override
  Widget build(BuildContext context) {
    // Dados do Provider
    var devicesList = context.watch<AppProvider>().devicesList;
    var privateKey = context.watch<AppProvider>().privateKey;
    var signature = context.watch<AppProvider>().signature;
    
    bool changedSignature = false;

    // Assina a lista de dispositivos usando a chave privada
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

      // Verifica se a assinatura mudou para resetar o estado da
      // tela de verificação da assinatura para inidicar 'não verificada'
      if (sig != signature) {
        changedSignature = true;
      }

      // Guarda a assinatura e o hash no provider
      context.read<AppProvider>().setSignature(sig);
      context.read<AppProvider>().setHashedList(listHash);
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
              'Assinar lista',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            // Caixa que contém a assinatura em formato Base64
            SizedBox(
              height: 300,
              width: 350,
              child: (signature == null)  // Verifica se a assinatura existe
                  ? const SingleChildScrollView(  // Caso ainda não exista, diz que é inexistente
                      child: Text(
                        'Assinatura: Inexistente',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20),
                      ),
                    )
                  : SingleChildScrollView(   // Caso exista, mostra a assinatura em Base64
                      child: Text(
                        'Assinatura: ${base64.encode(signature.bytes)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20),
                      ),
                    ),
            ),
            // Botão que realiza a assinatura quando pressionado
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                // Verirfica se a lista de dispositivos está vazia e se sim,
                // lança um aviso e impede a geração da assinatura.
                // O mesmo acontece para a chave privada
                if (devicesList.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'A sua lista de dispositivos não existe ou está vazia')));
                } else if (privateKey == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Você deve gerar suas chaves RSA para assinar a lista de dispositivos')));
                } else {
                  // Assina a lista, e em caso de ArgumentError, indica que a chave atual tem um tamanho
                  // muito pequeno para assinar a lista de dispositivos (algo do próprio PointyCastle)
                  // Também utilizamos um catch para outros eventuais erros de compatibilidade entre a 
                  // lista e a chave atual
                  try {
                    signList();
                  } on ArgumentError {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'A chave atual não pode ser usada para assinar a lista, crie um novo par de chaves com um tamanho maior')));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Algo deu errado, tente gerar outra chave para assinar a lista')));
                  }
                  // Caso a assinatura tenha mudado, resetamos o estado da verificação da assinatura
                  if (changedSignature) {
                    context.read<AppProvider>().setSignatureState('');
                  }
                }
              },
              // Texto do botão
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
