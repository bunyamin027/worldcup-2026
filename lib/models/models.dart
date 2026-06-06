class Fixture {
  final int id;
  final DateTime date;
  final Team homeTeam;
  final Team awayTeam;
  final int? homeScore;
  final int? awayScore;
  final int? elapsed;
  final String status;

  Fixture({
    required this.id,
    required this.date,
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore,
    this.awayScore,
    this.elapsed,
    required this.status,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    final fixture = json['fixture'];
    final teams = json['teams'];
    final goals = json['goals'];

    return Fixture(
      id: fixture['id'],
      date: DateTime.parse(fixture['date']),
      homeTeam: Team.fromJson(teams['home']),
      awayTeam: Team.fromJson(teams['away']),
      homeScore: goals['home'],
      awayScore: goals['away'],
      elapsed: fixture['status']['elapsed'],
      status: fixture['status']['short'],
    );
  }
}

class Team {
  final int id;
  final String name;
  final String logo;

  Team({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
    );
  }
}

class Standing {
  final int rank;
  final Team team;
  final int points;
  final int goalsDiff;
  final String group;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;

  Standing({
    required this.rank,
    required this.team,
    required this.points,
    required this.goalsDiff,
    required this.group,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
  });

  factory Standing.fromJson(Map<String, dynamic> json) {
    return Standing(
      rank: json['rank'],
      team: Team.fromJson(json['team']),
      points: json['points'],
      goalsDiff: json['goalsDiff'],
      group: json['group'],
      played: json['all']['played'],
      won: json['all']['win'],
      drawn: json['all']['draw'],
      lost: json['all']['lose'],
      goalsFor: json['all']['goals']['for'],
      goalsAgainst: json['all']['goals']['against'],
    );
  }
}
