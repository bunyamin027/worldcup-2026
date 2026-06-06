async function run() {
  const res = await fetch("https://worldcup-2026.bunyaminkahraman027.workers.dev/standings");
  const data = await res.text();
  console.log(data.slice(0, 500));
}
run();
