import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

// ─── Match Model ─────────────────────────────────────────────────────────────
class MatchData {
  final String teamA;
  final String flagA;
  final String teamB;
  final String flagB;
  final String time;
  final String stadium;
  final String group;
  final int? scoreA;
  final int? scoreB;
  final bool isLive;
  final int? minute;

  const MatchData({
    required this.teamA,
    required this.flagA,
    required this.teamB,
    required this.flagB,
    required this.time,
    required this.stadium,
    required this.group,
    this.scoreA,
    this.scoreB,
    this.isLive = false,
    this.minute,
  });
}

// ─── Mock Data ───────────────────────────────────────────────────────────────
final List<MatchData> _todayMatches = [
  const MatchData(
    teamA: 'BRA', flagA: '🇧🇷',
    teamB: 'GER', flagB: '🇩🇪',
    time: '18:00', stadium: 'MetLife Stadium',
    group: 'A Grubu',
    scoreA: 2, scoreB: 1,
    isLive: true, minute: 67,
  ),
  const MatchData(
    teamA: 'ARG', flagA: '🇦🇷',
    teamB: 'FRA', flagB: '🇫🇷',
    time: '21:00', stadium: 'AT&T Stadium',
    group: 'B Grubu',
    scoreA: 0, scoreB: 0,
    isLive: true, minute: 12,
  ),
  const MatchData(
    teamA: 'TUR', flagA: '🇹🇷',
    teamB: 'ESP', flagB: '🇪🇸',
    time: '22:00', stadium: 'Rose Bowl',
    group: 'C Grubu',
  ),
  const MatchData(
    teamA: 'POR', flagA: '🇵🇹',
    teamB: 'JPN', flagB: '🇯🇵',
    time: '00:00', stadium: 'Azteca Stadium',
    group: 'D Grubu',
  ),
  const MatchData(
    teamA: 'ENG', flagA: '🏴\u200D☠️',
    teamB: 'MEX', flagB: '🇲🇽',
    time: '02:00', stadium: 'BMO Field',
    group: 'E Grubu',
  ),
];

