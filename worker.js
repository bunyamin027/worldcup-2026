export default {
  async fetch(request, env, ctx) {
    return new Response('World Cup 2026 Proxy Worker is running!', {
      headers: { 'content-type': 'text/plain' },
    });
  },
};
