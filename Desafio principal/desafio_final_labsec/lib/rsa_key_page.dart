import 'package:flutter/material.dart';

class RsaKeyPage extends StatefulWidget {
  const RsaKeyPage({super.key});

  @override
  State<RsaKeyPage> createState() => _RsaKeyPageState();
}

class _RsaKeyPageState extends State<RsaKeyPage> {
  @override
  Widget build(BuildContext context) {
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
