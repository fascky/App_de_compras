import 'package:flutter/material.dart';

class ListaProductos extends StatelessWidget {
  const ListaProductos({super.key});

  // 🔸 Constantes de estilo y texto
  static const String tituloPagina = 'Lista de Productos';
  static const TextStyle estiloTitulo = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle estiloTexto = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    // 🔸 Lista simulada de productos
    final List<Map<String, dynamic>> productos = [
      {'nombre': 'Camisa', 'precio': 25.50},
      {'nombre': 'Zapatos', 'precio': 49.99},
      {'nombre': 'Pantalón', 'precio': 35.00},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text(tituloPagina)),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(producto['nombre'], style: estiloTitulo),
              subtitle: Text('Precio: \$${producto['precio']}', style: estiloTexto),
              trailing: const Icon(Icons.add_shopping_cart),
              onTap: () {
                // Aquí podrías agregar el producto al carrito
              },
            ),
          );
        },
      ),
    );
  }
}
