# Ghost on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/ghost-2?utm_medium=integration&utm_source=button&utm_campaign=ghost)

Railway template for [Ghost](https://ghost.org), the open-source publishing platform for blogs, newsletters and paid memberships.

## What it deploys

| Service | Source | Volume |
|---|---|---|
| Ghost | this repo: `ghost:6.77.0` pinned by digest, plus `railway-start.sh` and `railway-health.js` | `/var/lib/ghost/content` (images, themes, files) |
| MySQL | `mysql:8.4.13` | `/var/lib/mysql` |

Ghost listens on port 2368, which the public domain targets. Railway's health check probes `PORT` (8080): a small endpoint (`railway-health.js`) that answers 200 once Ghost's `/ghost/api/admin/site/` does. It's needed because Ghost redirects every plain-HTTP request to https, so a direct probe would only get a 301. Open `https://YOUR-DOMAIN/ghost/` after the first deploy to create the owner account.

## Variables

| Variable | Service | Default | Notes |
|---|---|---|---|
| `url` | Ghost | `https://${{Ghost.RAILWAY_PUBLIC_DOMAIN}}` | Site URL. Change it when you add a custom domain |
| `PORT` | Ghost | `8080` | Health endpoint port for Railway's health check (Ghost itself stays on 2368) |
| `database__*` | Ghost | references to the MySQL service | Database connection |
| `security__staffDeviceVerification` | Ghost | `false` | Set `true` only once mail works |
| `MYSQL_ROOT_PASSWORD` | MySQL | generated secret | |
| `MYSQL_DATABASE` | MySQL | `ghost` | |

Mail is optional and not set up by default. Without it Ghost sends no newsletters, staff invites or magic links. To enable it, add `mail__transport=SMTP`, `mail__options__host`, `mail__options__port`, `mail__options__secure`, `mail__options__auth__user`, `mail__options__auth__pass` and `mail__from` to the Ghost service ([Ghost mail docs](https://ghost.org/docs/config/#mail)).

## Updates

The Ghost service builds from this repo's `main` branch. When the pinned Ghost version changes here, Railway shows deployers an "update available" notice, and they choose when to apply it. Read [CHANGELOG.md](CHANGELOG.md) before applying an update. Ghost runs its database migrations on start, so back up the MySQL volume first.
