import json
import datetime

with open('worldcup_2022.json', 'r') as f:
    data = json.load(f)

api_fixtures = []
standings_dict = {}

# Compute standings
for match in data.get('matches', []):
    group = match.get('group')
    if not group:
        group = 'Knockout'
    t1 = match.get('team1')
    t2 = match.get('team2')
    
    if group != 'Knockout':
        if group not in standings_dict:
            standings_dict[group] = {}
        for t in [t1, t2]:
            if t not in standings_dict[group]:
                standings_dict[group][t] = {
                    'team': {'name': t, 'shortName': t[:3].upper()},
                    'points': 0, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'goalsFor': 0, 'goalsAgainst': 0, 'goalDifference': 0
                }
        
        score_ft = match.get('score', {}).get('ft', [])
        if score_ft and len(score_ft) == 2 and isinstance(score_ft[0], int):
            s1, s2 = score_ft
            st1 = standings_dict[group][t1]
            st2 = standings_dict[group][t2]
            st1['playedGames'] += 1
            st2['playedGames'] += 1
            st1['goalsFor'] += s1
            st1['goalsAgainst'] += s2
            st2['goalsFor'] += s2
            st2['goalsAgainst'] += s1
            st1['goalDifference'] += (s1 - s2)
            st2['goalDifference'] += (s2 - s1)
            
            if s1 > s2:
                st1['won'] += 1
                st1['points'] += 3
                st2['lost'] += 1
            elif s2 > s1:
                st2['won'] += 1
                st2['points'] += 3
                st1['lost'] += 1
            else:
                st1['draw'] += 1
                st2['draw'] += 1
                st1['points'] += 1
                st2['points'] += 1

    # Format for API-Sports
    date_str = match.get('date')
    time_str = match.get('time')
    
    dt = datetime.datetime.strptime(f"{date_str} {time_str}", "%Y-%m-%d %H:%M")
    delta = datetime.datetime(2026, 6, 11) - datetime.datetime(2022, 11, 20)
    new_dt = dt + delta
    
    utc_date = new_dt.isoformat() + "Z"
    
    api_fixtures.append({
        'utcDate': utc_date,
        'homeTeam': {'name': t1, 'shortName': t1[:3].upper()},
        'awayTeam': {'name': t2, 'shortName': t2[:3].upper()},
        'score': match.get('score'),
        'group': group.replace("Group ", "GROUP_") if group else "Knockout"
    })

# Format standings to match API
api_standings = []
for group_name, teams in standings_dict.items():
    sorted_teams = sorted(teams.values(), key=lambda x: (x['points'], x['goalDifference'], x['goalsFor']), reverse=True)
    for i, t in enumerate(sorted_teams):
        t['position'] = i + 1
    # API-Sports format: list of tables, each table is a group
    api_standings.append({
        'group': group_name.replace("Group ", "GROUP_"),
        'type': 'TOTAL',
        'table': sorted_teams
    })

with open('lib/data/mock_data.dart', 'w') as f:
    f.write('class MockData {\n')
    f.write('  static const List<dynamic> fixtures = ')
    f.write(json.dumps(api_fixtures, indent=2))
    f.write(';\n\n')
    f.write('  static const List<dynamic> standings = ')
    f.write(json.dumps(api_standings, indent=2))
    f.write(';\n}\n')

print("Mock data generated in lib/data/mock_data.dart")
