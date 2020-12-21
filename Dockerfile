FROM caddy:2.2.1-builder AS builder

RUN xcaddy build \
    --with github.com/greenpau/caddy-auth-portal \
    --with github.com/greenpau/caddy-auth-jwt \
    --with github.com/hairyhenderson/caddy-teapot-module@v0.0.3-0

FROM caddy:2.2.1

COPY --from=builder /usr/bin/caddy /usr/bin/caddy