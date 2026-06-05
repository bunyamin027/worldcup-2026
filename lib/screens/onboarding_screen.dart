import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _fadeController;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    // Neon pulse loop
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Entrance fade + slide
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CyberColors.background,
      body: Stack(
        children: [
          // ── Background gradients ──────────────────────────────────────
          _buildBackgroundGradients(size),

          // ── Grid overlay ──────────────────────────────────────────────
          CustomPaint(
            size: size,
            painter: _GridPainter(),
          ),

          // ── Content ───────────────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 3),
                      _buildTitle(),
                      const SizedBox(height: 16),
                      _buildSubtitle(),
                      const Spacer(flex: 4),
                      _buildGlassButton(context),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Background Gradient Orbs ────────────────────────────────────────────
  Widget _buildBackgroundGradients(Size size) {
    return Stack(
      children: [
        // Cyan orb – top-left
        Positioned(
          top: -size.height * 0.12,
          left: -size.width * 0.25,
          child: Container(
            width: size.width * 0.8,
            height: size.width * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  CyberColors.neonCyan.withOpacity(0.08),
                  CyberColors.neonCyan.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        // Magenta orb – bottom-right
        Positioned(
          bottom: -size.height * 0.10,
          right: -size.width * 0.20,
          child: Container(
            width: size.width * 0.75,
            height: size.width * 0.75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  CyberColors.neonMagenta.withOpacity(0.07),
                  CyberColors.neonMagenta.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        // Centre subtle mix
        Positioned(
          top: size.height * 0.35,
          left: size.width * 0.15,
          child: Container(
            width: size.width * 0.7,
            height: size.width * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  CyberColors.neonCyan.withOpacity(0.04),
                  CyberColors.neonMagenta.withOpacity(0.03),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Neon Title ──────────────────────────────────────────────────────────
  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        final glowOpacity = _pulseAnim.value;
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: CyberColors.neonCyan.withOpacity(0.35 * glowOpacity),
                blurRadius: 60,
                spreadRadius: 10,
              ),
              BoxShadow(
                color: CyberColors.neonMagenta.withOpacity(0.15 * glowOpacity),
                blurRadius: 90,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Text(
            'WC 2026',
            style: GoogleFonts.orbitron(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              letterSpacing: 8,
              color: CyberColors.textPrimary,
              shadows: [
                Shadow(
                  color: CyberColors.neonCyan.withOpacity(0.9 * glowOpacity),
                  blurRadius: 30,
                ),
                Shadow(
                  color: CyberColors.neonCyan.withOpacity(0.5 * glowOpacity),
                  blurRadius: 60,
                ),
                Shadow(
                  color: CyberColors.neonMagenta.withOpacity(0.3 * glowOpacity),
                  blurRadius: 80,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Subtitle ────────────────────────────────────────────────────────────
  Widget _buildSubtitle() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        return Text(
          'USA  •  CANADA  •  MEXICO',
          style: GoogleFonts.orbitron(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 6,
            color: CyberColors.neonCyan.withOpacity(0.85),
            shadows: [
              Shadow(
                color: CyberColors.neonCyan.withOpacity(0.4 * _pulseAnim.value),
                blurRadius: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Glassmorphism Button ────────────────────────────────────────────────
  Widget _buildGlassButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: CyberColors.neonCyan.withOpacity(0.2 * _pulseAnim.value),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: CyberColors.neonMagenta.withOpacity(0.1 * _pulseAnim.value),
                  blurRadius: 40,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.08),
                    border: Border.all(
                      color: CyberColors.neonCyan.withOpacity(
                        0.25 + 0.15 * _pulseAnim.value,
                      ),
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.12),
                        Colors.white.withOpacity(0.04),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.rocket_launch_rounded,
                        color: CyberColors.neonCyan,
                        size: 20,
                        shadows: [
                          Shadow(
                            color: CyberColors.neonCyan.withOpacity(0.6),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'SİSTEMİ BAŞLAT',
                        style: GoogleFonts.orbitron(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                          color: CyberColors.neonCyan,
                          shadows: [
                            Shadow(
                              color: CyberColors.neonCyan.withOpacity(0.5),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Perspective Grid Painter ────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CyberColors.neonCyan.withOpacity(0.04)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const step = 40.0;

    // Horizontal lines
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Vertical lines
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
