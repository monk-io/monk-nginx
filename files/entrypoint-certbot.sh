#!/usr/bin/env sh

if [ "${USE_CERTBOT}" = "true" ]; then
  while :; do
    echo "$(date) Waiting for nginx to start"
    nc -vz "${NGINX_HOST}" 80 2>/dev/null
    if [ "${?}" -eq 0 ]; then
      break
    fi
    sleep 1
  done

  while :; do
    certbot certonly \
      --webroot -w /var/certbot \
      --force-renewal \
      --email {{ v "email" }} \
      -d {{ v "domain" }} \
      --agree-tos \
      --non-interactive \
      -v

    sleep 24h
  done
else
  sleep infinite
fi
