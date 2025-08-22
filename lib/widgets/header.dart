// lib/widgets/header_web.dart
import 'dart:ui' as ui;
import 'package:app_de_compras/carrito_compras.dart';
import 'package:app_de_compras/inicio.dart';
import 'package:flutter/material.dart';
import 'package:app_de_compras/login.dart'; // Import agregado

/// HEADER “PREMIUM GLASS” — Solo UI/animaciones. Sin routers, sin providers.
/// Nota: Ajusta la clase `Inicio` y su import según tu proyecto.
class HeaderWeb extends StatelessWidget implements PreferredSizeWidget {
  const HeaderWeb({super.key});

  // ======= LOOK & FEEL =======
  static const _navHeight = 78.0;
  static const _radius = 22.0;

  // Colores base (degradado turquesa a amarillo pálido)
  static const _brand = Color(0xFF119DA4);
  static const _bgA = Color(0xFF119DA4);
  static const _bgB = Color(0xFFFDE789);
  static const _edgeA = Color(0xFFD3FFEB);
  static const _edgeB = Color(0xFFB1E8B8);
  static const _contentColor = Colors.white;

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
                icon: const Icon(Icons.menu, color: _contentColor),
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
                        // Navegar a la pantalla de inicio
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
                    const _SoftDivider(),
                    // NAV CENTER
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _NavChip(label: 'CALZADO', active: false, onTap: null),
                          SizedBox(width: 8),
                          _NavChip(label: 'MUJER', active: false, onTap: null),
                          SizedBox(width: 8),
                          _NavChip(label: 'HOMBRE', active: false, onTap: null),
                          SizedBox(width: 8),
                          _NavChip(label: 'NIÑOS', active: false, onTap: null),
                          SizedBox(width: 8),
                          _NavChip(label: 'DEPORTE', active: false, onTap: null),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                    const _SoftDivider(),
                    // ACTIONS (sólo UI)
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

class _SoftDivider extends StatelessWidget {
  const _SoftDivider();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.12),
        boxShadow: [
          BoxShadow(color: Colors.white.withOpacity(0.10), blurRadius: 10),
        ],
      ),
    );
  }
}

/// CHIP de navegación con indicador animado “underline” y micro-hover.
/// onTap es opcional (null = sólo UI).
class _NavChip extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;
  final Color? customColor;
  const _NavChip({
    required this.label,
    required this.active,
    this.onTap,
    this.customColor,
  });
  @override
  State<_NavChip> createState() => _NavChipState();
}

class _NavChipState extends State<_NavChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    final textColor = widget.customColor ?? (active ? HeaderWeb._brand : Colors.white.withOpacity(.95));

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap, // puede ser null (solo UI)
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: active
                ? Colors.white.withOpacity(0.10)
                : (_hover
                    ? Colors.white.withOpacity(0.06)
                    : Colors.transparent),
            border: Border.all(
              color: active
                  ? Colors.white.withOpacity(0.22)
                  : Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'AeroMatics',
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                  fontSize: 13.6,
                  color: textColor,
                ),
              ),
              // Underline glow animado
              Positioned(
                left: -2,
                right: -2,
                bottom: -9,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 160),
                  opacity: active || _hover ? 1 : 0,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: LinearGradient(
                        colors: [
                          HeaderWeb._brand.withOpacity(.0),
                          HeaderWeb._brand,
                          HeaderWeb._brand.withOpacity(.0),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: HeaderWeb._brand.withOpacity(.45),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip SERVICIOS (Popup) — solo UI (sin navegación real)
class _ServiciosChip extends StatelessWidget {
  const _ServiciosChip();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Servicios',
      color: const Color(0xFF0F2C29),
      elevation: 10,
      offset: const Offset(0, 42),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'Escolar',
          child: const Text(
            'Escolar',
            style: TextStyle(
              fontFamily: 'AeroMatics',
              fontWeight: FontWeight.w800,
            ),
          ),
          onTap: () {}, // solo UI
        ),
        PopupMenuItem(
          value: 'Pre Uni',
          child: const Text(
            'Pre Uni',
            style: TextStyle(
              fontFamily: 'AeroMatics',
              fontWeight: FontWeight.w800,
            ),
          ),
          onTap: () {}, // solo UI
        ),
      ],
      child: Row(
        children: const [
          _NavChip(label: 'SERVICIOS', active: false),
          SizedBox(width: 2),
          Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}

/// Chip ELITE que redirige a inicio.dart (ajusta clase/import).
class _EliteHomeChip extends StatelessWidget {
  const _EliteHomeChip();

  @override
  Widget build(BuildContext context) {
    return _NavChip(
      label: 'ELITE',
      active: false,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const InicioWeb(), // <-- AJUSTA ESTO
          ),
        );
      },
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

    // Blob 1 (turquesa)
    final c1 = Offset(size.width * (.2 + .15 * progress), size.height * .6);
    p.shader = ui.Gradient.radial(c1, size.height * .55, [
      const Color(0xFF119DA4).withOpacity(.12),
      const Color(0xFF119DA4).withOpacity(0),
    ]);
    canvas.drawCircle(c1, size.height * .55, p);

    // Blob 2 (amarillo)
    final c2 = Offset(size.width * (.7 - .2 * progress), size.height * .4);
    p.shader = ui.Gradient.radial(c2, size.height * .50, [
      const Color(0xFFFDE789).withOpacity(.10),
      const Color(0xFFFDE789).withOpacity(0),
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
