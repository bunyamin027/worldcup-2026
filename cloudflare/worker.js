const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, HEAD, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

const MOCK_FIXTURES = {
  "matches": [
    {
      "id": 1001,
      "utcDate": "2026-06-11T19:00:00Z",
      "status": "TIMED",
      "homeTeam": { "name": "Mexico", "shortName": "MEX", "tla": "MEX", "crest": "https://crests.football-data.org/732.svg" },
      "awayTeam": { "name": "South Africa", "shortName": "RSA", "tla": "RSA", "crest": "https://crests.football-data.org/759.svg" }
    },
    {
      "id": 1002,
      "utcDate": "2026-06-12T15:00:00Z",
      "status": "TIMED",
      "homeTeam": { "name": "USA", "shortName": "USA", "tla": "USA", "crest": "https://crests.football-data.org/773.svg" },
      "awayTeam": { "name": "Wales", "shortName": "WAL", "tla": "WAL", "crest": "https://crests.football-data.org/833.svg" }
    },
    {
      "id": 1003,
      "utcDate": "2026-06-12T19:00:00Z",
      "status": "TIMED",
      "homeTeam": { "name": "Canada", "shortName": "CAN", "tla": "CAN", "crest": "https://crests.football-data.org/811.svg" },
      "awayTeam": { "name": "Japan", "shortName": "JPN", "tla": "JPN", "crest": "https://crests.football-data.org/764.svg" }
    },
    {
      "id": 1004,
      "utcDate": "2026-06-13T16:00:00Z",
      "status": "TIMED",
      "homeTeam": { "name": "Brazil", "shortName": "BRA", "tla": "BRA", "crest": "https://crests.football-data.org/764.svg" },
      "awayTeam": { "name": "France", "shortName": "FRA", "tla": "FRA", "crest": "https://crests.football-data.org/773.svg" }
    },
    {
      "id": 1005,
      "utcDate": "2026-06-13T20:00:00Z",
      "status": "TIMED",
      "homeTeam": { "name": "Argentina", "shortName": "ARG", "tla": "ARG", "crest": "https://crests.football-data.org/762.svg" },
      "awayTeam": { "name": "Spain", "shortName": "ESP", "tla": "ESP", "crest": "https://crests.football-data.org/760.svg" }
    }
  ]
};

const MOCK_STANDINGS = {
  "standings": []
};

export default {
  async fetch(request, env, ctx) {
    if (request.method === "OPTIONS") {
      return new Response(null, { headers: CORS_HEADERS });
    }

    const url = new URL(request.url);

    if (url.pathname === "/") {
      return new Response("World Cup 2026 Mock API Worker is running!", {
        status: 200,
        headers: {
          ...CORS_HEADERS,
          "Content-Type": "text/plain",
        },
      });
    }

    if (url.pathname === "/fixtures") {
      return new Response(JSON.stringify(MOCK_FIXTURES), {
        status: 200,
        headers: {
          ...CORS_HEADERS,
          "Content-Type": "application/json",
        }
      });
    }

    if (url.pathname === "/standings") {
      return new Response(JSON.stringify(MOCK_STANDINGS), {
        status: 200,
        headers: {
          ...CORS_HEADERS,
          "Content-Type": "application/json",
        }
      });
    }

    return new Response("Not Found", { 
      status: 404, 
      headers: { ...CORS_HEADERS, "Content-Type": "text/plain" } 
    });
  }
};
