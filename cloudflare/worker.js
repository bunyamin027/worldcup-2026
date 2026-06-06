const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, HEAD, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

export default {
  async fetch(request, env, ctx) {
    if (request.method === "OPTIONS") {
      return new Response(null, { headers: CORS_HEADERS });
    }

    const url = new URL(request.url);

    if (url.pathname === "/") {
      return new Response("World Cup 2026 Proxy Worker is running!", {
        status: 200,
        headers: {
          ...CORS_HEADERS,
          "Content-Type": "text/plain",
        },
      });
    }

    if (url.pathname === "/fixtures") {
      const league = url.searchParams.get("league") || "1";
      const season = url.searchParams.get("season") || "2026";
      
      const cacheKey = `fixtures_${league}_${season}`;
      
      const cachedData = await env.KV.get(cacheKey);
      if (cachedData) {
        return new Response(cachedData, {
          status: 200,
          headers: {
            ...CORS_HEADERS,
            "Content-Type": "application/json",
            "X-Cache": "HIT"
          }
        });
      }

      const apiUrl = `https://v3.football.api-sports.io/fixtures?league=${league}&season=${season}`;
      
      try {
        const apiResponse = await fetch(apiUrl, {
          headers: {
            "x-apisports-key": env.API_KEY
          }
        });

        if (!apiResponse.ok) {
          return new Response(JSON.stringify({ error: "API-Sports request failed", status: apiResponse.status }), {
            status: apiResponse.status,
            headers: { ...CORS_HEADERS, "Content-Type": "application/json" }
          });
        }

        const data = await apiResponse.text();
        
        ctx.waitUntil(env.KV.put(cacheKey, data, { expirationTtl: 43200 }));

        return new Response(data, {
          status: 200,
          headers: {
            ...CORS_HEADERS,
            "Content-Type": "application/json",
            "X-Cache": "MISS"
          }
        });
      } catch (error) {
        return new Response(JSON.stringify({ error: "Internal Server Error", details: error.message }), {
          status: 500,
          headers: { ...CORS_HEADERS, "Content-Type": "application/json" }
        });
      }
    }

    if (url.pathname === "/standings") {
      const cacheKey = "wc_standings_2026_v2";
      
      const cachedData = await env.KV.get(cacheKey);
      if (cachedData) {
        return new Response(cachedData, {
          status: 200,
          headers: {
            ...CORS_HEADERS,
            "Content-Type": "application/json",
            "X-Cache": "HIT"
          }
        });
      }

      const apiUrl = "https://api.football-data.org/v4/competitions/WC/standings";
      
      try {
        const apiResponse = await fetch(apiUrl, {
          headers: {
            "X-Auth-Token": env.API_KEY
          }
        });

        if (!apiResponse.ok) {
          return new Response(JSON.stringify({ error: "Football-data API request failed", status: apiResponse.status }), {
            status: apiResponse.status,
            headers: { ...CORS_HEADERS, "Content-Type": "application/json" }
          });
        }

        const data = await apiResponse.text();
        
        ctx.waitUntil(env.KV.put(cacheKey, data, { expirationTtl: 43200 }));

        return new Response(data, {
          status: 200,
          headers: {
            ...CORS_HEADERS,
            "Content-Type": "application/json",
            "X-Cache": "MISS"
          }
        });
      } catch (error) {
        return new Response(JSON.stringify({ error: "Internal Server Error", details: error.message }), {
          status: 500,
          headers: { ...CORS_HEADERS, "Content-Type": "application/json" }
        });
      }
    }

    return new Response("Not Found", { 
      status: 404, 
      headers: { ...CORS_HEADERS, "Content-Type": "text/plain" } 
    });
  }
};
