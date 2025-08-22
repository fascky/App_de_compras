import 'package:flutter/material.dart';

class CarritoCompras extends StatelessWidget {
  const CarritoCompras({super.key});

  static const String titulo = 'Carrito de Compras';
  static const TextStyle estiloTitulo = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle estiloTexto = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> carrito = [
      {'nombre': 'Camisa', 'precio': 25.50, 'cantidad': 2},
      {'nombre': 'Zapatos', 'precio': 49.99, 'cantidad': 1},
    ];

    // ✅ Corrección: casteo seguro para precio y cantidad
    double total = carrito.fold(0, (sum, item) {
      final precio = (item['precio'] ?? 0) as double;
      final cantidad = (item['cantidad'] ?? 0) as int;
      return sum + precio * cantidad;
    });

    return Scaffold(
      appBar: AppBar(title: const Text(titulo)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: carrito.length,
              itemBuilder: (context, index) {
                final item = carrito[index];
                return ListTile(
                  title: Text(item['nombre'].toString(), style: estiloTitulo),
                  subtitle: Text(
                    'Cantidad: ${item['cantidad']} - Precio: \$${item['precio']}',
                    style: estiloTexto,
                  ),
                  trailing: const Icon(Icons.remove_shopping_cart),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total: \$${total.toStringAsFixed(2)}', style: estiloTitulo),
          ),
        ],
      ),
    );
  }
}
