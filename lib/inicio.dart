// lib/pagina_principal.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_de_compras/widgets/header.dart';

class InicioWeb extends StatelessWidget {
  const InicioWeb({super.key});

  static const String appNombre = 'App de Compras';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWeb(),
      backgroundColor: const Color(0xFFF7F8FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: const [
            _HeroSection(),
            SizedBox(height: 28),
            _SectionTitle(title: 'Destacados'),
            SizedBox(height: 12),
            _ProductsRow(),
            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

/* ===========================
 * HERO / BANNER SUPERIOR
 * =========================== */
class _HeroSection extends StatefulWidget {
  const _HeroSection();

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with SingleTickerProviderStateMixin {
  late final PageController _page;
  late final AnimationController _bgCtrl;
  late final CurvedAnimation _bgCurve;
  Timer? _autoplay;

  int _index = 0;

  final _slides = const [
    _Slide(
      title: 'Ofertas de temporada',
      subtitle: 'Aprovecha descuentos y entrega rápida en tu ciudad.',
      colors: [Color(0xFFFFE5B8), Color(0xFFFDF5E6)],
      cta: 'Explorar',
    ),
    _Slide(
      title: 'Equipos & Accesorios',
      subtitle: 'Encuentra lo nuevo en tecnología y estilos.',
      colors: [Color(0xFFBDE8F5), Color(0xFFEAF7FD)],
      cta: 'Descubrir',
    ),
    _Slide(
      title: 'Ropa & Calzado',
      subtitle: 'Looks frescos, precios justos, calidad premium.',
      colors: [Color(0xFFF1DDF7), Color(0xFFFBF1FD)],
      cta: 'Ver más',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _page = PageController();
    _bgCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat(reverse: true);
    _bgCurve = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    _startAutoplay();
  }

  void _startAutoplay() {
    _autoplay?.cancel();
    _autoplay = Timer.periodic(const Duration(seconds: 6), (_) {
      final next = (_index + 1) % _slides.length;
      _goTo(next);
    });
  }

  void _goTo(int i) {
    _page.animateToPage(
      i,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _autoplay?.cancel();
    _page.dispose();
    _bgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 980;
    final double bannerHeight = isWide ? 360.0 : 520.0;

    return FocusableActionDetector(
      autofocus: true,
      shortcuts: const <LogicalKeySet, Intent>{},
      actions: <Type, Action<Intent>>{},
      child: _FadeSlideIn(
        delay: const Duration(milliseconds: 80),
        child: LayoutBuilder(
          builder: (context, c) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner con gradiente animado
                AnimatedBuilder(
                  animation: _bgCurve,
                  builder: (_, __) {
                    final t = _bgCurve.value; // 0..1
                    final begin = Alignment(-1 + t * 2, 0);
                    final end = Alignment(1 - t * 2, 0);

                    return Container(
                      height: bannerHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: LinearGradient(
                          begin: begin,
                          end: end,
                          colors: _slides[_index].colors,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 28,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: PageView.builder(
                          controller: _page,
                          onPageChanged: (i) => setState(() => _index = i),
                          itemCount: _slides.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (_, i) {
                            final slide = _slides[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
                              child: isWide
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: _HeroText(slide: slide),
                                        ),
                                        const SizedBox(width: 24),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: _BlobAccent(t: t),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        const SizedBox(height: 18),
                                        _HeroText(slide: slide),
                                        const SizedBox(height: 22),
                                        SizedBox(height: 160, child: _BlobAccent(t: t)),
                                      ],
                                    ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

                // Indicadores
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -14,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_slides.length, (i) {
                          final active = i == _index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: active ? 24 : 10,
                            decoration: BoxDecoration(
                              color: active ? const Color(0xFF3B82F6) : const Color(0xFFD0D8E5),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Slide {
  final String title;
  final String subtitle;
  final List<Color> colors;
  final String cta;
  const _Slide({
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.cta,
  });
}

class _HeroText extends StatelessWidget {
  final _Slide slide;
  const _HeroText({required this.slide});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 980;
    return Column(
      crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          slide.title,
          textAlign: isWide ? TextAlign.left : TextAlign.center,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            height: 1.15,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          slide.subtitle,
          textAlign: isWide ? TextAlign.left : TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            height: 1.45,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 18),
        _CtaButton(text: slide.cta),
      ],
    );
  }
}

class _BlobAccent extends StatelessWidget {
  final double t; // 0..1
  const _BlobAccent({required this.t});

  @override
  Widget build(BuildContext context) {
    // “Blob” sutil como elemento decorativo
    return AnimatedScale(
      scale: 0.98 + (t * 0.04),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      child: Container(
        width: 280,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0x33FFFFFF)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===========================
 * TÍTULO DE SECCIÓN
 * =========================== */
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return _FadeSlideIn(
      delay: const Duration(milliseconds: 40),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Ver todo',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}

/* ===========================
 * FILA DE PRODUCTOS (SIN IMÁGENES)
 * =========================== */

class _ProductsRow extends StatelessWidget {
  const _ProductsRow();

  @override
  Widget build(BuildContext context) {
    final items = <_Product>[
      const _Product(
        name: 'Nike Air',
        price: 186.0,
        oldPrice: 289.0,
        tag: null,
        bg: Color(0xFFB7F1C9),
        colors: [0xFF222222, 0xFF8BC34A, 0xFF795548, 0xFF607D8B],
      ),
      const _Product(
        name: 'Air Jordan',
        price: 199.0,
        oldPrice: 289.0,
        tag: 'NEW',
        bg: Color(0xFFF1DDF7),
        colors: [0xFF222222, 0xFF9C27B0, 0xFFE91E63, 0xFFBDBDBD],
      ),
      const _Product(
        name: 'Nike Netro',
        price: 135.0,
        oldPrice: 289.0,
        tag: 'NEW · HOT',
        bg: Color(0xFFFED7C3),
        colors: [0xFF009688, 0xFF4CAF50, 0xFF795548, 0xFFBDBDBD],
      ),
      const _Product(
        name: 'Air Spain',
        price: 149.0,
        oldPrice: 199.0,
        tag: '-15%',
        bg: Color(0xFFBDE8F5),
        colors: [0xFF3F51B5, 0xFFF44336, 0xFFFFC107, 0xFF4CAF50],
      ),
    ];

    final isWide = MediaQuery.sizeOf(context).width >= 1100;

    return LayoutBuilder(
      builder: (_, c) {
        const spacing = 18.0;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (int i = 0; i < items.length; i++)
              SizedBox(
                width: isWide ? (c.maxWidth - spacing * 3) / 4 : 360,
                child: _FadeSlideIn(
                  delay: Duration(milliseconds: 80 + (i * 90)),
                  child: _ProductCard(p: items[i]),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Product {
  final String name;
  final double price;
  final double oldPrice;
  final String? tag;
  final Color bg;
  final List<int> colors;
  const _Product({
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.tag,
    required this.bg,
    required this.colors,
  });
}

class _ProductCard extends StatefulWidget {
  final _Product p;
  const _ProductCard({required this.p});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    final radius = BorderRadius.circular(22);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()..scale(_hover ? 1.015 : 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: const Color(0x14000000),
              blurRadius: _hover ? 22 : 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Zona superior SIN imagen
            Container(
              height: 130,
              margin: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: p.bg,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Stack(
                children: [
                  if (p.tag != null)
                    Positioned(
                      left: 12,
                      top: 12,
                      child: _Badge(text: p.tag!),
                    ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('\$${p.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        '\$${p.oldPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Spacer(),
                      const _SmallLabel('Colors'),
                      const SizedBox(width: 8),
                      for (final c in p.colors.take(4)) ...[
                        _ColorDot(Color(c)),
                        const SizedBox(width: 6),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _OutlinedIconButton(
                    icon: Icons.favorite_border,
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFFF1F5F9),
                        foregroundColor: const Color(0xFF0F172A),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Add to cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===========================
 * UI ELEMENTOS
 * =========================== */

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }
}

class _SmallLabel extends StatelessWidget {
  final String text;
  const _SmallLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3B82F6),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  const _ColorDot(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

class _OutlinedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _OutlinedIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Icon(icon, size: 20, color: const Color(0xFF0F172A)),
    );
  }
}

/* ===========================
 * HELPERS DE ANIMACIÓN
 * =========================== */

class _CtaButton extends StatefulWidget {
  final String text;
  const _CtaButton({required this.text});

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: _hover ? 1.03 : 1.0,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFF0EA5E9),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(
            widget.text,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const _FadeSlideIn({required this.child, this.delay = Duration.zero});

  @override
  State<_FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<_FadeSlideIn> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _show = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      offset: _show ? Offset.zero : const Offset(0, 0.06),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        opacity: _show ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}