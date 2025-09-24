#!/bin/bash
# -------------------------
# start docker 
# 20241015
# -------------------------

echo "update docker image\n"
docker compose -f docker-compose.yml pull

echo "Stopping and removing container..."
docker compose -f docker-compose.yml down

echo "Starting  service..."
docker compose -f docker-compose.yml up -d

docker exec -it smartm-redirector nginx -t

docker exec -it smartm-redirector nginx -s reload

echo "Service has been started."
docker ps

# 確認容器運行狀態
echo "Testing 301 redirect..."
curl -I https://smarmt.blockcode.com.tw/support/where-to-buy/retailers