import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:app_de_compras/widgets/header.dart';

class CarritoCompras extends StatefulWidget {
  const CarritoCompras({super.key});

  @override
  State<CarritoCompras> createState() => _CarritoComprasState();
}

class _CarritoComprasState extends State<CarritoCompras> {
  final List<Map<String, dynamic>> carrito = [
    {
      'nombre': 'POLO NEGRO CLÁSICO',
      'precio': 229.00,
      'cantidad': 1,
      'imagen': 'img/polonegro.jpg',
      'talla': 'L'
    },
    {
      'nombre': 'ZAPATILLAS DEPORTIVAS',
      'precio': 429.00,
      'cantidad': 1,
      'imagen': 'img/zapatillas1.jpg',
      'talla': '42'
    },
  ];

  void _mostrarDialogoExito(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Pago Exitoso'),
        content: const Text('Tu pedido ha sido procesado correctamente.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color fondoClaro = Color(0xFFF8F7FB);

    final double subtotal = carrito.fold(
      0,
      (sum, item) => sum + (item['precio'] as double) * (item['cantidad'] as int),
    );
    final double descuento = subtotal * 0.10;
    const double envio = 20.00;
    final double total = subtotal - descuento + envio;

    return Scaffold(
      backgroundColor: fondoClaro,
      appBar: const HeaderWeb(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- LISTA DE PRODUCTOS -----
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.40),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Carrito de Compras",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: carrito.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 24, thickness: 1, color: Colors.grey[300]),
                        itemBuilder: (context, index) {
                          final item = carrito[index];
                          final double totalItem =
                              (item['precio'] as double) * (item['cantidad'] as int);

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  item['imagen'],
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['nombre'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text('Talla: ${item['talla']}',
                                        style: TextStyle(color: Colors.grey[600])),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (item['cantidad'] > 1) item['cantidad']--;
                                            });
                                          },
                                          icon: const Icon(Icons.remove_circle_outline,
                                              color: Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                        Text("${item['cantidad']}",
                                            style: const TextStyle(fontSize: 18)),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              item['cantidad']++;
                                            });
                                          },
                                          icon: const Icon(Icons.add_circle_outline,
                                              color: Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                        const Spacer(),
                                        Text("S/ ${totalItem.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 18)),
                                        IconButton(
                                          tooltip: 'Quitar producto',
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            setState(() => carrito.removeAt(index));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 24),

            // ----- RESUMEN -----
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFFED7C3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Resumen del Pedido',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    _filaResumen("Subtotal", subtotal),
                    _filaResumen("Descuento (10%)", -descuento),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Envío", style: TextStyle(fontSize: 18)),
                        Text("S/ 20.00", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total", style: TextStyle(fontSize: 20)),
                        Text("S/ ${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 22, color: Color.fromARGB(255, 0, 0, 0))),
                      ],
                    ),
                    const Spacer(),

                    // Botón Glass SIN COLOR
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: GestureDetector(
                          onTap: () => _mostrarDialogoExito(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: const Text(
                              'Pagar Ahora',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filaResumen(String titulo, double valor) {
    final esNegativo = valor < 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 18), // sin negrita
        ),
        Text(
          "${esNegativo ? '- ' : ''}S/ ${valor.abs().toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 18,
            color: esNegativo ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }
}
