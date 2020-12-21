#!/usr/bin/env sh

UMASK_SET=${UMASK_SET:-022}

CONFD=$(which confd)
GOSU=$(which gosu)
CADDY=$(which caddy)

if [[ ! -x ${CONFD} ]]; then
  echo "confd binary not found"
  exit 1
fi

if [[ ! -x ${GOSU} ]]; then
  echo "gosu binary not found"
  exit 1
fi

if [[ ! -x $CADDY ]]; then
  echo "caddy binary not found"
  exit 1
fi

echo umask "$UMASK_SET"
umask "$UMASK_SET" || exit 1

echo ${CONFD} -onetime -backend env -log-level debug
${CONFD} -onetime -backend env -log-level debug || exit 1

CADDY_CONFIG=${CADDY_CONFIG:-/etc/caddy/Caddyfile}

echo ${*:-${CADDY} run --config ${CADDY_CONFIG} --adapter caddyfile}
exec ${*:-${CADDY} run --config ${CADDY_CONFIG} --adapter caddyfile}
