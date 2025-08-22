import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DashAdmin extends StatefulWidget {
  const DashAdmin({super.key});

  @override
  State<DashAdmin> createState() => _DashAdminState();
}

class _DashAdminState extends State<DashAdmin> {
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  final _descripcionController = TextEditingController();

  File? _imagenSeleccionada;

  Future<void> _seleccionarImagen() async {
    final resultado = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (resultado != null && resultado.files.single.path != null) {
      setState(() {
        _imagenSeleccionada = File(resultado.files.single.path!);
      });
    }
  }

  void _guardarProducto() {
    if (_nombreController.text.isEmpty ||
        _precioController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _imagenSeleccionada == null) {
      _mostrarAlerta("Completa todos los campos e incluye una imagen.");
      return;
    }

    // Aquí podrías guardar en base de datos o backend
    _mostrarAlerta("✅ Producto agregado correctamente.");
    _limpiarCampos();
  }

  void _limpiarCampos() {
    _nombreController.clear();
    _precioController.clear();
    _stockController.clear();
    _descripcionController.clear();
    setState(() {
      _imagenSeleccionada = null;
    });
  }

  void _mostrarAlerta(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Información"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de Administración"),
        backgroundColor: const Color(0xFFFED7C3),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Agregar Nuevo Producto",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: "Nombre del producto",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _precioController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Precio",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Stock",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.inventory),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descripcionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Descripción",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _seleccionarImagen,
                  icon: const Icon(Icons.image),
                  label: const Text("Seleccionar Imagen"),
                ),
                const SizedBox(height: 12),
                if (_imagenSeleccionada != null)
                  Image.file(
                    _imagenSeleccionada!,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _guardarProducto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Guardar Producto"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
