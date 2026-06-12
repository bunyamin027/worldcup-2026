const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, HEAD, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

const MOCK_FIXTURES = {
  "matches": [
  {
    "id": 1000,
    "utcDate": "2026-06-13T04:00:00Z",
    "status": "TIMED",
    "homeTeam": {
      "name": "USA",
      "shortName": "ABD"
    },
    "awayTeam": {
      "name": "Paraguay",
      "shortName": "PAR"
    },
    "venue": "Los Angeles Stadyumu",
    "group": "D Grubu"
  },
  {
    "id": 1001,
    "utcDate": "2026-06-14T07:00:00Z",
    "status": "TIMED",
    "homeTeam": {
      "name": "Australia",
      "shortName": "AVU"
    },
    "awayTeam": {
      "name": "Turkey",
      "shortName": "TÜR"
    },
    "venue": "Vancouver Stadyumu",
    "group": "D Grubu"
  },
  {
    "id": 1002,
    "utcDate": "2026-06-20T01:00:00Z",
    "status": "TIMED",
    "homeTeam": {
      "name": "USA",
      "shortName": "ABD"
    },
    "awayTeam": {
      "name": "Australia",
      "shortName": "AVU"
    },
    "venue": "Seattle Stadyumu",
    "group": "D Grubu"
  },
  {
    "id": 1003,
    "utcDate": "2026-06-20T06:00:00Z",
    "status": "TIMED",
    "homeTeam": {
      "name": "Turkey",
      "shortName": "TÜR"
    },
    "awayTeam": {
      "name": "Paraguay",
      "shortName": "PAR"
    },
    "venue": "San Francisco Stadyumu",
    "group": "D Grubu"
  },
  {
    "id": 1004,
    "utcDate": "2026-06-26T05:00:00Z",
    "status": "TIMED",
    "homeTeam": {
      "name": "Paraguay",
      "shortName": "PAR"
    },
    "awayTeam": {
      "name": "Australia",
      "shortName": "AVU"
    },
    "venue": "San Francisco Stadyumu",
    "group": "D Grubu"
  },
  {
    "id": 1005,
    "utcDate": "2026-06-26T05:00:00Z",
    "status": "TIMED",
    "homeTeam": {
      "name": "Turkey",
      "shortName": "TÜR"
    },
    "awayTeam": {
      "name": "USA",
      "shortName": "ABD"
    },
    "venue": "Los Angeles Stadyumu",
    "group": "D Grubu"
  },
  {
    "id": 1006,
    "utcDate": "2026-06-11T19:00:00Z",
    "status": "TIMED",
    "homeTeam": {
      "name": "Brazil",
      "shortName": "BRA"
    },
    "awayTeam": {
      "name": "Scotland",
      "shortName": "SCO"
    },
    "venue": "Azteca Stadyumu",
    "group": "A Grubu"
  },
  {
    "id": 1007,
    "utcDate": "2026-06-12T15:00:00Z",
    "status": "TIMED",
    "homeTeam": {
      "name": "Ecuador",
      "shortName": "ECU"
    },
    "awayTeam": {
      "name": "Japan",
      "shortName": "JPN"
    },
    "venue": "Guadalajara Stadyumu",
    "group": "A Grubu"
  }
]
};

