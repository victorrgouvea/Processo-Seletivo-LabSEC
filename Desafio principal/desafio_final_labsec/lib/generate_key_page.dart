import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' hide Padding, State;
import 'package:pointycastle/src/platform_check/platform_check.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';

// Tela acessada pelo botão 'Gerar nova chave' dentro da tela de chaves RSA

class GenerateKeyPage extends StatefulWidget {
  const GenerateKeyPage({super.key});

  @override
  State<GenerateKeyPage> createState() => _GenerateKeyPageState();
}

class _GenerateKeyPageState extends State<GenerateKeyPage> {
  @override
  Widget build(BuildContext context) {
    // Variável que controla o texto do TextField
    TextEditingController number_controller = TextEditingController();

    // Gera as chaves RSA de tamanho especificado com a biblioteca PointyCastle
    void generateRsaKeys(int keySize) {
      // Gerador de número aleatório
      final secureRandom = SecureRandom('Fortuna')
        ..seed(KeyParameter(
            Platform.instance.platformEntropySource().getBytes(32)));

      // Objeto gerador de chave RSA
      final keyGen = RSAKeyGenerator();

      // Inicialização do gerador de chaves com o tamanho passado de argumento
      keyGen.init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), keySize, 64),
          secureRandom));

      // Geração das chaves
      final keyPair = keyGen.generateKeyPair();

      // Chaves pública e privada
      final public = keyPair.publicKey as RSAPublicKey;
      final private = keyPair.privateKey as RSAPrivateKey;

      // Aramazena as chaves no Provider
      context.read<AppProvider>().setPublicKey(public);
      context.read<AppProvider>().setPrivateKey(private);
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
              'Gerar novas chaves',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            // Caixa de texto para ser passado o tamanho da chave a ser gerada
            Padding(
              padding: const EdgeInsets.all(40),
              child: TextField(
                controller: number_controller,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                    hintText: 'Tamanho da chave', border: OutlineInputBorder()),
              ),
            ),
            // Botão que gera as chaves
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                // Transforma o número do TextField em int e verifica se o 
                // número foi tranformado corretamente e se o tamanho escolhido é
                // válido para gerar as chaves. Caso alguma condição seja
                // quebrada, gera um aviso
                var key_size = int.tryParse(number_controller.text);
                if (key_size == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'O tamanho da chave deve ser um número inteiro')));
                } else {
                  if (key_size < 12) {  // Condição do PointyCastle para gerar a chave
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'O tamanho da chave deve ser um número positivo e maior que 11')));
                  } else {
                    // Catch para eventuais erros de alguns tamanhos de chave que não podem ser criados
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
              // Texto do botão
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