// ─── Dashboard Screen ────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late Timer _countdownTimer;
  late Duration _remaining;
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    // Next match countdown – target: today 22:00
    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, 22, 0);
    if (target.isBefore(now)) target = target.add(const Duration(days: 1));
    _remaining = target.difference(now);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds > 0) {
        setState(() => _remaining -= const Duration(seconds: 1));
      }
    });

    // Glow pulse
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _glowAnim = Tween(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeroCountdown(),
              const SizedBox(height: 32),
              _buildSectionTitle('GÜNÜN MAÇLARI'),
              const SizedBox(height: 16),
              _buildMatchCarousel(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero Countdown ────────────────────────────────────────────────────────
  Widget _buildHeroCountdown() {
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white.withOpacity(0.06),
                  border: Border.all(
                    color: CyberColors.neonCyan.withOpacity(
                      0.15 + 0.1 * _glowAnim.value,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: CyberColors.neonCyan.withOpacity(0.08 * _glowAnim.value),
                      blurRadius: 40,
                      spreadRadius: 2,
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      CyberColors.neonCyan.withOpacity(0.06),
                      CyberColors.neonMagenta.withOpacity(0.03),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Label
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CyberColors.neonCyan,
                            boxShadow: [
                              BoxShadow(
                                color: CyberColors.neonCyan.withOpacity(0.6),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'SIRADAKİ MAÇA KALAN SÜRE',
                          style: GoogleFonts.orbitron(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3,
                            color: CyberColors.neonCyan.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Digital clock digits
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDigitBlock(h),
                        _buildSeparator(),
                        _buildDigitBlock(m),
                        _buildSeparator(),
                        _buildDigitBlock(s),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildUnitLabel('SAAT', 68),
                        const SizedBox(width: 24),
                        _buildUnitLabel('DAKİKA', 68),
                        const SizedBox(width: 24),
                        _buildUnitLabel('SANİYE', 68),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Next match info
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: CyberColors.neonMagenta.withOpacity(0.08),
                        border: Border.all(
                          color: CyberColors.neonMagenta.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        '🇹🇷 TUR  vs  ESP 🇪🇸  •  22:00',
                        style: GoogleFonts.orbitron(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          color: CyberColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDigitBlock(String value) {
    return Container(
      width: 68,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: CyberColors.background.withOpacity(0.7),
        border: Border.all(
          color: CyberColors.neonCyan.withOpacity(0.15),
        ),
      ),
      child: Center(
        child: Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: CyberColors.textPrimary,
            letterSpacing: 4,
            shadows: [
              Shadow(
                color: CyberColors.neonCyan.withOpacity(0.5),
                blurRadius: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        ':',
        style: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: CyberColors.neonCyan.withOpacity(0.6),
          shadows: [
            Shadow(
              color: CyberColors.neonCyan.withOpacity(0.4),
              blurRadius: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitLabel(String label, double width) {
    return SizedBox(
      width: width,
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.orbitron(
            fontSize: 8,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: CyberColors.textSecondary.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  // ── Section Title ─────────────────────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: CyberColors.neonCyan,
              boxShadow: [
                BoxShadow(
                  color: CyberColors.neonCyan.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.orbitron(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: CyberColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Match Carousel ────────────────────────────────────────────────────────
  Widget _buildMatchCarousel() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _todayMatches.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _MatchCard(
              match: _todayMatches[index],
              glowAnim: _glowAnim,
            ),
          );
        },
      ),
    );
  }
}

// ─── Match Card Widget ──────────────────────────────────────────────────────
class _MatchCard extends StatelessWidget {
  final MatchData match;
  final Animation<double> glowAnim;

  const _MatchCard({required this.match, required this.glowAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnim,
      builder: (context, _) {
        return Container(
          width: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: match.isLive
                ? [
                    BoxShadow(
                      color: CyberColors.neonCyan
                          .withOpacity(0.25 * glowAnim.value),
                      blurRadius: 24,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: CyberColors.neonCyan
                          .withOpacity(0.08 * glowAnim.value),
                      blurRadius: 50,
                      spreadRadius: 4,
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.06),
                  border: Border.all(
                    color: match.isLive
                        ? CyberColors.neonCyan
                            .withOpacity(0.3 + 0.2 * glowAnim.value)
                        : CyberColors.borderGlass,
                    width: match.isLive ? 1.5 : 1,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.10),
                      Colors.white.withOpacity(0.03),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: group + live badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          match.group,
                          style: GoogleFonts.orbitron(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                            color: CyberColors.textSecondary.withOpacity(0.7),
                          ),
                        ),
                        if (match.isLive) _buildLiveBadge(),
                        if (!match.isLive)
                          Text(
                            match.time,
                            style: GoogleFonts.orbitron(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: CyberColors.textSecondary,
                            ),
                          ),
                      ],
                    ),

                    const Spacer(),

                    // Teams + Score
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(match.flagA,
                                  style: const TextStyle(fontSize: 30)),
                              const SizedBox(height: 6),
                              Text(
                                match.teamA,
                                style: GoogleFonts.orbitron(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: CyberColors.textPrimary,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Score or VS
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: match.isLive
                                ? CyberColors.neonCyan.withOpacity(0.08)
                                : CyberColors.background.withOpacity(0.5),
                            border: Border.all(
                              color: match.isLive
                                  ? CyberColors.neonCyan.withOpacity(0.2)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            match.isLive
                                ? '${match.scoreA} - ${match.scoreB}'
                                : 'VS',
                            style: GoogleFonts.orbitron(
                              fontSize: match.isLive ? 16 : 12,
                              fontWeight: FontWeight.w800,
                              color: match.isLive
                                  ? CyberColors.neonCyan
                                  : CyberColors.textSecondary,
                              letterSpacing: 2,
                              shadows: match.isLive
                                  ? [
                                      Shadow(
                                        color: CyberColors.neonCyan
                                            .withOpacity(0.5),
                                        blurRadius: 10,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(match.flagB,
                                  style: const TextStyle(fontSize: 30)),
                              const SizedBox(height: 6),
                              Text(
                                match.teamB,
                                style: GoogleFonts.orbitron(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: CyberColors.textPrimary,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Stadium
                    Row(
                      children: [
                        Icon(
                          Icons.stadium_outlined,
                          size: 12,
                          color: CyberColors.textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            match.stadium,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.orbitron(
                              fontSize: 8,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                              color: CyberColors.textSecondary.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFFF1744).withOpacity(0.15),
        border: Border.all(
          color: const Color(0xFFFF1744).withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF1744),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF1744).withOpacity(0.6),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Text(
            "CANLI ${match.minute}'",
            style: GoogleFonts.orbitron(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: const Color(0xFFFF1744),
            ),
          ),
        ],
      ),
    );
  }
}