const MOCK_STANDINGS = {
  "standings": [
  {
    "stage": "GROUP_STAGE",
    "type": "TOTAL",
    "group": "GROUP_A",
    "table": [
      {
        "position": 1,
        "team": {
          "name": "Brazil",
          "shortName": "BRA",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 2,
        "team": {
          "name": "Scotland",
          "shortName": "SCO",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 3,
        "team": {
          "name": "Ecuador",
          "shortName": "ECU",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 4,
        "team": {
          "name": "Japan",
          "shortName": "JAP",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      }
    ]
  },
  {
    "stage": "GROUP_STAGE",
    "type": "TOTAL",
    "group": "GROUP_B",
    "table": [
      {
        "position": 1,
        "team": {
          "name": "England",
          "shortName": "ENG",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 2,
        "team": {
          "name": "Iran",
          "shortName": "IRA",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 3,
        "team": {
          "name": "USA",
          "shortName": "USA",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 4,
        "team": {
          "name": "Wales",
          "shortName": "WAL",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      }
    ]
  },
  {
    "stage": "GROUP_STAGE",
    "type": "TOTAL",
    "group": "GROUP_C",
    "table": [
      {
        "position": 1,
        "team": {
          "name": "Argentina",
          "shortName": "ARG",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 2,
        "team": {
          "name": "Saudi Arabia",
          "shortName": "SAU",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 3,
        "team": {
          "name": "Mexico",
          "shortName": "MEX",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 4,
        "team": {
          "name": "Poland",
          "shortName": "POL",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      }
    ]
  },
  {
    "stage": "GROUP_STAGE",
    "type": "TOTAL",
    "group": "GROUP_D",
    "table": [
      {
        "position": 1,
        "team": {
          "name": "USA",
          "shortName": "USA",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 2,
        "team": {
          "name": "Australia",
          "shortName": "AUS",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 3,
        "team": {
          "name": "Paraguay",
          "shortName": "PAR",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 4,
        "team": {
          "name": "Turkey",
          "shortName": "TUR",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      }
    ]
  },
  {
    "stage": "GROUP_STAGE",
    "type": "TOTAL",
    "group": "GROUP_E",
    "table": [
      {
        "position": 1,
        "team": {
          "name": "Spain",
          "shortName": "SPA",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 2,
        "team": {
          "name": "Costa Rica",
          "shortName": "COS",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 3,
        "team": {
          "name": "Germany",
          "shortName": "GER",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 4,
        "team": {
          "name": "Japan",
          "shortName": "JAP",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      }
    ]
  },
  {
    "stage": "GROUP_STAGE",
    "type": "TOTAL",
    "group": "GROUP_F",
    "table": [
      {
        "position": 1,
        "team": {
          "name": "Belgium",
          "shortName": "BEL",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 2,
        "team": {
          "name": "Canada",
          "shortName": "CAN",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 3,
        "team": {
          "name": "Morocco",
          "shortName": "MOR",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 4,
        "team": {
          "name": "Croatia",
          "shortName": "CRO",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      }
    ]
  },
  {
    "stage": "GROUP_STAGE",
    "type": "TOTAL",
    "group": "GROUP_G",
    "table": [
      {
        "position": 1,
        "team": {
          "name": "Brazil",
          "shortName": "BRA",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 2,
        "team": {
          "name": "Serbia",
          "shortName": "SER",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 3,
        "team": {
          "name": "Switzerland",
          "shortName": "SWI",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 4,
        "team": {
          "name": "Cameroon",
          "shortName": "CAM",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      }
    ]
  },
  {
    "stage": "GROUP_STAGE",
    "type": "TOTAL",
    "group": "GROUP_H",
    "table": [
      {
        "position": 1,
        "team": {
          "name": "Portugal",
          "shortName": "POR",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 2,
        "team": {
          "name": "Ghana",
          "shortName": "GHA",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 3,
        "team": {
          "name": "Uruguay",
          "shortName": "URU",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 4,
        "team": {
          "name": "South Korea",
          "shortName": "SOU",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      }
    ]
  },
  {
    "stage": "GROUP_STAGE",
    "type": "TOTAL",
    "group": "GROUP_I",
    "table": [
      {
        "position": 1,
        "team": {
          "name": "Italy",
          "shortName": "ITA",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 2,
        "team": {
          "name": "Nigeria",
          "shortName": "NIG",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 3,
        "team": {
          "name": "Colombia",
          "shortName": "COL",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 4,
        "team": {
          "name": "Sweden",
          "shortName": "SWE",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      }
    ]
  },
  {
    "stage": "GROUP_STAGE",
    "type": "TOTAL",
    "group": "GROUP_J",
    "table": [
      {
        "position": 1,
        "team": {
          "name": "Netherlands",
          "shortName": "NET",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 2,
        "team": {
          "name": "Senegal",
          "shortName": "SEN",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 3,
        "team": {
          "name": "Chile",
          "shortName": "CHI",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 4,
        "team": {
          "name": "Austria",
          "shortName": "AUS",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      }
    ]
  },
  {
    "stage": "GROUP_STAGE",
    "type": "TOTAL",
    "group": "GROUP_K",
    "table": [
      {
        "position": 1,
        "team": {
          "name": "France",
          "shortName": "FRA",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 2,
        "team": {
          "name": "Peru",
          "shortName": "PER",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 3,
        "team": {
          "name": "Denmark",
          "shortName": "DEN",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 4,
        "team": {
          "name": "Tunisia",
          "shortName": "TUN",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      }
    ]
  },
  {
    "stage": "GROUP_STAGE",
    "type": "TOTAL",
    "group": "GROUP_L",
    "table": [
      {
        "position": 1,
        "team": {
          "name": "Mexico",
          "shortName": "MEX",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 2,
        "team": {
          "name": "Mali",
          "shortName": "MAL",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 3,
        "team": {
          "name": "Greece",
          "shortName": "GRE",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      },
      {
        "position": 4,
        "team": {
          "name": "Algeria",
          "shortName": "ALG",
          "crest": ""
        },
        "playedGames": 0,
        "won": 0,
        "draw": 0,
        "lost": 0,
        "points": 0,
        "goalDifference": 0
      }
    ]
  }
]
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


    return new Response("Not Found", { 
      status: 404, 
      headers: { ...CORS_HEADERS, "Content-Type": "text/plain" } 
    });
  }
};
