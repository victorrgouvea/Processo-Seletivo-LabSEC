import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';

// Tela acessada pelo botão 'Gerar chave RSA' que mostra
// os dados das chaves RSA geradas

class RsaKeyPage extends StatefulWidget {
  const RsaKeyPage({super.key});

  @override
  State<RsaKeyPage> createState() => _RsaKeyPageState();
}

class _RsaKeyPageState extends State<RsaKeyPage> {
  @override
  Widget build(BuildContext context) {
    // Chaves armazenadas no Provider
    var publicKey = context.watch<AppProvider>().publicKey;
    var privateKey = context.watch<AppProvider>().privateKey;

    // Estrutura dos widgets
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
              'Chaves RSA',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            // Caixa com os dados das chaves RSA
            SizedBox(
              height: 400,
              child: ListView(shrinkWrap: true, children: [
                // Cria o item com os dados da chave pública
                // dependendo se a chave já foi gerada ou não
                (publicKey == null)
                    ? const ListTile(
                        title: Text('Chave privada:'),
                        subtitle: Text('Não gerada'),
                      )
                    : ListTile(
                        title: const Text('Chave privada:'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('- Módulo: ${privateKey.modulus} \n '),
                            Text('- Expoente: ${privateKey.privateExponent}'),
                          ],
                        ),
                      ),
                // Cria o item com os dados da chave privada
                // dependendo se a chave já foi gerada ou não
                (publicKey == null)
                    ? const ListTile(
                        title: Text('Chave pública:'),
                        subtitle: Text('Não gerada'),
                      )
                    : ListTile(
                        title: const Text('Chave pública:'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('- Módulo: ${publicKey.modulus} \n '),
                            Text('- Expoente: ${publicKey.publicExponent}'),
                          ],
                        ),
                      ),
              ]),
            ),
            // Botão que leva a tela de geração de novas chaves
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                Navigator.pushNamed(context, '/gen_key');
              },
              child: const Text(
                'Gerar novas chaves',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
