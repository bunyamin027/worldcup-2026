import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

// ─── Team Model ──────────────────────────────────────────────────────────────
class TeamStanding {
  final String name;
  final String flag;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;
  final int points;

  const TeamStanding({
    required this.name,
    required this.flag,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
  });

  String get gd {
    final diff = goalsFor - goalsAgainst;
    return diff > 0 ? '+$diff' : '$diff';
  }
}

// ─── Group Model ─────────────────────────────────────────────────────────────
class GroupData {
  final String name;
  final List<TeamStanding> teams;
  const GroupData({required this.name, required this.teams});
}

// ─── 12 Groups × 4 Teams ────────────────────────────────────────────────────
final List<GroupData> _groups = [
  GroupData(name: 'A', teams: [
    const TeamStanding(name: 'BRA', flag: '🇧🇷', played: 3, won: 3, drawn: 0, lost: 0, goalsFor: 7, goalsAgainst: 1, points: 9),
    const TeamStanding(name: 'GER', flag: '🇩🇪', played: 3, won: 2, drawn: 0, lost: 1, goalsFor: 5, goalsAgainst: 3, points: 6),
    const TeamStanding(name: 'MAR', flag: '🇲🇦', played: 3, won: 1, drawn: 0, lost: 2, goalsFor: 2, goalsAgainst: 4, points: 3),
    const TeamStanding(name: 'CAN', flag: '🇨🇦', played: 3, won: 0, drawn: 0, lost: 3, goalsFor: 1, goalsAgainst: 7, points: 0),
  ]),
  GroupData(name: 'B', teams: [
    const TeamStanding(name: 'ARG', flag: '🇦🇷', played: 3, won: 2, drawn: 1, lost: 0, goalsFor: 6, goalsAgainst: 2, points: 7),
    const TeamStanding(name: 'FRA', flag: '🇫🇷', played: 3, won: 2, drawn: 0, lost: 1, goalsFor: 5, goalsAgainst: 3, points: 6),
    const TeamStanding(name: 'NGA', flag: '🇳🇬', played: 3, won: 1, drawn: 0, lost: 2, goalsFor: 3, goalsAgainst: 5, points: 3),
    const TeamStanding(name: 'AUS', flag: '🇦🇺', played: 3, won: 0, drawn: 1, lost: 2, goalsFor: 2, goalsAgainst: 6, points: 1),
  ]),
  GroupData(name: 'C', teams: [
    const TeamStanding(name: 'TUR', flag: '🇹🇷', played: 3, won: 2, drawn: 1, lost: 0, goalsFor: 5, goalsAgainst: 1, points: 7),
    const TeamStanding(name: 'ESP', flag: '🇪🇸', played: 3, won: 2, drawn: 1, lost: 0, goalsFor: 4, goalsAgainst: 1, points: 7),
    const TeamStanding(name: 'KOR', flag: '🇰🇷', played: 3, won: 1, drawn: 0, lost: 2, goalsFor: 2, goalsAgainst: 4, points: 3),
    const TeamStanding(name: 'CRC', flag: '🇨🇷', played: 3, won: 0, drawn: 0, lost: 3, goalsFor: 1, goalsAgainst: 6, points: 0),
  ]),
  GroupData(name: 'D', teams: [
    const TeamStanding(name: 'POR', flag: '🇵🇹', played: 3, won: 3, drawn: 0, lost: 0, goalsFor: 8, goalsAgainst: 2, points: 9),
    const TeamStanding(name: 'JPN', flag: '🇯🇵', played: 3, won: 1, drawn: 1, lost: 1, goalsFor: 4, goalsAgainst: 4, points: 4),
    const TeamStanding(name: 'SEN', flag: '🇸🇳', played: 3, won: 1, drawn: 0, lost: 2, goalsFor: 3, goalsAgainst: 5, points: 3),
    const TeamStanding(name: 'ECU', flag: '🇪🇨', played: 3, won: 0, drawn: 1, lost: 2, goalsFor: 2, goalsAgainst: 6, points: 1),
  ]),
  GroupData(name: 'E', teams: [
    const TeamStanding(name: 'ENG', flag: '🏴󠁧󠁢󠁥󠁮󠁧󠁿', played: 3, won: 2, drawn: 1, lost: 0, goalsFor: 5, goalsAgainst: 1, points: 7),
    const TeamStanding(name: 'MEX', flag: '🇲🇽', played: 3, won: 2, drawn: 0, lost: 1, goalsFor: 4, goalsAgainst: 3, points: 6),
    const TeamStanding(name: 'URU', flag: '🇺🇾', played: 3, won: 1, drawn: 0, lost: 2, goalsFor: 3, goalsAgainst: 4, points: 3),
    const TeamStanding(name: 'IRN', flag: '🇮🇷', played: 3, won: 0, drawn: 1, lost: 2, goalsFor: 1, goalsAgainst: 5, points: 1),
  ]),
  GroupData(name: 'F', teams: [
    const TeamStanding(name: 'NED', flag: '🇳🇱', played: 3, won: 2, drawn: 1, lost: 0, goalsFor: 6, goalsAgainst: 2, points: 7),
    const TeamStanding(name: 'USA', flag: '🇺🇸', played: 3, won: 2, drawn: 0, lost: 1, goalsFor: 5, goalsAgainst: 3, points: 6),
    const TeamStanding(name: 'GHA', flag: '🇬🇭', played: 3, won: 1, drawn: 0, lost: 2, goalsFor: 2, goalsAgainst: 4, points: 3),
    const TeamStanding(name: 'QAT', flag: '🇶🇦', played: 3, won: 0, drawn: 1, lost: 2, goalsFor: 1, goalsAgainst: 5, points: 1),
  ]),
  GroupData(name: 'G', teams: [
    const TeamStanding(name: 'BEL', flag: '🇧🇪', played: 3, won: 2, drawn: 1, lost: 0, goalsFor: 5, goalsAgainst: 2, points: 7),
    const TeamStanding(name: 'ITA', flag: '🇮🇹', played: 3, won: 1, drawn: 2, lost: 0, goalsFor: 3, goalsAgainst: 2, points: 5),
    const TeamStanding(name: 'COL', flag: '🇨🇴', played: 3, won: 1, drawn: 0, lost: 2, goalsFor: 3, goalsAgainst: 5, points: 3),
    const TeamStanding(name: 'SAU', flag: '🇸🇦', played: 3, won: 0, drawn: 1, lost: 2, goalsFor: 2, goalsAgainst: 4, points: 1),
  ]),
  GroupData(name: 'H', teams: [
    const TeamStanding(name: 'CRO', flag: '🇭🇷', played: 3, won: 2, drawn: 1, lost: 0, goalsFor: 4, goalsAgainst: 1, points: 7),
    const TeamStanding(name: 'DEN', flag: '🇩🇰', played: 3, won: 1, drawn: 2, lost: 0, goalsFor: 3, goalsAgainst: 2, points: 5),
    const TeamStanding(name: 'SRB', flag: '🇷🇸', played: 3, won: 1, drawn: 0, lost: 2, goalsFor: 3, goalsAgainst: 5, points: 3),
    const TeamStanding(name: 'CMR', flag: '🇨🇲', played: 3, won: 0, drawn: 1, lost: 2, goalsFor: 2, goalsAgainst: 4, points: 1),
  ]),
  GroupData(name: 'I', teams: [
    const TeamStanding(name: 'POL', flag: '🇵🇱', played: 3, won: 2, drawn: 0, lost: 1, goalsFor: 4, goalsAgainst: 3, points: 6),
    const TeamStanding(name: 'SUI', flag: '🇨🇭', played: 3, won: 1, drawn: 2, lost: 0, goalsFor: 3, goalsAgainst: 2, points: 5),
    const TeamStanding(name: 'CHI', flag: '🇨🇱', played: 3, won: 1, drawn: 1, lost: 1, goalsFor: 3, goalsAgainst: 3, points: 4),
    const TeamStanding(name: 'TUN', flag: '🇹🇳', played: 3, won: 0, drawn: 1, lost: 2, goalsFor: 1, goalsAgainst: 3, points: 1),
  ]),
  GroupData(name: 'J', teams: [
    const TeamStanding(name: 'UKR', flag: '🇺🇦', played: 3, won: 2, drawn: 1, lost: 0, goalsFor: 5, goalsAgainst: 2, points: 7),
    const TeamStanding(name: 'SWE', flag: '🇸🇪', played: 3, won: 1, drawn: 2, lost: 0, goalsFor: 4, goalsAgainst: 3, points: 5),
    const TeamStanding(name: 'PAR', flag: '🇵🇾', played: 3, won: 1, drawn: 0, lost: 2, goalsFor: 2, goalsAgainst: 4, points: 3),
    const TeamStanding(name: 'NZL', flag: '🇳🇿', played: 3, won: 0, drawn: 1, lost: 2, goalsFor: 1, goalsAgainst: 3, points: 1),
  ]),
  GroupData(name: 'K', teams: [
    const TeamStanding(name: 'CZE', flag: '🇨🇿', played: 3, won: 2, drawn: 0, lost: 1, goalsFor: 4, goalsAgainst: 2, points: 6),
    const TeamStanding(name: 'WAL', flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿', played: 3, won: 1, drawn: 2, lost: 0, goalsFor: 3, goalsAgainst: 2, points: 5),
    const TeamStanding(name: 'ALG', flag: '🇩🇿', played: 3, won: 1, drawn: 1, lost: 1, goalsFor: 3, goalsAgainst: 3, points: 4),
    const TeamStanding(name: 'PER', flag: '🇵🇪', played: 3, won: 0, drawn: 1, lost: 2, goalsFor: 1, goalsAgainst: 4, points: 1),
  ]),
  GroupData(name: 'L', teams: [
    const TeamStanding(name: 'AUT', flag: '🇦🇹', played: 3, won: 2, drawn: 1, lost: 0, goalsFor: 6, goalsAgainst: 3, points: 7),
    const TeamStanding(name: 'EGY', flag: '🇪🇬', played: 3, won: 1, drawn: 1, lost: 1, goalsFor: 3, goalsAgainst: 3, points: 4),
    const TeamStanding(name: 'JAM', flag: '🇯🇲', played: 3, won: 1, drawn: 0, lost: 2, goalsFor: 2, goalsAgainst: 4, points: 3),
    const TeamStanding(name: 'CHN', flag: '🇨🇳', played: 3, won: 0, drawn: 2, lost: 1, goalsFor: 2, goalsAgainst: 3, points: 2),
  ]),
];

// ─── Standings Screen ────────────────────────────────────────────────────────
class StandingsScreen extends StatelessWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        itemCount: _groups.length,
        itemBuilder: (context, index) {
          return _GroupCard(group: _groups[index], index: index);
        },
      ),
    );
  }
}

