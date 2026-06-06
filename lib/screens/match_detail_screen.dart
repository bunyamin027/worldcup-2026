import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../providers/providers.dart';
import '../models/models.dart';

// ─── Event Types ─────────────────────────────────────────────────────────────
enum EventType { goal, yellowCard, redCard, substitution, unknown }

class MatchEvent {
  final int minute;
  final EventType type;
  final String player;
  final String? assist;
  final String? playerOut;
  final int teamId;

  const MatchEvent({
    required this.minute,
    required this.type,
    required this.player,
    this.assist,
    this.playerOut,
    required this.teamId,
  });

  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type']?.toString().toLowerCase() ?? '';
    final detail = json['detail']?.toString().toLowerCase() ?? '';

    EventType type = EventType.unknown;
    if (typeStr == 'goal') type = EventType.goal;
    else if (typeStr == 'card') {
      if (detail.contains('yellow')) type = EventType.yellowCard;
      else if (detail.contains('red')) type = EventType.redCard;
    } else if (typeStr == 'subst') {
      type = EventType.substitution;
    }

    final assistName = json['assist'] != null && json['assist']['name'] != null 
        ? json['assist']['name'].toString() 
        : null;

    return MatchEvent(
      minute: json['time']['elapsed'] ?? 0,
      type: type,
      player: json['player']['name'] ?? 'Unknown',
      assist: type == EventType.goal ? assistName : null,
      playerOut: type == EventType.substitution ? assistName : null,
      teamId: json['team']['id'] ?? 0,
    );
  }
}

// ─── Match Detail Screen ─────────────────────────────────────────────────────
class MatchDetailScreen extends ConsumerWidget {
  final int? fixtureId;

