#!/bin/bash
# -------------------------
# stop docker 20240827
# -------------------------

echo "Stopping and removing container..."
docker compose -f docker-compose.yml down

echo "Service has been started."