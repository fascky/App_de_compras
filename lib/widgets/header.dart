// lib/widgets/header_web.dart
import 'dart:ui' as ui;
import 'package:app_de_compras/inicio.dart';
import 'package:app_de_compras/login.dart';
import 'package:app_de_compras/carrito_compras.dart';
import 'package:flutter/material.dart';

/// HEADER “PREMIUM GLASS” — Solo UI/animaciones. Sin routers, sin providers.
/// Nota: Ajusta la clase `Inicio` y su import según tu proyecto.
class HeaderWeb extends StatelessWidget implements PreferredSizeWidget {
  const HeaderWeb({super.key});

  // ======= LOOK & FEEL =======
  static const _navHeight = 78.0;
  static const _radius = 22.0;

  // Colores base (tono verde profundo con acentos fríos)
  static const _brand = Color(0xFF0A9E40);
  static const _bgA = Color(0xFF102E2B);
  static const _bgB = Color(0xFF0C3C38);
  static const _edgeA = Color(0xFF7CF0C5);
  static const _edgeB = Color(0xFF1FB66A);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final bool isMobile = w < 960;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: _navHeight,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: isMobile
          ? Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
          : null,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 24,
          vertical: 10,
        ),
        child: Stack(
          children: [
            // NAV PILL (sólo desktop/tablet)
            if (!isMobile)
              _PremiumPill(
                height: _navHeight - 14,
                radius: _radius,
                bgA: _bgA,
                bgB: _bgB,
                edgeA: _edgeA,
                edgeB: _edgeB,
                child: Row(
                  children: [
                    // LOGO (redirige a inicio.dart)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InicioWeb(), // <-- AJUSTA ESTO
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                    ),
                    const Spacer(), // Expande el espacio para empujar los íconos a la derecha
                    // ACTIONS (login y carrito)
                    Row(
                      children: [
                        _GlassIcon(
                          tooltip: 'Iniciar sesión',
                          icon: Icons.person_outline,
                          onTap: () {
                            // Redireccionamiento a la vista de login
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginWeb()),
                            );
                          },
                        ),
                        SizedBox(width: 8),
                        _GlassIcon(
                          tooltip: 'Carrito de compras',
                          icon: Icons.shopping_cart_outlined,
                          onTap: () {
                            // Redireccionamiento a la vista de carrito
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CarritoCompras()),
                            );
                          },
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),

            // MOBILE: logo centrado sencillo (redirige a inicio.dart)
            if (isMobile)
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InicioWeb(), // <-- AJUSTA ESTO
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_navHeight);
}

// ----------------------------------------------------
// Widgets auxiliares para construir el HeaderWeb
// ----------------------------------------------------

/// PASTILLA GLASS con borde degradado, auroras y brillo superior.
class _PremiumPill extends StatefulWidget {
  final double height;
  final double radius;
  final Color bgA, bgB, edgeA, edgeB;
  final Widget child;
  const _PremiumPill({
    required this.height,
    required this.radius,
    required this.bgA,
    required this.bgB,
    required this.edgeA,
    required this.edgeB,
    required this.child,
  });

  @override
  State<_PremiumPill> createState() => _PremiumPillState();
}

class _PremiumPillState extends State<_PremiumPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius * 1.6),
      child: Stack(
        children: [
          // Desenfoque de fondo
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: const SizedBox(),
          ),
          // Fondo degradado
          Container(
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.bgA, widget.bgB],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(widget.radius * 1.6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  blurRadius: 26,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: _HeaderGlow.glow.withOpacity(0.25),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          // Borde degradado exterior (marco premium)
          Padding(
            padding: const EdgeInsets.all(1.2),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius * 1.6),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
            ),
          ),
          // Efecto aurora animada
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              final t = _ctrl.value;
              return IgnorePointer(
                child: CustomPaint(
                  painter: _AuroraPainter(progress: t),
                  size: Size(double.infinity, widget.height),
                ),
              );
            },
          ),
          // Highlight superior (gloss)
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: widget.height * .45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.18),
                    Colors.white.withOpacity(0.02),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Contenido
          Container(
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

/// Botón redondo con efecto glass — sólo UI si onTap es null.
class _GlassIcon extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  const _GlassIcon({
    required this.icon,
    required this.tooltip,
    this.onTap,
  });
  @override
  State<_GlassIcon> createState() => _GlassIconState();
}

class _GlassIconState extends State<_GlassIcon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap, // puede ser null
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hover
                  ? Colors.white.withOpacity(.18)
                  : Colors.white.withOpacity(.12),
              border: Border.all(color: Colors.white.withOpacity(.18)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
                if (_hover)
                  BoxShadow(
                    color: HeaderWeb._brand.withOpacity(.35),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: Icon(widget.icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

/// Aurora Painter — manchas de color suaves que se desplazan muy sutil.
class _AuroraPainter extends CustomPainter {
  final double progress;
  _AuroraPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..blendMode = BlendMode.plus;

    // Blob 1 (verde)
    final c1 = Offset(size.width * (.2 + .15 * progress), size.height * .6);
    p.shader = ui.Gradient.radial(c1, size.height * .55, [
      const Color(0xFF21E28D).withOpacity(.12),
      const Color(0xFF21E28D).withOpacity(0),
    ]);
    canvas.drawCircle(c1, size.height * .55, p);

    // Blob 2 (turquesa)
    final c2 = Offset(size.width * (.7 - .2 * progress), size.height * .4);
    p.shader = ui.Gradient.radial(c2, size.height * .50, [
      const Color(0xFF66F9E3).withOpacity(.10),
      const Color(0xFF66F9E3).withOpacity(0),
    ]);
    canvas.drawCircle(c2, size.height * .50, p);
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Glow de marca reutilizable
class _HeaderGlow {
  static const glow = HeaderWeb._brand;
}
