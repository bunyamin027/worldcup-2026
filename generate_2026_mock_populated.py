import json
import datetime
import random

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

start_date = datetime.datetime(2026, 6, 11, 22, 0)
current_time = datetime.datetime.now()

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

round_pairs = [
    (0, 1), (2, 3), # Matchday 1
    (0, 2), (1, 3), # Matchday 2
    (0, 3), (1, 2)  # Matchday 3
]
matchday_offsets = [0, 1, 5, 6, 10, 11]

# Seed random so results are consistent across generations
random.seed(42)

for i, (p1, p2) in enumerate(round_pairs):
    for g_idx, (g_name, teams) in enumerate(groups.items()):
        t1 = teams[p1]
        t2 = teams[p2]
        
        if g_name == 'A' and p1 == 0 and p2 == 1:
            m_time = datetime.datetime(2026, 6, 11, 22, 0)
        elif g_name == 'A' and p1 == 2 and p2 == 3:
            m_time = datetime.datetime(2026, 6, 12, 5, 0)
        else:
            days_offset = matchday_offsets[i] + (g_idx // 3)
            hour = 16 + (g_idx % 3) * 3
            m_time = datetime.datetime(2026, 6, 11) + datetime.timedelta(days=days_offset, hours=hour)
            
        group_id = f"GROUP_{g_name}"
        status = 'TIMED'
        s1, s2 = 0, 0
        
        if m_time < current_time:
            status = 'FINISHED'
            s1 = random.randint(0, 3)
            s2 = random.randint(0, 3)
            
            st1 = standings_dict[group_id][t1]
            st2 = standings_dict[group_id][t2]
            
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

        api_fixtures.append({
            'id': match_id,
            'utcDate': m_time.isoformat() + "Z",
            'status': status,
            'homeTeam': {'name': t1, 'shortName': t1[:3].upper()},
            'awayTeam': {'name': t2, 'shortName': t2[:3].upper()},
            'score': {'ft': [s1, s2]} if status == 'FINISHED' else {'ft': [0, 0]},
            'group': group_id
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

with open('worker.js', 'w', encoding='utf-8') as f:
    f.write('''const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, HEAD, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

const MOCK_FIXTURES = {
  "matches": ''')
    f.write(json.dumps(api_fixtures, indent=2, ensure_ascii=False))
    f.write('''
};

const MOCK_STANDINGS = {
  "standings": ''')
    f.write(json.dumps(api_standings, indent=2, ensure_ascii=False))
    f.write('''
};

export default {
  async fetch(request, env, ctx) {
    if (request.method === "OPTIONS") {
      return new Response(null, { headers: CORS_HEADERS });
    }

    const url = new URL(request.url);

    if (url.pathname === "/") {
      return new Response("World Cup 2026 Mock API Worker", {
        status: 200,
        headers: { ...CORS_HEADERS, "Content-Type": "text/plain" },
      });
    }

    if (url.pathname === "/fixtures") {
      return new Response(JSON.stringify(MOCK_FIXTURES), {
        status: 200,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json; charset=utf-8" }
      });
    }

    if (url.pathname === "/standings") {
      return new Response(JSON.stringify(MOCK_STANDINGS), {
        status: 200,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json; charset=utf-8" }
      });
    }

    return new Response("Not Found", { 
      status: 404, 
      headers: { ...CORS_HEADERS, "Content-Type": "text/plain" } 
    });
  }
};
''')

print("Worker generated in worker.js with proper 2026 simulated points!")
