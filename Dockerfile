FROM caddy:2.2.1-builder AS builder

RUN xcaddy build \
    --with github.com/greenpau/caddy-auth-portal \
    --with github.com/greenpau/caddy-auth-jwt \
    --with github.com/hairyhenderson/caddy-teapot-module@v0.0.3-0

FROM caddy:2.2.1

MAINTAINER Andrew Cole <andrew.cole@illallangi.com>


COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY contrib/confd-0.16.0-linux-amd64 /usr/local/bin/confd
COPY contrib/dumb-init_1.2.2_amd64 /usr/local/bin/dumb-init
COPY contrib/gosu_1.12_amd64 /usr/local/bin/gosu
COPY entrypoint.sh /entrypoint.sh
COPY confd/ /etc/confd/

RUN chmod +x \
        /entrypoint.sh \
        /usr/local/bin/confd \
        /usr/local/bin/dumb-init \
        /usr/local/bin/gosu

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/entrypoint.sh"]

ARG VCS_REF
ARG VERSION
ARG BUILD_DATE
LABEL maintainer="Andrew Cole <andrew.cole@illallangi.com>" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.description="Deluge Daemn" \
      org.label-schema.name="DelugeDaemn" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url="http://github.com/illallangi/DelugeDaemn" \
      org.label-schema.usage="https://github.com/illallangi/DelugeDaemn/blob/master/README.md" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/illallangi/DelugeDaemn" \
      org.label-schema.vendor="Illallangi Enterprises" \
      org.label-schema.version=$VERSION
