#!/bin/bash
apt update && apt install curl wget unzip -y

# نصب V2Ray
bash <(curl -s -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

# دانلود cloudflared
wget -O cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared
mv cloudflared /usr/local/bin/

# ساخت تونل جدید
cloudflared tunnel login
