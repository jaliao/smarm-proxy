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

docker exec -it smartm-proxy nginx -t

docker exec -it smartm-proxy nginx -s reload

echo "Service has been started."
docker ps

