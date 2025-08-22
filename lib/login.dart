import 'package:app_de_compras/dash_admin.dart';
import 'package:flutter/material.dart';
import 'inicio.dart';
import 'registro.dart';


class LoginWeb extends StatefulWidget {
  const LoginWeb({super.key});

  @override
  State<LoginWeb> createState() => _LoginWebState();
}

class _LoginWebState extends State<LoginWeb> {
  static const String titulo = 'Iniciar Sesión';
  static const TextStyle estiloTitulo = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
  static const TextStyle estiloTexto = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  final _correoController = TextEditingController();
  final _claveController = TextEditingController();

  void _ingresar() {
    final correo = _correoController.text.trim();
    final clave = _claveController.text;

    if (correo.isEmpty || clave.isEmpty) {
      _mostrarAlerta('Por favor, completa todos los campos.');
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashAdmin()),
      );
    }
  }

  void _mostrarAlerta(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('⚠ Atención'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _irARegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegistroPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFED7C3), // beige suave
              Color(0xFFF5F5F5), // gris muy claro
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(36), // más espacioso
              margin: const EdgeInsets.all(20),
              constraints: const BoxConstraints(maxWidth: 500), // más ancho
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    titulo,
                    style: estiloTitulo,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      labelStyle: const TextStyle(color: Colors.black54),
                      filled: true,
                      fillColor: const Color(0xFFF8F1EC), // beige clarito
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.email, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: _claveController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(color: Colors.black54),
                      filled: true,
                      fillColor: const Color(0xFFF8F1EC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _ingresar,
                    icon: const Icon(Icons.login),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor:
                          const Color.fromARGB(255, 245, 170, 146), // marrón elegante
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                    ),
                    label: const Text(
                      'Ingresar',
                      style: estiloTexto,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: _irARegistro,
                    child: const Text(
                      '¿No tienes cuenta? Regístrate aquí',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6D4C41),
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
