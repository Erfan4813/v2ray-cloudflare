#!/bin/bash

apt update && apt install -y curl unzip

# نصب V2Ray
bash <(curl -L -s https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

# تولید config ساده V2Ray
cat > /usr/local/etc/v2ray/config.json << EOF
{
  "inbounds": [{
    "port": 8880,
    "protocol": "vmess",
    "settings": {
      "clients": [{
        "id": "11111111-1111-1111-1111-111111111111",
        "alterId": 0
      }]
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "/ws"
      }
    }
  }],
  "outbounds": [{
    "protocol": "freedom"
  }]
}
EOF

# نصب cloudflared برای تونل
curl -L -o cloudflared.tgz https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.tgz
tar -xvzf cloudflared.tgz
chmod +x cloudflared

# ساخت تونل و اجرای V2Ray از طریق Cloudflare
nohup ./cloudflared tunnel --url http://localhost:8880 > tunnel.log 2>&1 &

# اجرای V2Ray
/usr/local/bin/v2ray run &
sleep 15

# نمایش لینک اتصال VMess
echo "vmess://$(echo -n '{"v":"2","ps":"GitHub-V2Ray","add":"example.cloudflare.com","port":"443","id":"11111111-1111-1111-1111-111111111111","aid":"0","net":"ws","type":"none","host":"example.cloudflare.com","path":"/ws","tls":"tls"}' | base64 -w 0)"
