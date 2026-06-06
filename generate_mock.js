const fs = require('fs');

const teams = [
  'USA', 'Mexico', 'Canada', 'Argentina', 'Brazil', 'France', 'England', 'Spain',
  'Germany', 'Portugal', 'Italy', 'Netherlands', 'Belgium', 'Croatia', 'Uruguay', 'Colombia',
  'Japan', 'South Korea', 'Iran', 'Australia', 'Senegal', 'Morocco', 'Nigeria', 'Egypt',
  'Saudi Arabia', 'Qatar', 'Ecuador', 'Peru', 'Chile', 'Sweden', 'Switzerland', 'Denmark',
  'Serbia', 'Poland', 'Wales', 'Scotland', 'Ukraine', 'Turkey', 'Hungary', 'Austria',
  'Czechia', 'Greece', 'Ivory Coast', 'Ghana', 'Cameroon', 'Mali', 'Algeria', 'Tunisia'
];

// Re-arrange to force Group D: USA, Australia, Paraguay, Turkey
// And maybe some interesting teams in Group A, etc.
const customGroups = {
  "GROUP_A": ["Brazil", "Scotland", "Ecuador", "Japan"],
  "GROUP_B": ["England", "Iran", "USA", "Wales"], // Randomly keeping some
  "GROUP_C": ["Argentina", "Saudi Arabia", "Mexico", "Poland"],
  "GROUP_D": ["USA", "Australia", "Paraguay", "Turkey"], // From the user's image! (Note ABD = USA, Avustralya = Australia, Paraguay, Turkiye)
  "GROUP_E": ["Spain", "Costa Rica", "Germany", "Japan"],
  "GROUP_F": ["Belgium", "Canada", "Morocco", "Croatia"],
  "GROUP_G": ["Brazil", "Serbia", "Switzerland", "Cameroon"],
  "GROUP_H": ["Portugal", "Ghana", "Uruguay", "South Korea"],
  "GROUP_I": ["Italy", "Nigeria", "Colombia", "Sweden"],
  "GROUP_J": ["Netherlands", "Senegal", "Chile", "Austria"],
  "GROUP_K": ["France", "Peru", "Denmark", "Tunisia"],
  "GROUP_L": ["Mexico", "Mali", "Greece", "Algeria"],
};

const standings = [];
const letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"];

for (let i = 0; i < 12; i++) {
  const groupName = `GROUP_${letters[i]}`;
  const groupTeams = customGroups[groupName];
  
  const table = groupTeams.map((teamName, index) => ({
    position: index + 1,
    team: {
      name: teamName,
      shortName: teamName.substring(0, 3).toUpperCase(),
      crest: "" 
    },
    playedGames: 0,
    won: 0,
    draw: 0,
    lost: 0,
    points: 0,
    goalDifference: 0
  }));

  standings.push({
    stage: "GROUP_STAGE",
    type: "TOTAL",
    group: groupName,
    table: table
  });
}

// Generate Fixtures (Matches)
const matches = [];
let matchId = 1000;

// Hardcode Group D exactly as user's screenshot
const groupDFixtures = [
  { id: matchId++, utcDate: "2026-06-13T04:00:00Z", status: "TIMED", homeTeam: { name: "USA", shortName: "ABD" }, awayTeam: { name: "Paraguay", shortName: "PAR" }, venue: "Los Angeles Stadyumu", group: "D Grubu" },
  { id: matchId++, utcDate: "2026-06-14T07:00:00Z", status: "TIMED", homeTeam: { name: "Australia", shortName: "AVU" }, awayTeam: { name: "Turkey", shortName: "TÜR" }, venue: "Vancouver Stadyumu", group: "D Grubu" },
  { id: matchId++, utcDate: "2026-06-20T01:00:00Z", status: "TIMED", homeTeam: { name: "USA", shortName: "ABD" }, awayTeam: { name: "Australia", shortName: "AVU" }, venue: "Seattle Stadyumu", group: "D Grubu" },
  { id: matchId++, utcDate: "2026-06-20T06:00:00Z", status: "TIMED", homeTeam: { name: "Turkey", shortName: "TÜR" }, awayTeam: { name: "Paraguay", shortName: "PAR" }, venue: "San Francisco Stadyumu", group: "D Grubu" },
  { id: matchId++, utcDate: "2026-06-26T05:00:00Z", status: "TIMED", homeTeam: { name: "Paraguay", shortName: "PAR" }, awayTeam: { name: "Australia", shortName: "AVU" }, venue: "San Francisco Stadyumu", group: "D Grubu" },
  { id: matchId++, utcDate: "2026-06-26T05:00:00Z", status: "TIMED", homeTeam: { name: "Turkey", shortName: "TÜR" }, awayTeam: { name: "USA", shortName: "ABD" }, venue: "Los Angeles Stadyumu", group: "D Grubu" },
];
matches.push(...groupDFixtures);

// Add some generic matches for Group A to fill up the list
const groupAFixtures = [
  { id: matchId++, utcDate: "2026-06-11T19:00:00Z", status: "TIMED", homeTeam: { name: "Brazil", shortName: "BRA" }, awayTeam: { name: "Scotland", shortName: "SCO" }, venue: "Azteca Stadyumu", group: "A Grubu" },
  { id: matchId++, utcDate: "2026-06-12T15:00:00Z", status: "TIMED", homeTeam: { name: "Ecuador", shortName: "ECU" }, awayTeam: { name: "Japan", shortName: "JPN" }, venue: "Guadalajara Stadyumu", group: "A Grubu" },
];
matches.push(...groupAFixtures);

const workerCode = `const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, HEAD, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

const MOCK_FIXTURES = {
  "matches": ${JSON.stringify(matches, null, 2)}
};

const MOCK_STANDINGS = {
  "standings": ${JSON.stringify(standings, null, 2)}
};

export default {
  async fetch(request, env, ctx) {
    if (request.method === "OPTIONS") {
      return new Response(null, { headers: CORS_HEADERS });
    }

    const url = new URL(request.url);

    if (url.pathname === "/") {
      return new Response("World Cup 2026 Ultimate Mock API Worker is running!", {
        status: 200,
        headers: { ...CORS_HEADERS, "Content-Type": "text/plain" },
      });
    }

    if (url.pathname === "/fixtures") {
      return new Response(JSON.stringify(MOCK_FIXTURES), {
        status: 200,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" }
      });
    }

    if (url.pathname === "/standings") {
      return new Response(JSON.stringify(MOCK_STANDINGS), {
        status: 200,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" }
      });
    }

    return new Response("Not Found", { 
      status: 404, 
      headers: { ...CORS_HEADERS, "Content-Type": "text/plain" } 
    });
  }
};
`;

fs.writeFileSync('cloudflare/worker.js', workerCode);
console.log('Worker generated successfully.');
