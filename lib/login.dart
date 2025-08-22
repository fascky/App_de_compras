import 'package:flutter/material.dart';
import 'pagina_principal.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String titulo = 'Iniciar Sesión';
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
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PaginaPrincipal()),
                );
              },
              child: const Text('Ingresar', style: estiloTexto),
            ),
          ],
        ),
      ),
    );
  }
}
