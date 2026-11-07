#!/bin/sh
# Node: ss-server (IPv6 raw port) + sing-box VLESS/WS + cloudflared tunnel (dual-stack IPv4/IPv6).
# Secrets auto-generate on first boot and persist in /data (the volume). No env vars required.
set -e
mkdir -p /data
if [ -z "$VLESS_UUID" ]; then
  if [ -f /data/vless-uuid.txt ]; then
    VLESS_UUID=$(cat /data/vless-uuid.txt)
  else
    VLESS_UUID=$(cat /proc/sys/kernel/random/uuid)
    echo "$VLESS_UUID" > /data/vless-uuid.txt
  fi
fi
if [ -z "$SS_PASSWORD" ]; then
  if [ -f /data/ss-password.txt ]; then
    SS_PASSWORD=$(cat /data/ss-password.txt)
  else
    SS_PASSWORD=$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n')
    echo "$SS_PASSWORD" > /data/ss-password.txt
  fi
fi
printf '{"log":{"level":"info"},"inbounds":[{"type":"vless","tag":"vless-ws","listen":"127.0.0.1","listen_port":8080,"users":[{"uuid":"%s","flow":""}],"transport":{"type":"ws","path":"/vless"}}],"outbounds":[{"type":"direct","tag":"direct"}]}' "$VLESS_UUID" > /data/sing-box.json
ss-server -s "::" -p "${SS_PORT:-8388}" -k "$SS_PASSWORD" -m "${SS_METHOD:-aes-256-gcm}" -u &
sing-box run -c /data/sing-box.json > /data/sing-box.log 2>&1 &
cloudflared tunnel --url http://localhost:8080 > /data/cloudflared.log 2>&1 &
wait
