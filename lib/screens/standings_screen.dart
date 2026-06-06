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
class StandingsScreen extends ConsumerWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(standingsProvider);

    return Scaffold(
      backgroundColor: CyberColors.background,
      body: standingsAsync.when(
        loading: () => const Center(
          child: NeonLoadingIndicator(label: 'PUAN DURUMU YÜKLENİYOR...'),
        ),
        error: (e, st) => NeonErrorWidget(
          message: e.toString(),
          prefix: 'VERİ HATASI',
          onRetry: () => ref.refresh(standingsProvider),
        ),
        data: (standingsData) {
          if (standingsData.isEmpty) {
            return Center(
              child: Text(
                'PUAN DURUMU BULUNAMADI',
                style: GoogleFonts.orbitron(color: CyberColors.textSecondary),
              ),
            );
          }
          
          final List<GroupData> groups = standingsData.map((groupObj) {
            final String rawGroupName = groupObj['group'] ?? '';
            final String groupName = rawGroupName.replaceAll('GROUP_', '');
            final List<dynamic> teams = groupObj['table'] ?? [];
            return GroupData(name: groupName, teams: teams);
          }).toList();

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return _GroupCard(group: groups[index], index: index);
            },
          );
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
    final int rank = teamData['position'] ?? 0;
    final teamInfo = teamData['team'] ?? {};
    final String teamName = teamInfo['name'] ?? 'TBD';
    final String logoUrl = teamInfo['crest'] ?? '';
    final int played = teamData['playedGames'] ?? 0;
    final int won = teamData['won'] ?? 0;
    final int drawn = teamData['draw'] ?? 0;
    final int lost = teamData['lost'] ?? 0;
    final int points = teamData['points'] ?? 0;
    final int goalsDiff = teamData['goalDifference'] ?? 0;

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
