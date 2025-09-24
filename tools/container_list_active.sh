#!/bin/bash
# -----------------------------------
# 列出當前正在運行的 Docker 容器。
# 20241014
# -----------------------------------

# 列出當前正在運行的 Docker 容器
echo "當前正在運行的 Docker 容器："
docker ps --format "table {{.Names}}	{{.Image}}	{{.Status}}"