// ─── Group Card ──────────────────────────────────────────────────────────────
class _GroupCard extends StatelessWidget {
  final GroupData group;
  final int index;

  const _GroupCard({required this.group, required this.index});

  // Alternate neon accent per card
  Color get _accent =>
      index.isEven ? CyberColors.neonCyan : CyberColors.neonMagenta;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: _accent.withOpacity(0.10),
              blurRadius: 30,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: CyberColors.background.withOpacity(0.6),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: _accent.withOpacity(0.18),
                  width: 1,
                ),
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
                  // ── Header ────────────────────────────────────────────
                  _buildHeader(),
                  // ── Column Labels ─────────────────────────────────────
                  _buildColumnLabels(),
                  // ── Team Rows ─────────────────────────────────────────
                  ...group.teams.asMap().entries.map(
                        (e) => _buildTeamRow(e.key, e.value),
                      ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Card Header ───────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _accent.withOpacity(0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          // Neon dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accent,
              boxShadow: [
                BoxShadow(
                  color: _accent.withOpacity(0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'GRUP ${group.name}',
            style: GoogleFonts.orbitron(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 4,
              color: _accent,
              shadows: [
                Shadow(
                  color: _accent.withOpacity(0.4),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const Spacer(),
          // Decorative line
          Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              gradient: LinearGradient(
                colors: [
                  _accent.withOpacity(0.5),
                  _accent.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Column Labels ─────────────────────────────────────────────────────────
  Widget _buildColumnLabels() {
    final style = GoogleFonts.orbitron(
      fontSize: 8,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.5,
      color: CyberColors.textSecondary.withOpacity(0.45),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 4),
      child: Row(
        children: [
          SizedBox(width: 24, child: Text('#', style: style)),
          const SizedBox(width: 8),
          Expanded(child: Text('TAKIM', style: style)),
          SizedBox(width: 30, child: Center(child: Text('O', style: style))),
          SizedBox(width: 30, child: Center(child: Text('G', style: style))),
          SizedBox(width: 30, child: Center(child: Text('B', style: style))),
          SizedBox(width: 30, child: Center(child: Text('M', style: style))),
          SizedBox(width: 36, child: Center(child: Text('AV', style: style))),
          SizedBox(width: 32, child: Center(child: Text('P', style: style))),
        ],
      ),
    );
  }

  // ── Team Row ──────────────────────────────────────────────────────────────
  Widget _buildTeamRow(int rank, TeamStanding team) {
    final isQualified = rank < 2;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isQualified
            ? _accent.withOpacity(0.05)
            : Colors.transparent,
        border: isQualified
            ? Border.all(color: _accent.withOpacity(0.08))
            : null,
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 22,
            child: Text(
              '${rank + 1}',
              style: GoogleFonts.orbitron(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isQualified ? _accent : CyberColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Flag
          Text(team.flag, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),

          // Name
          Expanded(
            child: Text(
              team.name,
              style: GoogleFonts.orbitron(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: isQualified
                    ? CyberColors.textPrimary
                    : CyberColors.textSecondary,
              ),
            ),
          ),

          // Stats
          _statCell('${team.played}', 30),
          _statCell('${team.won}', 30),
          _statCell('${team.drawn}', 30),
          _statCell('${team.lost}', 30),
          _statCell(team.gd, 36,
              color: (team.goalsFor - team.goalsAgainst) > 0
                  ? CyberColors.neonCyan.withOpacity(0.8)
                  : (team.goalsFor - team.goalsAgainst) < 0
                      ? CyberColors.neonMagenta.withOpacity(0.7)
                      : null),

          // Points – highlighted
          Container(
            width: 32,
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: isQualified
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: _accent.withOpacity(0.12),
                  )
                : null,
            child: Center(
              child: Text(
                '${team.points}',
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isQualified
                      ? _accent
                      : CyberColors.textSecondary,
                  shadows: isQualified
                      ? [
                          Shadow(
                            color: _accent.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCell(String value, double width, {Color? color}) {
    return SizedBox(
      width: width,
      child: Center(
        child: Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: color ?? CyberColors.textSecondary.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