  const MatchDetailScreen({super.key, this.fixtureId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = fixtureId ?? 0;
    
    // Yükleme sırasında arka planın tam oturması için Scaffold
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
      body: id == 0 
          ? const Center(child: Text("Maç ID bulunamadı"))
          : _buildBody(context, ref, id),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, int id) {
    final detailAsync = ref.watch(fixtureDetailProvider(id));
    final eventsAsync = ref.watch(fixtureEventsProvider(id));

    return detailAsync.when(
      loading: () => const Center(child: NeonLoadingIndicator(label: 'MAÇ BİLGİSİ YÜKLENİYOR...')),
      error: (e, st) => NeonErrorWidget(
        message: e.toString(),
        prefix: 'BAĞLANTI HATASI',
        onRetry: () => ref.refresh(fixtureDetailProvider(id)),
      ),
      data: (detailData) {
        final List<dynamic> response = detailData['response'] ?? [];
        if (response.isEmpty) {
          return Center(
            child: Text(
              'MAÇ BULUNAMADI',
              style: GoogleFonts.orbitron(color: CyberColors.textSecondary),
            ),
          );
        }

        final fixtureJson = response.first;
        final fixture = Fixture.fromJson(fixtureJson);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 100),
              _buildScoreboard(fixture),
              const SizedBox(height: 32),
              _buildTimelineHeader(),
              const SizedBox(height: 8),
              
              eventsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(40),
                  child: NeonLoadingIndicator(label: 'OLAYLAR YÜKLENİYOR...', size: 40),
                ),
                error: (e, st) => NeonErrorWidget(message: 'OLAYLAR ALINAMADI', prefix: 'HATA'),
                data: (eventsData) {
                  final List<dynamic> evtResponse = eventsData['response'] ?? [];
                  final events = evtResponse
                      .map((e) => MatchEvent.fromJson(e))
                      .where((e) => e.type != EventType.unknown)
                      .toList();
                  
                  if (events.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'MAÇ OLAYI BULUNAMADI',
                        style: GoogleFonts.orbitron(color: CyberColors.textSecondary.withOpacity(0.5)),
                      ),
                    );
                  }

                  return _buildTimeline(events, fixture.homeTeam.id);
                },
              ),
              const SizedBox(height: 48),
            ],
          ),
        );
      },
    );
  }

  // ── Scoreboard ────────────────────────────────────────────────────────────
  Widget _buildScoreboard(Fixture fixture) {
    final isLive = ['1H', '2H', 'HT', 'ET', 'P', 'BT', 'LIVE'].contains(fixture.status);
    final stadium = 'DÜNYA KUPASI STADYUMU'; // Placeholder if API doesn't provide
    final group = 'DÜNYA KUPASI 2026';

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
                  group,
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
                    Expanded(child: _buildTeamColumn(fixture.homeTeam.logo, fixture.homeTeam.name)),

                    // Score
                    _buildScoreCenter(fixture, isLive),

                    // Away
                    Expanded(child: _buildTeamColumn(fixture.awayTeam.logo, fixture.awayTeam.name)),
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
                      stadium,
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

  Widget _buildTeamColumn(String logoUrl, String name) {
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
            child: Image.network(
              logoUrl,
              width: 40,
              height: 40,
              errorBuilder: (c, e, s) => const Icon(Icons.flag, color: Colors.white54, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: CyberColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCenter(Fixture fixture, bool isLive) {
    final statusText = fixture.status == 'FT' ? 'MAÇ SONUCU' : (isLive && fixture.elapsed != null ? "${fixture.elapsed}'" : fixture.status);
    
    return Column(
      children: [
        // Live badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isLive 
                ? const Color(0xFFFF1744).withOpacity(0.15)
                : CyberColors.textSecondary.withOpacity(0.1),
            border: Border.all(
              color: isLive 
                  ? const Color(0xFFFF1744).withOpacity(0.4)
                  : CyberColors.textSecondary.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLive)
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
              if (isLive) const SizedBox(width: 5),
              Text(
                statusText,
                style: GoogleFonts.orbitron(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: isLive ? const Color(0xFFFF1744) : CyberColors.textSecondary,
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
              color: isLive ? CyberColors.neonCyan.withOpacity(0.2) : Colors.transparent,
            ),
            boxShadow: isLive ? [
              BoxShadow(
                color: CyberColors.neonCyan.withOpacity(0.1),
                blurRadius: 20,
              ),
            ] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${fixture.homeScore ?? 0}',
                style: GoogleFonts.orbitron(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: CyberColors.textPrimary,
                  shadows: isLive ? [
                    Shadow(
                      color: CyberColors.neonCyan.withOpacity(0.5),
                      blurRadius: 14,
                    ),
                  ] : null,
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
                '${fixture.awayScore ?? 0}',
                style: GoogleFonts.orbitron(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: CyberColors.textPrimary,
                  shadows: isLive ? [
                    Shadow(
                      color: CyberColors.neonCyan.withOpacity(0.5),
                      blurRadius: 14,
                    ),
                  ] : null,
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
  Widget _buildTimeline(List<MatchEvent> events, int homeTeamId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: events.asMap().entries.map((entry) {
          final i = entry.key;
          final event = entry.value;
          final isLast = i == events.length - 1;
          final isHome = event.teamId == homeTeamId;
          return _TimelineEventTile(event: event, isLast: isLast, isHome: isHome);
        }).toList(),
      ),
    );
  }
}

// ─── Timeline Event Tile ────────────────────────────────────────────────────
class _TimelineEventTile extends StatelessWidget {
  final MatchEvent event;
  final bool isLast;
  final bool isHome;

  const _TimelineEventTile({
    required this.event, 
    required this.isLast,
    required this.isHome,
  });

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
                Expanded(
                  child: Container(
                    width: 2,
                    constraints: const BoxConstraints(minHeight: 40),
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
                ),
            ],
          ),
          const SizedBox(width: 14),

          // ── Event content card ────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
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
                            // Show home/away text or icon indicator
                            Text(
                              isHome ? 'EV SAHİBİ' : 'DEPLASMAN',
                              style: GoogleFonts.orbitron(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: CyberColors.textSecondary.withOpacity(0.6),
                                letterSpacing: 1,
                              ),
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
      default:
        return _EventConfig(
          icon: Icons.info_outline,
          color: CyberColors.textSecondary,
          label: 'OLAY',
          glowIntensity: 0.1,
          glowRadius: 5,
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
