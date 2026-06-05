import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

// ─── Event Types ─────────────────────────────────────────────────────────────
enum EventType { goal, yellowCard, redCard, substitution }

class MatchEvent {
  final int minute;
  final EventType type;
  final String player;
  final String? assist;
  final String? playerOut;
  final bool isHome;

  const MatchEvent({
    required this.minute,
    required this.type,
    required this.player,
    this.assist,
    this.playerOut,
    required this.isHome,
  });
}

// ─── Mock Data ───────────────────────────────────────────────────────────────
const String _homeTeam = 'BRA';
const String _homeFlag = '🇧🇷';
const int _homeScore = 3;

const String _awayTeam = 'GER';
const String _awayFlag = '🇩🇪';
const int _awayScore = 2;

const String _stadium = 'MetLife Stadium, New Jersey';
const String _group = 'A Grubu – Maç Günü 3';
const int _matchMinute = 78;

final List<MatchEvent> _events = [
  const MatchEvent(minute: 8,  type: EventType.goal,         player: 'Vinícius Jr.',   assist: 'Rodrygo',       isHome: true),
  const MatchEvent(minute: 23, type: EventType.yellowCard,   player: 'Casemiro',                                isHome: true),
  const MatchEvent(minute: 31, type: EventType.goal,         player: 'J. Musiala',     assist: 'F. Wirtz',      isHome: false),
  const MatchEvent(minute: 38, type: EventType.substitution, player: 'L. Sané',        playerOut: 'T. Müller',  isHome: false),
  const MatchEvent(minute: 45, type: EventType.yellowCard,   player: 'A. Rüdiger',                              isHome: false),
  const MatchEvent(minute: 52, type: EventType.goal,         player: 'Raphinha',        assist: 'Paquetá',      isHome: true),
  const MatchEvent(minute: 63, type: EventType.redCard,      player: 'A. Rüdiger',                              isHome: false),
  const MatchEvent(minute: 67, type: EventType.goal,         player: 'F. Wirtz',        assist: 'J. Musiala',   isHome: false),
  const MatchEvent(minute: 72, type: EventType.substitution, player: 'Endrick',         playerOut: 'Richarlison',isHome: true),
  const MatchEvent(minute: 76, type: EventType.goal,         player: 'Endrick',         assist: 'Vinícius Jr.', isHome: true),
];

