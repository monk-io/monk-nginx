#!/usr/bin/env sh
echo "$(date) Installing procps"
( apt update && apt install -y procps ) >/dev/null 2>&1

if [ "${USE_CERTBOT}" = "true" ]; then
  echo "$(date) Using certbot"

  if [ ! -d "/etc/letsencrypt/live" ]; then
    echo "$(date) Starting temporary nginx server"
    nginx -g 'daemon off;' -c /tmp/init.conf &
  fi

  while :; do
    if [ -d "/etc/letsencrypt/live" ]; then
      echo "$(date) Detected certificate killing temporary webserver"
      /usr/bin/pkill -9 nginx
      break
    fi

    sleep 1
  done

  echo "$(date) Starting webserver"
  nginx -g 'daemon off;' -c /tmp/running.conf &
  while :; do
    sleep 24h
    echo "$(date) Reloading webserver"
    /usr/bin/pkill -HUP nginx
  done

else
  echo "$(date) Using default config"

  nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
fi
