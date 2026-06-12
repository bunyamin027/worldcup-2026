import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/static_fixtures.dart';

// ─── Sabitler ────────────────────────────────────────────────────────────────
const int _globalLeague = 1; // Global Football 2026 league ID
const int _globalSeason = 2026;

// ─────────────────────────────────────────────────────────────────────────────
// 1. ApiService Provider
// ─────────────────────────────────────────────────────────────────────────────
final apiServiceProvider = Provider<ApiService>((_) => ApiService());

// ─────────────────────────────────────────────────────────────────────────────
// 2. Günün Maçları Provider
//    Bugünün tarihini otomatik alır; yalnızca WC maçlarını getirir.
// ─────────────────────────────────────────────────────────────────────────────
final todayFixturesProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  DateTime targetDate = DateTime.now();
  // Turnuva dışında isek, örnek olması için ilk günü göster
  if (targetDate.isBefore(DateTime(2026, 6, 11)) || targetDate.isAfter(DateTime(2026, 7, 20))) {
    targetDate = DateTime(2026, 6, 11);
  }
  final dateString = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';

  final todayMatches = globalFootballStaticFixtures.where((match) {
    return match['utcDate'].toString().startsWith(dateString);
  }).toList();

  final List<dynamic> mappedMatches = todayMatches.asMap().entries.map((entry) {
    int idx = entry.key;
    var match = entry.value;
    return {
      'fixture': {
        'id': idx + 100, // mock id
        'date': match['utcDate'],
        'status': {'short': 'NS', 'elapsed': null}
      },
      'teams': {
        'home': {
          'id': idx * 2 + 1000, 
          'name': match['homeTeam']['name'], 
          // Match the team logos loosely or keep placeholder
          'logo': ''
        },
        'away': {
          'id': idx * 2 + 1001, 
          'name': match['awayTeam']['name'], 
          'logo': ''
        }
      },
      'goals': {'home': null, 'away': null}
    };
  }).toList();

  return {'response': mappedMatches};
});

// Canlı maçlar (opsiyonel – dashboard'da rozet için kullanılabilir)
final liveFixturesProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getLiveFixtures();
});

// ─────────────────────────────────────────────────────────────────────────────
// 3. Puan Durumu Provider
// ─────────────────────────────────────────────────────────────────────────────


// ─────────────────────────────────────────────────────────────────────────────
// 4. Seçili Maç Detayı Providers
// ─────────────────────────────────────────────────────────────────────────────
final selectedFixtureIdProvider = StateProvider<int?>((ref) => null);

/// Maç genel bilgisi (Scoreboard vb.)
final fixtureDetailProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, fixtureId) async {
  final api = ref.watch(apiServiceProvider);
  return api.getFixtureById(id: fixtureId);
});

/// Maç olayları (goller, kartlar…)
final fixtureEventsProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, fixtureId) async {
  final api = ref.watch(apiServiceProvider);
  return api.getFixtureEvents(fixtureId: fixtureId);
});

/// Kadrolar (11'ler)
final fixtureLineupsProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, fixtureId) async {
  final api = ref.watch(apiServiceProvider);
  return api.getLineups(fixtureId: fixtureId);
});

/// İstatistikler (top istatistikleri, pas yüzdeleri…)
final fixtureStatsProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, fixtureId) async {
  final api = ref.watch(apiServiceProvider);
  return api.getFixtureStats(fixtureId: fixtureId);
});

// ─────────────────────────────────────────────────────────────────────────────
// 5. Ek Providers
// ─────────────────────────────────────────────────────────────────────────────

/// Gol Krallığı
final topScorersProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getTopScorers(league: _globalLeague, season: _globalSeason);
});

/// Takım bilgisi – parametre ile
final teamInfoProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>, int>(
  (ref, teamId) async {
    final api = ref.watch(apiServiceProvider);
    return api.getTeamInfo(teamId: teamId);
  },
);

