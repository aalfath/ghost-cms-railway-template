# Ghost, packaged for Railway. Upstream image pinned by version and digest.
FROM ghost:6.77.0@sha256:2e3ca97643ea2a8cde6d0c97fae15ff39bfb60714f5abaab3f65263a2ed7c2a7

COPY railway-start.sh /usr/local/bin/railway-start.sh
RUN chmod +x /usr/local/bin/railway-start.sh

# Ghost listens on Railway's PORT (2368 by default, same as upstream).
EXPOSE 2368
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
CMD ["node", "current/index.js"]
