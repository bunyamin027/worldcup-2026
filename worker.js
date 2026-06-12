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
      return new Response("Global Football Proxy Worker is running!", {
        status: 200,
        headers: {
          ...CORS_HEADERS,
          "Content-Type": "text/plain",
        },
      });
    }

    // Ortak KV ve Cache referansı
    const kvStorage = env.KV || env.CACHE;

    // API KEY kontrolü
    if (!env.API_KEY && (url.pathname === "/fixtures" || url.pathname === "/standings")) {
      return new Response(JSON.stringify({ error: "Cloudflare Settings'te API_KEY tanımlanmamış!" }), {
        status: 500,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" }
      });
    }

    if (url.pathname === "/fixtures") {
      const cacheKey = "wc_fixtures_2026_v2";
      
      if (kvStorage) {
        try {
          const cachedData = await kvStorage.get(cacheKey);
          if (cachedData) {
            return new Response(cachedData, {
              status: 200,
              headers: { ...CORS_HEADERS, "Content-Type": "application/json", "X-Cache": "HIT" }
            });
          }
        } catch (e) { console.log(e); }
      }

      const apiUrl = "https://api.football-data.org/v4/competitions/2000/matches";
      try {
        const apiResponse = await fetch(apiUrl, { headers: { "X-Auth-Token": env.API_KEY } });
        if (!apiResponse.ok) throw new Error("API Request Failed: " + apiResponse.status);
        const data = await apiResponse.text();
        if (kvStorage) ctx.waitUntil(kvStorage.put(cacheKey, data, { expirationTtl: 43200 }).catch(e=>e));
        return new Response(data, { status: 200, headers: { ...CORS_HEADERS, "Content-Type": "application/json", "X-Cache": "MISS" } });
      } catch (error) {
        return new Response(JSON.stringify({ error: "Internal Server Error", details: error.message }), { status: 500, headers: { ...CORS_HEADERS, "Content-Type": "application/json" } });
      }
    }


    return new Response("Not Found", { status: 404, headers: { ...CORS_HEADERS, "Content-Type": "text/plain" } });
  }
};
