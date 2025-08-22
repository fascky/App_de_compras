// lib/pagina_principal.dart
import 'package:app_de_compras/widgets/header.dart';
import 'package:flutter/material.dart';

class InicioWeb extends StatelessWidget {
  const InicioWeb ({super.key});

  static const String appNombre = 'App de Compras';
  static const TextStyle estiloTitulo = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle estiloTexto = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWeb(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenido a la App de Compras', style: estiloTitulo),
          ],
        ),
      ),
    );
  }
}
