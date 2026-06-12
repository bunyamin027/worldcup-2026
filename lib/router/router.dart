import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../screens/home_screen.dart';
import '../screens/match_detail_screen.dart';
import '../screens/settings_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Route Names
// ─────────────────────────────────────────────────────────────────────────────
abstract class AppRoutes {
  static const String splash  = '/';
  static const String shell   = '/home';
  static const String detail  = '/match-detail';
}

// ─────────────────────────────────────────────────────────────────────────────
// Route Generator – tek giriş noktası
// ─────────────────────────────────────────────────────────────────────────────
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.splash:
      return _fadeRoute(const SplashScreen());

    case AppRoutes.shell:
      return _fadeRoute(const AppShell());

    case AppRoutes.detail:
      final fixtureId = settings.arguments as int?;
      return _slideRoute(MatchDetailScreen(fixtureId: fixtureId));

    default:
      return _fadeRoute(const AppShell());
  }
}

// ─── Transition helpers ───────────────────────────────────────────────────────
PageRouteBuilder _fadeRoute(Widget page) => PageRouteBuilder(
      settings: RouteSettings(name: page.runtimeType.toString()),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 500),
    );

PageRouteBuilder _slideRoute(Widget page) => PageRouteBuilder(
      settings: RouteSettings(name: page.runtimeType.toString()),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 420),
    );

