#!/bin/sh
# Small Railway wrapper around the official Ghost entrypoint.
set -e

# Ghost listens on 2368 (the public domain targets it). Railway's PORT (8080 in
# the template) is a small health endpoint, see railway-health.js.
export server__port="${server__port:-2368}"
export server__host="${server__host:-::}"
if [ -n "${PORT:-}" ] && [ "$PORT" != "$server__port" ]; then
  node /usr/local/bin/railway-health.js &
fi

# Site URL: use the variable if set, else the Railway public domain.
if [ -z "${url:-}" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
  export url="https://${RAILWAY_PUBLIC_DOMAIN}"
fi

# MySQL is the only production database Ghost supports.
export database__client="${database__client:-mysql}"

# Staff device verification emails a code at every new login. It needs SMTP,
# which this template doesn't configure, so it's off unless you turn it on.
export security__staffDeviceVerification="${security__staffDeviceVerification:-false}"

# Wait up to 2 minutes for MySQL, so a first deploy doesn't crash while the
# database is still starting.
if [ -n "${database__connection__host:-}" ]; then
  node -e '
    const net = require("net");
    const host = process.env.database__connection__host;
    const port = Number(process.env.database__connection__port || 3306);
    const end = Date.now() + 120000;
    (function attempt() {
      const s = net.connect({ host, port }, () => { s.end(); process.exit(0); });
      s.on("error", () => {
        if (Date.now() > end) { console.error("MySQL not reachable at " + host + ":" + port + ", starting Ghost anyway"); process.exit(0); }
        setTimeout(attempt, 2000);
      });
    })();
  '
fi

# Hand over to the official entrypoint (fixes volume ownership, drops to the node user).
exec docker-entrypoint.sh "$@"
