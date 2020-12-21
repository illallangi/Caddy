#!/usr/bin/env sh

UMASK_SET=${UMASK_SET:-022}
CADDY_CONFIG=${CADDY_CONFIG:-/etc/caddy/Caddyfile}

CADDY=$(which caddy)
CONFD=$(which confd)
CFSSL=$(which cfssl)
CFSSLJSON=$(which cfssljson)

echo "-----"
echo "Generating Configuration Files"
echo ${CONFD} -onetime -backend env -log-level debug
${CONFD} -onetime -backend env -log-level debug || exit 1
echo "-----"

if [ -f /etc/caddy/tls.crt ]; then
  echo "-----"
  echo "Using supplied certificate"
else
  echo "Generating certificate"
  echo "-----"  
  
  echo ${CFSSL} gencert -initca /etc/caddy/ca.json \| ${CFSSLJSON} -bare /etc/caddy/ca
  ${CFSSL} gencert -initca /etc/caddy/ca.json | ${CFSSLJSON} -bare /etc/caddy/ca || exit 1
  
  echo ${CFSSL} gencert -ca /etc/caddy/ca.pem -ca-key /etc/caddy/ca-key.pem -config /etc/caddy/cfssl.json -profile=server /etc/caddy/tls.json \| ${CFSSLJSON} -bare /etc/caddy/tls
  ${CFSSL} gencert -ca /etc/caddy/ca.pem -ca-key /etc/caddy/ca-key.pem -config /etc/caddy/cfssl.json -profile=server /etc/caddy/tls.json | ${CFSSLJSON} -bare /etc/caddy/tls || exit 1
  
  ln -s /etc/caddy/tls.pem /etc/caddy/tls.crt
  ln -s /etc/caddy/tls-key.pem /etc/caddy/tls.key
fi

if [[ -x "/usr/local/bin/make-proxy-dirs.sh" ]]
then
  echo "Creating proxy and redirect directories"
  /usr/local/bin/make-proxy-dirs.sh
  echo "-----"
fi

echo "Checking Syntax"
cat ${CADDY_CONFIG}
echo ${CADDY} validate --config ${CADDY_CONFIG} --adapter caddyfile
${CADDY} validate --config ${CADDY_CONFIG} --adapter caddyfile || exit 1
echo "-----"

echo ${*:-${CADDY} run --config ${CADDY_CONFIG} --adapter caddyfile}
exec ${*:-${CADDY} run --config ${CADDY_CONFIG} --adapter caddyfile}