// ─────────────────────────────────────────────────────────────────────────────
// Splash Screen – 3 saniye sonra AppShell'e geçer
// ─────────────────────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final AnimationController _scanCtrl;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _scanAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    // Neon glow pulse
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Scan line sweep
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _scanAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanCtrl, curve: Curves.linear),
    );

    // Fade-out before navigation
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);

    // Auto-navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      await _fadeCtrl.forward();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.shell);
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _scanCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: CyberColors.background,
        body: AnimatedBuilder(
          animation: Listenable.merge([_pulseAnim, _scanAnim, _fadeAnim]),
          builder: (context, _) {
            return FadeTransition(
              opacity: ReverseAnimation(_fadeAnim),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ── Gradient background orbs ─────────────────────────
                  _buildOrbs(size),

                  // ── Perspective grid ─────────────────────────────────
                  CustomPaint(
                    painter: _GridPainter(
                      color: CyberColors.neonCyan.withValues(alpha: 0.04),
                    ),
                  ),

                  // ── Scan line ─────────────────────────────────────────
                  Positioned(
                    top: size.height * _scanAnim.value - 2,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            CyberColors.neonCyan.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Centre content ─────────────────────────────────────
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Neon logo ring
                        _buildLogoRing(),
                        const SizedBox(height: 40),
                        // Title
                        _buildTitle(),
                        const SizedBox(height: 12),
                        // Subtitle
                        _buildSubtitle(),
                        const SizedBox(height: 64),
                        // Loading dots
                        _buildLoadingDots(),
                      ],
                    ),
                  ),

                  // ── Bottom stamp ──────────────────────────────────────
                  Positioned(
                    bottom: 48,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'SİSTEM BAŞLATILIYOR...',
                        style: GoogleFonts.orbitron(
                          fontSize: 9,
                          letterSpacing: 4,
                          color:
                              CyberColors.textSecondary.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrbs(Size size) {
    return Stack(
      children: [
        Positioned(
          top: -size.height * 0.1,
          left: -size.width * 0.2,
          child: Container(
            width: size.width * 0.8,
            height: size.width * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  CyberColors.neonCyan.withValues(alpha: 0.10 * _pulseAnim.value),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -size.height * 0.08,
          right: -size.width * 0.15,
          child: Container(
            width: size.width * 0.7,
            height: size.width * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  CyberColors.neonMagenta.withValues(alpha: 0.08 * _pulseAnim.value),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoRing() {
    final glow = _pulseAnim.value;
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: CyberColors.neonCyan.withValues(alpha: 0.40 * glow),
            blurRadius: 60,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: CyberColors.neonMagenta.withValues(alpha: 0.15 * glow),
            blurRadius: 80,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: CyberColors.neonCyan.withValues(alpha: 0.3 + 0.2 * glow),
                width: 1.5,
              ),
              gradient: RadialGradient(
                colors: [
                  CyberColors.neonCyan.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
            child: Center(
              child: Text(
                '⚽',
                style: TextStyle(
                  fontSize: 52,
                  shadows: [
                    Shadow(
                      color: CyberColors.neonCyan.withValues(alpha: 0.6 * glow),
                      blurRadius: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final glow = _pulseAnim.value;
    return Text(
      'FOOTBALL 2026',
      style: GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        letterSpacing: 6,
        color: CyberColors.textPrimary,
        shadows: [
          Shadow(
            color: CyberColors.neonCyan.withValues(alpha: 0.9 * glow),
            blurRadius: 24,
          ),
          Shadow(
            color: CyberColors.neonCyan.withValues(alpha: 0.4 * glow),
            blurRadius: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'USA  •  CANADA  •  MEXICO',
      style: GoogleFonts.orbitron(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 5,
        color: CyberColors.neonCyan.withValues(alpha: 0.7 * _pulseAnim.value),
      ),
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        // Each dot pulses with a phase offset
        final phase = ((_scanAnim.value * 3) - i).clamp(0.0, 1.0);
        final bounce = (phase < 0.5 ? phase * 2 : (1.0 - phase) * 2);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Transform.translate(
            offset: Offset(0, -8 * bounce),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CyberColors.neonCyan.withValues(alpha: 0.4 + 0.6 * bounce),
                boxShadow: [
                  BoxShadow(
                    color: CyberColors.neonCyan.withValues(alpha: 0.6 * bounce),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppShell – Glassmorphism BottomNavigationBar barındırır
// ─────────────────────────────────────────────────────────────────────────────
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _barGlowCtrl;
  late final Animation<double> _barGlowAnim;

  // Sekme tanımları
  static const _tabs = [
    _TabItem(
      icon: Icons.sports_soccer_rounded,
      label: 'MAÇLAR',
    ),
    _TabItem(
      icon: Icons.settings_rounded,
      label: 'AYARLAR',
    ),
  ];

  // Sayfalar – IndexedStack ile anlık geçiş; state korunur
  static const _pages = <Widget>[
    HomeScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _barGlowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _barGlowAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _barGlowCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _barGlowCtrl.dispose();
    super.dispose();
  }

  void _onTabTap(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      // IndexedStack sayfa state'ini hafızada tutar
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // extendBody, sayfanın BottomBar'ın altına uzanmasını sağlar
      extendBody: true,
      bottomNavigationBar: _GlassBottomNav(
        currentIndex: _currentIndex,
        tabs: _tabs,
        glowAnim: _barGlowAnim,
        onTap: _onTabTap,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Glassmorphism BottomNavigationBar
// ─────────────────────────────────────────────────────────────────────────────
class _GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<_TabItem> tabs;
  final Animation<double> glowAnim;
  final ValueChanged<int> onTap;

  const _GlassBottomNav({
    required this.currentIndex,
    required this.tabs,
    required this.glowAnim,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return AnimatedBuilder(
      animation: glowAnim,
      builder: (context, _) {
        final glow = glowAnim.value;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: CyberColors.neonCyan.withValues(alpha: 0.12 * glow),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, -4),
              ),
              BoxShadow(
                color: CyberColors.neonMagenta.withValues(alpha: 0.06 * glow),
                blurRadius: 40,
                offset: const Offset(0, -2),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: bottomPadding > 0 ? bottomPadding : 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Colors.white.withValues(alpha: 0.06),
                  border: Border.all(
                    color: CyberColors.neonCyan.withValues(
                      alpha: 0.12 + 0.08 * glow,
                    ),
                    width: 1,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.10),
                      Colors.white.withValues(alpha: 0.04),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: tabs.asMap().entries.map((e) {
                    return _NavBarItem(
                      tab: e.value,
                      isSelected: currentIndex == e.key,
                      glowValue: glow,
                      onTap: () => onTap(e.key),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Single nav item ──────────────────────────────────────────────────────────
class _NavBarItem extends StatelessWidget {
  final _TabItem tab;
  final bool isSelected;
  final double glowValue;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.tab,
    required this.isSelected,
    required this.glowValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = CyberColors.neonCyan;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? accent.withValues(alpha: 0.10)
              : Colors.transparent,
          border: isSelected
              ? Border.all(
                  color: accent.withValues(alpha: 0.25 + 0.15 * glowValue),
                  width: 1,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.20 * glowValue),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Icon(
              tab.icon,
              size: 22,
              color: isSelected
                  ? accent
                  : CyberColors.textSecondary.withValues(alpha: 0.5),
              shadows: isSelected
                  ? [
                      Shadow(
                        color: accent.withValues(alpha: 0.7 * glowValue),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
            const SizedBox(height: 4),
            // Label
            Text(
              tab.label,
              style: GoogleFonts.orbitron(
                fontSize: 8,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                letterSpacing: 1.5,
                color: isSelected
                    ? accent
                    : CyberColors.textSecondary.withValues(alpha: 0.5),
                shadows: isSelected
                    ? [
                        Shadow(
                          color: accent.withValues(alpha: 0.5 * glowValue),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab item data class
// ─────────────────────────────────────────────────────────────────────────────
class _TabItem {
  final IconData icon;
  final String label;
  const _TabItem({required this.icon, required this.label});
}

// ─────────────────────────────────────────────────────────────────────────────
// Perspective grid painter (shared)
// ─────────────────────────────────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  final Color color;
  const _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const step = 40.0;
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => old.color != color;
}

// ─────────────────────────────────────────────────────────────────────────────
// Navigation helper – MatchDetailScreen'e argümanlı geçiş
// ─────────────────────────────────────────────────────────────────────────────
extension AppNavigation on BuildContext {
  /// Maç detayına git (fixtureId zorunlu)
  Future<T?> goToMatchDetail<T>(int fixtureId) {
    return Navigator.of(this).pushNamed(
      AppRoutes.detail,
      arguments: fixtureId,
    );
  }
}
