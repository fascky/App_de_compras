import 'package:flutter/material.dart';

class RegistroPage extends StatelessWidget {
  const RegistroPage({super.key});

  static const String titulo = 'Registro de Usuario';
  static const TextStyle estiloTitulo = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle estiloTexto = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(titulo)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(titulo, style: estiloTitulo),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(labelText: 'Nombre completo'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Registrarse', style: estiloTexto),
            ),
          ],
        ),
      ),
    );
  }
}
