// lib/pagina_principal.dart
import 'package:flutter/material.dart';
import 'lista_produc.dart';     // verifica que el nombre del archivo coincida
import 'carrito_compras.dart';

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

  static const String appNombre = 'App de Compras';
  static const TextStyle estiloTitulo = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle estiloTexto = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(appNombre)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenido a la App de Compras', style: estiloTitulo),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const ListaProductos(),
                ));
              },
              child: const Text('Ver Productos', style: estiloTexto),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const CarritoCompras(),
                ));
              },
              child: const Text('Ver Carrito', style: estiloTexto),
            ),
          ],
        ),
      ),
    );
  }
}
