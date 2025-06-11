import 'package:flutter/material.dart';
import 'package:myapp/homepage.dart'; // Este será el formulario principal de inventario

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlondGames', // Nombre de la aplicación
      debugShowCheckedModeBanner: false,
      home: HomePage(), // El punto de entrada principal
      routes: {
        "/home": (context) => HomePage(),
      },
    );
  }
}