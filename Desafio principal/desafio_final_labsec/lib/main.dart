import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'myapp.dart';
import 'app_provider.dart';

void main() {
  runApp(ChangeNotifierProvider<AppProvider>(
    child: const MyApp(),
    create: (_) => AppProvider(),
  ));
}
