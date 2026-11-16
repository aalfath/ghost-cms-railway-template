// Health endpoint for Railway's health check.
//
// Ghost redirects every plain-HTTP request to https when its `url` is https,
// and Railway's health check probe sends plain HTTP without X-Forwarded-Proto,
// so it would only ever see a 301. This tiny server listens on PORT, asks
// Ghost's /ghost/api/admin/site/ on its own port as if over https, and answers
// with Ghost's status code (503 when Ghost isn't up yet).
const http = require('http');

const listenPort = Number(process.env.PORT || 8080);
const ghostPort = Number(process.env.server__port || 2368);

http.createServer((req, res) => {
  const probe = http.get({
    host: '127.0.0.1',
    port: ghostPort,
    path: '/ghost/api/admin/site/',
    headers: { 'X-Forwarded-Proto': 'https' },
    timeout: 5000
  }, (r) => {
    r.resume();
    res.writeHead(r.statusCode === 200 ? 200 : 503, { 'Content-Type': 'text/plain' });
    res.end(r.statusCode === 200 ? 'ok\n' : `ghost answered ${r.statusCode}\n`);
  });
  probe.on('timeout', () => probe.destroy(new Error('timeout')));
  probe.on('error', (e) => {
    res.writeHead(503, { 'Content-Type': 'text/plain' });
    res.end(`ghost not reachable: ${e.message}\n`);
  });
}).listen(listenPort, '::');