// ─── Match Detail Screen ─────────────────────────────────────────────────────
class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'MAÇ DETAY',
          style: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
            color: CyberColors.neonCyan,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 100),
            _buildScoreboard(),
            const SizedBox(height: 32),
            _buildTimelineHeader(),
            const SizedBox(height: 8),
            _buildTimeline(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  // ── Scoreboard ────────────────────────────────────────────────────────────
  Widget _buildScoreboard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: CyberColors.borderGlass),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.02),
                ],
              ),
            ),
            child: Column(
              children: [
                // Group + Stadium
                Text(
                  _group,
                  style: GoogleFonts.orbitron(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                    color: CyberColors.textSecondary.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 24),

                // Teams & Score
                Row(
                  children: [
                    // Home
                    Expanded(child: _buildTeamColumn(_homeFlag, _homeTeam)),

                    // Score
                    _buildScoreCenter(),

                    // Away
                    Expanded(child: _buildTeamColumn(_awayFlag, _awayTeam)),
                  ],
                ),

                const SizedBox(height: 20),

                // Stadium
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.stadium_outlined,
                        size: 12,
                        color: CyberColors.textSecondary.withOpacity(0.4)),
                    const SizedBox(width: 6),
                    Text(
                      _stadium,
                      style: GoogleFonts.orbitron(
                        fontSize: 8,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                        color: CyberColors.textSecondary.withOpacity(0.4),
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
  }

  Widget _buildTeamColumn(String flag, String name) {
    return Column(
      children: [
        // Flag placeholder – metallic circle
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: CyberColors.surface,
            border: Border.all(
              color: CyberColors.borderGlass,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: CyberColors.neonCyan.withOpacity(0.08),
                blurRadius: 16,
              ),
            ],
          ),
          child: Center(
            child: Text(flag, style: const TextStyle(fontSize: 34)),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: GoogleFonts.orbitron(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 4,
            color: CyberColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCenter() {
    return Column(
      children: [
        // Live badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                "$_matchMinute'",
                style: GoogleFonts.orbitron(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF1744),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Score digits
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: CyberColors.background.withOpacity(0.6),
            border: Border.all(
              color: CyberColors.neonCyan.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: CyberColors.neonCyan.withOpacity(0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$_homeScore',
                style: GoogleFonts.orbitron(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: CyberColors.textPrimary,
                  shadows: [
                    Shadow(
                      color: CyberColors.neonCyan.withOpacity(0.5),
                      blurRadius: 14,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  ':',
                  style: GoogleFonts.orbitron(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: CyberColors.neonCyan.withOpacity(0.4),
                  ),
                ),
              ),
              Text(
                '$_awayScore',
                style: GoogleFonts.orbitron(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: CyberColors.textPrimary,
                  shadows: [
                    Shadow(
                      color: CyberColors.neonCyan.withOpacity(0.5),
                      blurRadius: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Timeline Header ──────────────────────────────────────────────────────
  Widget _buildTimelineHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: CyberColors.neonMagenta,
              boxShadow: [
                BoxShadow(
                  color: CyberColors.neonMagenta.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'MAÇ OLAYLARI',
            style: GoogleFonts.orbitron(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: CyberColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Timeline ──────────────────────────────────────────────────────────────
  Widget _buildTimeline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: _events.asMap().entries.map((entry) {
          final i = entry.key;
          final event = entry.value;
          final isLast = i == _events.length - 1;
          return _TimelineEventTile(event: event, isLast: isLast);
        }).toList(),
      ),
    );
  }
}

// ─── Timeline Event Tile ────────────────────────────────────────────────────
class _TimelineEventTile extends StatelessWidget {
  final MatchEvent event;
  final bool isLast;

  const _TimelineEventTile({required this.event, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final config = _getEventConfig();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Minute column ─────────────────────────────────────────
          SizedBox(
            width: 40,
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                "${event.minute}'",
                textAlign: TextAlign.right,
                style: GoogleFonts.orbitron(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: CyberColors.neonCyan.withOpacity(0.7),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // ── Timeline line + icon ──────────────────────────────────
          Column(
            children: [
              // Icon with glow
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: config.color.withOpacity(0.12),
                  border: Border.all(
                    color: config.color.withOpacity(0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: config.color.withOpacity(config.glowIntensity),
                      blurRadius: config.glowRadius,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: config.color.withOpacity(config.glowIntensity * 0.4),
                      blurRadius: config.glowRadius * 2,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    config.icon,
                    size: 16,
                    color: config.color,
                    shadows: [
                      Shadow(
                        color: config.color.withOpacity(0.6),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),

              // Connecting line
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        config.color.withOpacity(0.3),
                        CyberColors.borderGlass.withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // ── Event content card ────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white.withOpacity(0.04),
                      border: Border.all(
                        color: config.color.withOpacity(0.12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event label + team side
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: config.color.withOpacity(0.1),
                              ),
                              child: Text(
                                config.label,
                                style: GoogleFonts.orbitron(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                  color: config.color,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              event.isHome ? _homeFlag : _awayFlag,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Player name
                        Text(
                          event.player,
                          style: GoogleFonts.orbitron(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: CyberColors.textPrimary,
                            letterSpacing: 1,
                          ),
                        ),

                        // Assist or sub-out
                        if (event.assist != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.assist_walker_rounded,
                                  size: 10,
                                  color: CyberColors.textSecondary
                                      .withOpacity(0.5)),
                              const SizedBox(width: 4),
                              Text(
                                'Asist: ${event.assist}',
                                style: GoogleFonts.orbitron(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                  color: CyberColors.textSecondary
                                      .withOpacity(0.6),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (event.playerOut != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.arrow_downward_rounded,
                                  size: 10,
                                  color: const Color(0xFFFF1744)
                                      .withOpacity(0.6)),
                              const SizedBox(width: 4),
                              Text(
                                event.playerOut!,
                                style: GoogleFonts.orbitron(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                  color: CyberColors.textSecondary
                                      .withOpacity(0.6),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _EventConfig _getEventConfig() {
    switch (event.type) {
      case EventType.goal:
        return _EventConfig(
          icon: Icons.sports_soccer_rounded,
          color: CyberColors.neonCyan,
          label: 'GOL',
          glowIntensity: 0.45,
          glowRadius: 20,
        );
      case EventType.yellowCard:
        return _EventConfig(
          icon: Icons.square_rounded,
          color: const Color(0xFFFFD600),
          label: 'SARI KART',
          glowIntensity: 0.25,
          glowRadius: 12,
        );
      case EventType.redCard:
        return _EventConfig(
          icon: Icons.square_rounded,
          color: const Color(0xFFFF1744),
          label: 'KIRMIZI KART',
          glowIntensity: 0.5,
          glowRadius: 22,
        );
      case EventType.substitution:
        return _EventConfig(
          icon: Icons.swap_horiz_rounded,
          color: CyberColors.neonMagenta,
          label: 'DEĞİŞİKLİK',
          glowIntensity: 0.2,
          glowRadius: 10,
        );
    }
  }
}

// ─── Event Config ────────────────────────────────────────────────────────────
class _EventConfig {
  final IconData icon;
  final Color color;
  final String label;
  final double glowIntensity;
  final double glowRadius;

  const _EventConfig({
    required this.icon,
    required this.color,
    required this.label,
    required this.glowIntensity,
    required this.glowRadius,
  });
}
