FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates procps shadowsocks-libev && rm -rf /var/lib/apt/lists/*
RUN curl -sL -o /tmp/sb.tar.gz https://github.com/SagerNet/sing-box/releases/download/v1.14.4/sing-box-1.14.4-linux-amd64.tar.gz && tar -xzf /tmp/sb.tar.gz -C /tmp && cp /tmp/sing-box-*/sing-box /usr/local/bin/sing-box && chmod +x /usr/local/bin/sing-box && rm -rf /tmp/sb.tar.gz /tmp/sing-box-*
RUN curl -sL -o /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && chmod +x /usr/local/bin/cloudflared
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
EXPOSE 8388/tcp 8388/udp
CMD ["/usr/local/bin/start.sh"]
