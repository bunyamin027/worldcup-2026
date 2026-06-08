import json
import datetime

# 12 Groups for 2026 (48 teams)
groups = {
    'A': ['Meksika', 'Güney Afrika', 'Güney Kore', 'Çekya'],
    'B': ['Kanada', 'Bosna-Hersek', 'Katar', 'İsviçre'],
    'C': ['Arjantin', 'Polonya', 'Mısır', 'Yeni Zelanda'],
    'D': ['ABD', 'Avustralya', 'Paraguay', 'Türkiye'],
    'E': ['İspanya', 'Kosta Rika', 'Almanya', 'Japonya'],
    'F': ['Belçika', 'İsveç', 'Fas', 'Hırvatistan'],
    'G': ['Brezilya', 'Sırbistan', 'İskoçya', 'Kamerun'],
    'H': ['Portekiz', 'Gana', 'Uruguay', 'Şili'],
    'I': ['İtalya', 'Nijerya', 'Kolombiya', 'Galler'],
    'J': ['Hollanda', 'Senegal', 'Ekvador', 'Avusturya'],
    'K': ['Fransa', 'Peru', 'Danimarka', 'Tunus'],
    'L': ['İngiltere', 'Mali', 'Yunanistan', 'Cezayir']
}

start_date = datetime.datetime(2026, 6, 11, 22, 0) # 11/6 Per 22:00
current_time = start_date

api_fixtures = []
standings_dict = {}

match_id = 1000

for g_name, teams in groups.items():
    group_id = f"GROUP_{g_name}"
    standings_dict[group_id] = {}
    for t in teams:
        standings_dict[group_id][t] = {
            'team': {'name': t, 'shortName': t[:3].upper()},
            'points': 0, 'playedGames': 0, 'won': 0, 'draw': 0, 'lost': 0, 'goalsFor': 0, 'goalsAgainst': 0, 'goalDifference': 0
        }

# Generate fixtures (Round-robin: 1v2, 3v4, 1v3, 2v4, 1v4, 2v3)
round_pairs = [
    (0, 1), (2, 3), # Matchday 1
    (0, 2), (1, 3), # Matchday 2
    (0, 3), (1, 2)  # Matchday 3
]

matchday_offsets = [0, 1, 5, 6, 10, 11] # Day offsets for matches

for i, (p1, p2) in enumerate(round_pairs):
    for g_idx, (g_name, teams) in enumerate(groups.items()):
        t1 = teams[p1]
        t2 = teams[p2]
        
        # Calculate match time based on group and matchday to spread them out
        # Let's match the image exactly for Group A Match 1 and 2
        if g_name == 'A' and p1 == 0 and p2 == 1:
            m_time = datetime.datetime(2026, 6, 11, 22, 0)
        elif g_name == 'A' and p1 == 2 and p2 == 3:
            m_time = datetime.datetime(2026, 6, 12, 5, 0)
        else:
            days_offset = matchday_offsets[i] + (g_idx // 3) # Spread groups across days
            hour = 16 + (g_idx % 3) * 3 # 16:00, 19:00, 22:00
            m_time = datetime.datetime(2026, 6, 11) + datetime.timedelta(days=days_offset, hours=hour)
            
        api_fixtures.append({
            'id': match_id,
            'utcDate': m_time.isoformat() + "Z",
            'status': 'TIMED',
            'homeTeam': {'name': t1, 'shortName': t1[:3].upper()},
            'awayTeam': {'name': t2, 'shortName': t2[:3].upper()},
            'score': {'ft': [0, 0]}, # Not played yet
            'group': f"GROUP_{g_name}"
        })
        match_id += 1

api_fixtures.sort(key=lambda x: x['utcDate'])

api_standings = []
for group_name, teams in standings_dict.items():
    sorted_teams = sorted(teams.values(), key=lambda x: (x['points'], x['goalDifference'], x['goalsFor']), reverse=True)
    for i, t in enumerate(sorted_teams):
        t['position'] = i + 1
    api_standings.append({
        'group': group_name,
        'type': 'TOTAL',
        'table': sorted_teams
    })

with open('lib/data/mock_data.dart', 'w', encoding='utf-8') as f:
    f.write('class MockData {\n')
    f.write('  static const List<dynamic> fixtures = ')
    f.write(json.dumps(api_fixtures, indent=2, ensure_ascii=False))
    f.write(';\n\n')
    f.write('  static const List<dynamic> standings = ')
    f.write(json.dumps(api_standings, indent=2, ensure_ascii=False))
    f.write(';\n}\n')

print("Mock data generated successfully based on 2026 format.")
