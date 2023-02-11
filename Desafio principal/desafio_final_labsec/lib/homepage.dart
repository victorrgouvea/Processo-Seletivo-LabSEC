import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
            const Text('Escolha uma das opções abaixo:'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                print('BLE');
              },
              child: const Text('Dispositivos BLE'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                print('RSA');
              },
              child: const Text('Gerar chave RSA'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                print('assinar');
              },
              child: const Text('Assinar lista'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(280, 80)),
              onPressed: () {
                print('verificar');
              },
              child: const Text('Verificar assinatura'),
            )
          ],
        ),
      ),
    );
  }
}


/* body: SizedBox(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 80),
                    textStyle: TextStyle(fontSize: 28)),
                onPressed: () {
                  print('oioioioioi');
                },
                child: const Text('Dispositivos BLE')),
          )
        ],
      )), */
