import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../providers/providers.dart';
import '../models/models.dart';

// ─── Group Model ─────────────────────────────────────────────────────────────
class GroupData {
  final String name;
  final List<dynamic> teams;
  const GroupData({required this.name, required this.teams});
}

// ─── Standings Screen ────────────────────────────────────────────────────────
final List<GroupData> _worldCup2026Groups = [
  GroupData(name: 'A', teams: [
    {'position': 1, 'team': {'name': 'Meksika', 'crest': 'https://flagcdn.com/w80/mx.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 2, 'team': {'name': 'Güney Afrika', 'crest': 'https://flagcdn.com/w80/za.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 3, 'team': {'name': 'Güney Kore', 'crest': 'https://flagcdn.com/w80/kr.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 4, 'team': {'name': 'Çekya', 'crest': 'https://flagcdn.com/w80/cz.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
  ]),
  GroupData(name: 'B', teams: [
    {'position': 1, 'team': {'name': 'Kanada', 'crest': 'https://flagcdn.com/w80/ca.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 2, 'team': {'name': 'Bosna Hersek', 'crest': 'https://flagcdn.com/w80/ba.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 3, 'team': {'name': 'Katar', 'crest': 'https://flagcdn.com/w80/qa.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 4, 'team': {'name': 'İsviçre', 'crest': 'https://flagcdn.com/w80/ch.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
  ]),
  GroupData(name: 'C', teams: [
    {'position': 1, 'team': {'name': 'Brezilya', 'crest': 'https://flagcdn.com/w80/br.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 2, 'team': {'name': 'Fas', 'crest': 'https://flagcdn.com/w80/ma.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 3, 'team': {'name': 'Haiti', 'crest': 'https://flagcdn.com/w80/ht.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 4, 'team': {'name': 'İskoçya', 'crest': 'https://flagcdn.com/w80/gb-sct.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
  ]),
  GroupData(name: 'D', teams: [
    {'position': 1, 'team': {'name': 'ABD', 'crest': 'https://flagcdn.com/w80/us.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 2, 'team': {'name': 'Paraguay', 'crest': 'https://flagcdn.com/w80/py.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 3, 'team': {'name': 'Avustralya', 'crest': 'https://flagcdn.com/w80/au.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 4, 'team': {'name': 'Türkiye', 'crest': 'https://flagcdn.com/w80/tr.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
  ]),
  GroupData(name: 'E', teams: [
    {'position': 1, 'team': {'name': 'Almanya', 'crest': 'https://flagcdn.com/w80/de.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 2, 'team': {'name': 'Curaçao', 'crest': 'https://flagcdn.com/w80/cw.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 3, 'team': {'name': 'Fildişi Sahili', 'crest': 'https://flagcdn.com/w80/ci.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 4, 'team': {'name': 'Ekvador', 'crest': 'https://flagcdn.com/w80/ec.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
  ]),
  GroupData(name: 'F', teams: [
    {'position': 1, 'team': {'name': 'Hollanda', 'crest': 'https://flagcdn.com/w80/nl.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 2, 'team': {'name': 'Japonya', 'crest': 'https://flagcdn.com/w80/jp.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 3, 'team': {'name': 'İsveç', 'crest': 'https://flagcdn.com/w80/se.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 4, 'team': {'name': 'Tunus', 'crest': 'https://flagcdn.com/w80/tn.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
  ]),
  GroupData(name: 'G', teams: [
    {'position': 1, 'team': {'name': 'Belçika', 'crest': 'https://flagcdn.com/w80/be.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 2, 'team': {'name': 'Mısır', 'crest': 'https://flagcdn.com/w80/eg.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 3, 'team': {'name': 'İran', 'crest': 'https://flagcdn.com/w80/ir.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 4, 'team': {'name': 'Yeni Zelanda', 'crest': 'https://flagcdn.com/w80/nz.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
  ]),
  GroupData(name: 'H', teams: [
    {'position': 1, 'team': {'name': 'İspanya', 'crest': 'https://flagcdn.com/w80/es.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 2, 'team': {'name': 'Yeşil Burun Adaları', 'crest': 'https://flagcdn.com/w80/cv.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 3, 'team': {'name': 'Suudi Arabistan', 'crest': 'https://flagcdn.com/w80/sa.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 4, 'team': {'name': 'Uruguay', 'crest': 'https://flagcdn.com/w80/uy.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
  ]),
  GroupData(name: 'I', teams: [
    {'position': 1, 'team': {'name': 'Fransa', 'crest': 'https://flagcdn.com/w80/fr.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 2, 'team': {'name': 'Senegal', 'crest': 'https://flagcdn.com/w80/sn.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 3, 'team': {'name': 'Irak', 'crest': 'https://flagcdn.com/w80/iq.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 4, 'team': {'name': 'Norveç', 'crest': 'https://flagcdn.com/w80/no.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
  ]),
  GroupData(name: 'J', teams: [
    {'position': 1, 'team': {'name': 'Arjantin', 'crest': 'https://flagcdn.com/w80/ar.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 2, 'team': {'name': 'Cezayir', 'crest': 'https://flagcdn.com/w80/dz.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 3, 'team': {'name': 'Avusturya', 'crest': 'https://flagcdn.com/w80/at.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 4, 'team': {'name': 'Ürdün', 'crest': 'https://flagcdn.com/w80/jo.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
  ]),
  GroupData(name: 'K', teams: [
    {'position': 1, 'team': {'name': 'Portekiz', 'crest': 'https://flagcdn.com/w80/pt.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 2, 'team': {'name': 'Kongo DC', 'crest': 'https://flagcdn.com/w80/cd.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 3, 'team': {'name': 'Özbekistan', 'crest': 'https://flagcdn.com/w80/uz.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 4, 'team': {'name': 'Kolombiya', 'crest': 'https://flagcdn.com/w80/co.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
  ]),
  GroupData(name: 'L', teams: [
    {'position': 1, 'team': {'name': 'İngiltere', 'crest': 'https://flagcdn.com/w80/gb-eng.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 2, 'team': {'name': 'Hırvatistan', 'crest': 'https://flagcdn.com/w80/hr.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 3, 'team': {'name': 'Gana', 'crest': 'https://flagcdn.com/w80/gh.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
    {'position': 4, 'team': {'name': 'Panama', 'crest': 'https://flagcdn.com/w80/pa.png'}, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'points': 0, 'goalDifference': 0},
  ]),
];

class StandingsScreen extends ConsumerWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        itemCount: _worldCup2026Groups.length,
        itemBuilder: (context, index) {
          return _GroupCard(group: _worldCup2026Groups[index], index: index);
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
                  ...group.teams.map((team) => _buildTeamRow(team)),
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
  Widget _buildTeamRow(dynamic teamData) {
    if (teamData == null || teamData is! Map) return const SizedBox.shrink();
    final int rank = int.tryParse(teamData['position']?.toString() ?? '0') ?? 0;
    final Map<String, dynamic> teamInfo = teamData['team'] is Map ? teamData['team'] : {};
    final String teamName = teamInfo['shortName']?.toString() ?? teamInfo['name']?.toString() ?? 'TBD';
    final String logoUrl = teamInfo['crest']?.toString() ?? '';
    final int played = int.tryParse(teamData['playedGames']?.toString() ?? '0') ?? 0;
    final int won = int.tryParse(teamData['won']?.toString() ?? '0') ?? 0;
    final int drawn = int.tryParse(teamData['draw']?.toString() ?? '0') ?? 0;
    final int lost = int.tryParse(teamData['lost']?.toString() ?? '0') ?? 0;
    final int points = int.tryParse(teamData['points']?.toString() ?? '0') ?? 0;
    final int goalsDiff = int.tryParse(teamData['goalDifference']?.toString() ?? '0') ?? 0;

    final isQualified = rank <= 2;
    String gd = goalsDiff > 0 ? '+$goalsDiff' : '$goalsDiff';

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
              '$rank',
              style: GoogleFonts.orbitron(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isQualified ? _accent : CyberColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Flag
          Image.network(
            logoUrl,
            width: 20,
            height: 20,
            errorBuilder: (c, e, s) => const Icon(Icons.flag, size: 20, color: Colors.white54),
          ),
          const SizedBox(width: 8),

          // Name
          Expanded(
            child: Text(
              teamName,
              overflow: TextOverflow.ellipsis,
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
          _statCell('$played', 30),
          _statCell('$won', 30),
          _statCell('$drawn', 30),
          _statCell('$lost', 30),
          _statCell(gd, 36,
              color: goalsDiff > 0
                  ? CyberColors.neonCyan.withOpacity(0.8)
                  : goalsDiff < 0
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
                '$points',
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
