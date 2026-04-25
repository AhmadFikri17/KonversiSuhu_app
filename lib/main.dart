import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/suhu_provider.dart';
import 'pages/suhu_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SuhuProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Konversi Suhu',
      debugShowCheckedModeBanner: false,
      home: KonversiSuhuPage(),
    );
  }
}
