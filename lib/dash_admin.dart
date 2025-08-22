import 'dart:io';
import 'dart:typed_data';
import 'package:app_de_compras/inicio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;

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

  File? _imagenFile;
  Uint8List? _imagenBytes;

  Future<void> _seleccionarImagen() async {
    try {
      final resultado =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (resultado == null) return;

      if (kIsWeb) {
        setState(() {
          _imagenBytes = resultado.files.single.bytes;
        });
      } else {
        setState(() {
          _imagenFile = File(resultado.files.single.path!);
        });
      }
    } catch (e) {
      print("Error seleccionando archivo: $e");
    }
  }

  Future<void> _seleccionarImagenWeb() async {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((event) {
          setState(() {
            _imagenBytes = reader.result as Uint8List;
          });
        });
      }
    });
  }

  void _guardarProducto() {
    if (_nombreController.text.isEmpty ||
        _precioController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        (_imagenFile == null && _imagenBytes == null)) {
      _mostrarAlerta("Completa todos los campos e incluye una imagen.");
      return;
    }

    _mostrarAlerta("Producto agregado correctamente.");
    _limpiarCampos();
  }

  void _limpiarCampos() {
    _nombreController.clear();
    _precioController.clear();
    _stockController.clear();
    _descripcionController.clear();
    setState(() {
      _imagenFile = null;
      _imagenBytes = null;
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          // PANEL LATERAL
          Container(
            width: 220,
            height: double.infinity,
            color: Colors.black, // negro sólido
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DrawerHeader(
                  child: Text(
                    "ADMIN PANEL",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.add_box, color: Colors.white),
                  title: Text(
                    "Agregar Producto",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    "Cerrar Sesión",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const InicioWeb()), // al inicio
                    );
                  },
                ),
              ],
            ),
          ),

          // ZONA DE CONTENIDO
          Expanded(
            child: Container(
              color: Colors.white, // fondo blanco
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ENCABEZADO
                  const Text(
                    "Bienvenido",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // FORMULARIO DE PRODUCTO
                  Expanded(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2C2C2C)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFED7C3).withOpacity(0.8),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Agregar nuevo producto",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
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
                                onPressed: () {
                                  if (kIsWeb) {
                                    _seleccionarImagenWeb();
                                  } else {
                                    _seleccionarImagen();
                                  }
                                },
                                icon: const Icon(Icons.image),
                                label: const Text("Seleccionar Imagen"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 12),
                              if (_imagenFile != null)
                                Image.file(_imagenFile!,
                                    height: 150, fit: BoxFit.cover),
                              if (_imagenBytes != null)
                                Image.memory(_imagenBytes!,
                                    height: 150, fit: BoxFit.cover),
                              const SizedBox(height: 24),

                              ElevatedButton(
                                onPressed: _guardarProducto,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  minimumSize:
                                      const Size(double.infinity, 48),
                                ),
                                child: const Text("Guardar Producto"),
                              ),
                            ],
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
    );
  }
}
