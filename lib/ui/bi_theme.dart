import 'dart:ui';
import 'package:flutter/material.dart';

/// Identitas visual Bitaqwa 2.0: emerald, sage, ivory, dan warm ink.
/// Semua halaman memakai komponen di sini agar margin, bentuk, dan warna konsisten.
class BiColors {
  static const forest = Color(0xFF126454);
  static const emerald = Color(0xFF19816A);
  static const deep = Color(0xFF193E37);
  static const cream = Color(0xFFF5F8F4);
  static const mint = Color(0xFFE3F2E9);
  static const sage = Color(0xFFADCDBD);
  static const muted = Color(0xFF70877C);
  static const line = Color(0xFFDCEAE1);
  static const porcelain = Color(0xFFFBFDFB);
}

class BiBackground extends StatelessWidget {
  final Widget child;
  const BiBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF9FBF8), Color(0xFFEAF3EC), Color(0xFFF7F9F3)],
          ),
        ),
        child: Stack(children: [
          Positioned(
            top: -100,
            right: -85,
            child: _Blob(size: 250, color: BiColors.sage.withValues(alpha: .22)),
          ),
          Positioned(
            top: 390,
            left: -125,
            child: _Blob(size: 255, color: BiColors.emerald.withValues(alpha: .06)),
          ),
          Positioned.fill(child: child),
        ]),
      );
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      );
}

/// Kartu lembut bernuansa kaca; bayangan diletakkan di luar ClipRRect supaya
/// tidak terpotong. Tetap memiliki feedback sentuhan Material.
class BiGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? radius;
  final VoidCallback? onTap;
  final Color tint;
  const BiGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius,
    this.onTap,
    this.tint = const Color(0xE9FFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    final r = radius ?? BorderRadius.circular(22);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: r,
        boxShadow: [
          BoxShadow(
            color: BiColors.forest.withValues(alpha: .045),
            blurRadius: 22,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: r,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: tint,
                borderRadius: r,
                border: Border.all(color: Colors.white.withValues(alpha: .9)),
              ),
              child: InkWell(
                borderRadius: r,
                onTap: onTap,
                child: Padding(padding: padding, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BiPageHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  const BiPageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 23, 22, 23),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF238B73), BiColors.forest, Color(0xFF104E42)],
          ),
          boxShadow: [
            BoxShadow(
              color: BiColors.forest.withValues(alpha: .14),
              blurRadius: 22,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Stack(children: [
          Positioned(
            right: -7,
            top: -22,
            child: Icon(icon, size: 115,
                color: Colors.white.withValues(alpha: .075)),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 17, height: 2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8F3E6),
                    borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Flexible(child: Text(
                eyebrow.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFDAF2E5),
                  fontSize: 10,
                  letterSpacing: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              )),
            ]),
            const SizedBox(height: 13),
            if (title.contains('\n'))
              Text(title, style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w800,
                height: 1.28,
              ))
            else
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(title, maxLines: 1, style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  height: 1.28,
                )),
              ),
            const SizedBox(height: 9),
            Text(subtitle, style: const TextStyle(
              color: Color(0xFFE0F2E9),
              fontSize: 12,
              height: 1.55,
            )),
          ]),
        ]),
      );
}

/// Konten sengaja dibatasi lebarnya pada tablet/desktop agar tidak melebar.
class BiScreen extends StatelessWidget {
  final String title;
  final Widget child;
  const BiScreen({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: BiColors.cream,
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(title, style: const TextStyle(
            color: BiColors.deep, fontSize: 17, fontWeight: FontWeight.w800,
          )),
          leading: IconButton(
            tooltip: 'Kembali',
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.maybePop(context),
          ),
          backgroundColor: BiColors.cream,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: BiColors.deep,
        ),
        body: BiBackground(
          child: SafeArea(
            top: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: child,
              ),
            ),
          ),
        ),
      );
}

class BiSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const BiSectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(
            fontSize: 18, color: BiColors.deep, fontWeight: FontWeight.w800,
            height: 1.25,
          )),
          if (subtitle != null) ...[
            const SizedBox(height: 5),
            Text(subtitle!, style: const TextStyle(
              color: BiColors.muted, fontSize: 11.5, height: 1.5,
            )),
          ],
        ],
      );
}

class BiEyebrow extends StatelessWidget {
  final String text;
  const BiEyebrow(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
        style: const TextStyle(
          color: BiColors.forest, fontSize: 10,
          fontWeight: FontWeight.w800, letterSpacing: 1.4,
        ));
}