// ─────────────────────────────────────────────────────────────────────────────
// 6. UI Helper: AsyncValue'yu sarmalayan widget builder
//    Kullanım:
//      ref.watch(todayFixturesProvider).buildWidget(
//        data: (data) => MyWidget(data),
//      )
// ─────────────────────────────────────────────────────────────────────────────
extension AsyncValueX<T> on AsyncValue<T> {
  /// Loading ve Error durumlarını otomatik yönetir; data için builder çağırır.
  Widget buildWidget({
    required Widget Function(T data) data,
    Widget Function(Object error, StackTrace? st)? error,
    Widget? loading,
    String? loadingLabel,
    String? errorPrefix,
  }) {
    return when(
      loading: () => loading ?? NeonLoadingIndicator(label: loadingLabel),
      error: (e, st) =>
          error?.call(e, st) ??
          NeonErrorWidget(
            message: e is ApiException ? e.message : e.toString(),
            prefix: errorPrefix,
          ),
      data: data,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. Neon Siber-Uzay Yükleme İndikatörü
// ─────────────────────────────────────────────────────────────────────────────
class NeonLoadingIndicator extends StatefulWidget {
  final String? label;
  final double size;
  final Color primaryColor;
  final Color secondaryColor;

  const NeonLoadingIndicator({
    super.key,
    this.label,
    this.size = 64,
    this.primaryColor = const Color(0xFF00FFD1),  // cyan neon
    this.secondaryColor = const Color(0xFF7B2FFF), // violet
  });

  @override
  State<NeonLoadingIndicator> createState() => _NeonLoadingIndicatorState();
}

class _NeonLoadingIndicatorState extends State<NeonLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotateCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_rotateCtrl, _pulseAnim]),
            builder: (_, __) {
              return Transform.scale(
                scale: _pulseAnim.value,
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: CustomPaint(
                    painter: _NeonRingPainter(
                      progress: _rotateCtrl.value,
                      primaryColor: widget.primaryColor,
                      secondaryColor: widget.secondaryColor,
                    ),
                    child: Center(
                      child: Container(
                        width: widget.size * 0.3,
                        height: widget.size * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.primaryColor.withValues(alpha: 0.15),
                          boxShadow: [
                            BoxShadow(
                              color: widget.primaryColor.withValues(alpha: 0.6),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (widget.label != null) ...[
            const SizedBox(height: 16),
            _GlitchText(text: widget.label!),
          ],
        ],
      ),
    );
  }
}

/// Özel neon halka painter
class _NeonRingPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  _NeonRingPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 4;

    // Arka halka (soluk)
    final trackPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.1)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // Neon ark – döner
    final arcPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          primaryColor.withValues(alpha: 0.0),
          primaryColor,
          secondaryColor,
        ],
        stops: const [0.0, 0.6, 1.0],
        transform: GradientRotation(2 * math.pi * progress),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2 * math.pi * progress,
      1.8, // ~103° ark
      false,
      arcPaint,
    );

    // Parlayan baş noktası
    final headAngle = 2 * math.pi * progress + 1.8;
    final headX = center.dx + radius * math.cos(headAngle);
    final headY = center.dy + radius * math.sin(headAngle);
    final glowPaint = Paint()
      ..color = primaryColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(headX, headY), 4, glowPaint);
  }

  @override
  bool shouldRepaint(_NeonRingPainter old) => old.progress != progress;
}

/// Titreyen glitch metin animasyonu
class _GlitchText extends StatefulWidget {
  final String text;
  const _GlitchText({required this.text});

  @override
  State<_GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<_GlitchText>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _offset = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (_, __) {
        return Stack(
          children: [
            // Kırmızı glitch katmanı
            Transform.translate(
              offset: Offset(_offset.value, 0),
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Color(0x66FF4040),
                  fontSize: 12,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
            ),
            // Mavi glitch katmanı
            Transform.translate(
              offset: Offset(-_offset.value * 0.5, 0),
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Color(0x664040FF),
                  fontSize: 12,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
            ),
            // Ana metin
            Text(
              widget.text,
              style: const TextStyle(
                color: Color(0xFF00FFD1),
                fontSize: 12,
                fontFamily: 'monospace',
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Color(0xFF00FFD1),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 8. Neon Hata Widget'ı
// ─────────────────────────────────────────────────────────────────────────────
class NeonErrorWidget extends StatelessWidget {
  final String message;
  final String? prefix;
  final VoidCallback? onRetry;

  const NeonErrorWidget({
    super.key,
    required this.message,
    this.prefix,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFF2D55).withValues(alpha: 0.6),
            width: 1.5,
          ),
          gradient: RadialGradient(
            colors: [
              const Color(0xFFFF2D55).withValues(alpha: 0.12),
              Colors.transparent,
            ],
            radius: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF2D55).withValues(alpha: 0.25),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hata ikonu – neon kırmızı
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF2D55).withValues(alpha: 0.15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF2D55).withValues(alpha: 0.5),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFFF2D55),
                size: 28,
              ),
            ),
            const SizedBox(height: 14),
            if (prefix != null)
              Text(
                prefix!.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFFF2D55),
                  fontSize: 10,
                  fontFamily: 'monospace',
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              _NeonButton(
                label: 'YENİDEN DENE',
                onTap: onRetry!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Neon kenarlıklı küçük buton
class _NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NeonButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF00FFD1).withValues(alpha: 0.8),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FFD1).withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF00FFD1),
            fontSize: 11,
            fontFamily: 'monospace',
            letterSpacing: 2.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
