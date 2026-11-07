# Cloady node (VLESS+WS over Cloudflare Tunnel)

Dual-stack proxy node for Cloady free tier: sing-box VLESS over WebSocket,
exposed through a cloudflared tunnel (trycloudflare), so it works over both
IPv4 and IPv6. A legacy Shadowsocks server also runs on 8388 (IPv6 only).

No secrets in this repo. On first boot `start.sh` generates a VLESS UUID and
an SS password and stores them in the persistent volume `/data`
(`vless-uuid.txt`, `ss-password.txt`). The tunnel hostname is written to
`/data/cloudflared.log`. Set `VLESS_UUID` / `SS_PASSWORD` env vars to override.
