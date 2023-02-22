import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'myapp.dart';
import 'app_provider.dart';
import 'package:flutter/services.dart';

void main() {
  // Garanto que o app fique apenas na vertical
  // e não gire a tela para evitar overflow de widgets
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    // Inicio do app, juntamente com a instancia do provider
    runApp(ChangeNotifierProvider<AppProvider>(
      child: const MyApp(),
      create: (_) => AppProvider(),
    ));
  });
}
