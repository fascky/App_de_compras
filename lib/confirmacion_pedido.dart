import 'package:flutter/material.dart';

class ConfirmacionPedido extends StatelessWidget {
  const ConfirmacionPedido({super.key});

  static const String titulo = 'Confirmación de Pedido';
  static const TextStyle estiloTitulo = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  static const TextStyle estiloTexto = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(titulo)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text('¡Pedido confirmado con éxito!', style: estiloTitulo),
            const SizedBox(height: 10),
            const Text('Gracias por tu compra.', style: estiloTexto),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Volver al inicio', style: estiloTexto),
            ),
          ],
        ),
      ),
    );
  }
}
