import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';

class RsaKeyPage extends StatefulWidget {
  const RsaKeyPage({super.key});

  @override
  State<RsaKeyPage> createState() => _RsaKeyPageState();
}

class _RsaKeyPageState extends State<RsaKeyPage> {
  @override
  Widget build(BuildContext context) {
    var publicKey = context.watch<AppProvider>().publicKey;
    var privateKey = context.watch<AppProvider>().privateKey;

    /*var noKeys = Column(
      children: [
        Text('Chave pública: Não gerada'),
        Text(''),
        Text('Chave privada: Não gerada'),
        Text(''),
      ],
    );
    var keysData = Column(
      children: [
        Text('Chave pública:'),
        Text('Modulus: ${publicKey.modulus}'),
        Text('Exponent: ${publicKey.publicExponent}'),
        Text(''),
        Text('Chave privada:'),
        Text('Modulus: ${privateKey.modulus}'),
        Text('Exponent: ${privateKey.privateExponent}'),
        Text(''),
      ],
    );*/

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
              'Chave RSA',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 400,
              child: ListView(
                shrinkWrap: true,
                children: [
                (publicKey == null)
                    ? ListTile(
                        title: Text('Chave privada:'),
                        subtitle: Text('Não gerada'),
                      )
                    : ListTile(
                        title: Text('Chave privada:'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Módulo: ${privateKey.modulus}'),
                            Text('Expoente: ${privateKey.privateExponent}'),
                          ],
                        ),
                      ),
                ListView(
                  children: [
                    (publicKey == null)
                        ? ListTile(
                            title: Text('Chave pública:'),
                            subtitle: Text('Não gerada'),
                          )
                        : ListTile(
                            title: Text('Chave pública:'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Módulo: ${publicKey.modulus}'),
                                Text('Expoente: ${publicKey.publicExponent}'),
                              ],
                            ),
                          ),
                  ],
                )
              ]),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                Navigator.pushNamed(context, '/gen_key');
              },
              child: const Text(
                'Gerar nova chave',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
