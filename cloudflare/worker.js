// ─── Cloudflare Worker – API-Football Proxy with KV Cache ───────────────────
// KV Namespace binding: CACHE  (Wrangler → wrangler.toml → kv_namespaces)
// Secret env vars  : RAPIDAPI_KEY, RAPIDAPI_HOST

const CACHE_TTL = 300; // 5 dakika (saniye)
const UPSTREAM   = "https://api-football-v1.p.rapidapi.com/v3";

export default {
  /**
   * @param {Request} request
   * @param {Object}  env   – CACHE (KV), RAPIDAPI_KEY, RAPIDAPI_HOST
   * @param {Object}  ctx
   */
  async fetch(request, env, ctx) {
    // ── CORS Pre-flight ─────────────────────────────────────────────────
    if (request.method === "OPTIONS") {
      return new Response(null, { status: 204, headers: corsHeaders() });
    }

    try {
      const url = new URL(request.url);
      const endpoint = url.pathname;            // e.g. /fixtures
      const query    = url.search;              // e.g. ?league=1&season=2026
      const cacheKey = `${endpoint}${query}`;

      // ── 1. KV Cache Lookup ──────────────────────────────────────────
      const cached = await env.CACHE.get(cacheKey);
      if (cached !== null) {
        return jsonResponse(JSON.parse(cached), 200, true);
      }

      // ── 2. Upstream Fetch ───────────────────────────────────────────
      const upstreamUrl = `${UPSTREAM}${endpoint}${query}`;

      const upstreamRes = await fetch(upstreamUrl, {
        method: "GET",
        headers: {
          "X-RapidAPI-Key":  env.RAPIDAPI_KEY,
          "X-RapidAPI-Host": env.RAPIDAPI_HOST,
        },
      });

      if (!upstreamRes.ok) {
        return jsonResponse(
          { error: "Upstream error", status: upstreamRes.status },
          upstreamRes.status,
          false,
        );
      }

      const data = await upstreamRes.json();

      // ── 3. KV Cache Store (non-blocking) ────────────────────────────
      ctx.waitUntil(
        env.CACHE.put(cacheKey, JSON.stringify(data), {
          expirationTtl: CACHE_TTL,
        }),
      );

      return jsonResponse(data, 200, false);
    } catch (err) {
      return jsonResponse(
        { error: "Worker internal error", message: err.message },
        500,
        false,
      );
    }
  },
};

// ─── Helpers ─────────────────────────────────────────────────────────────────
function corsHeaders() {
  return {
    "Access-Control-Allow-Origin":  "*",
    "Access-Control-Allow-Methods": "GET, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
    "Access-Control-Max-Age":       "86400",
  };
}

function jsonResponse(body, status, fromCache) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      "Content-Type":                "application/json;charset=UTF-8",
      "Access-Control-Allow-Origin": "*",
      "X-Cache":                     fromCache ? "HIT" : "MISS",
      "Cache-Control":               "public, max-age=300",
    },
  });
}
