# Changelog

Each entry is one version of this Railway template. Breaking changes come first.

## 2026-11-16: Ghost 6.77.0

- First repo-based version of the Ghost template (`ghost-2`). Earlier deploys ran the `ghost:6.54.0` image directly.
- Ghost 6.77.0 (`ghost:6.77.0@sha256:2e3ca97643ea2a8cde6d0c97fae15ff39bfb60714f5abaab3f65263a2ed7c2a7`), MySQL 8.4.13.
- Fix: Ghost now listens on Railway's `PORT` (2368) and the public domain targets that port. The old template's domain had no target port, so the site answered 502.
- Health check on `/ghost/api/admin/site/`.
