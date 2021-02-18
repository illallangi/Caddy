FROM caddy:2.2.1-builder AS caddy

RUN xcaddy build \
    --with github.com/greenpau/caddy-auth-portal \
    --with github.com/greenpau/caddy-auth-jwt \
    --with github.com/hairyhenderson/caddy-teapot-module@v0.0.3-0


FROM caddy:2.2.1

MAINTAINER Andrew Cole <andrew.cole@illallangi.com>

COPY --from=caddy /usr/bin/caddy /usr/bin/caddy

ARG VCS_REF
ARG VERSION
ARG BUILD_DATE
LABEL maintainer="Andrew Cole <andrew.cole@illallangi.com>" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.description="Caddy" \
      org.label-schema.name="Caddy" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url="http://github.com/illallangi/Caddy" \
      org.label-schema.usage="https://github.com/illallangi/Caddy/blob/master/README.md" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/illallangi/Caddy" \
      org.label-schema.vendor="Illallangi Enterprises" \
      org.label-schema.version=$VERSION
