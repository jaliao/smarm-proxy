#!/bin/bash
# -----------------------------------
# 查詢指定容器內部的當前日期和時間
# 20241014
# -----------------------------------

# -----------------------------------
# 取得 .env
# -----------------------------------

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ENV_FILE="$SCRIPT_DIR/../.env"

# 確認 .env 文件是否存在
if [ ! -f "$ENV_FILE" ]; then
  echo ".env 文件未找到，請確認檔案位置是否正確：$ENV_FILE"
  exit 1
fi

# -----------------------------------
# 取得 env 變數
# -----------------------------------

# 引入設定檔案
export $(grep -v '^#' ../.env | xargs)

# 檢查是否有指定容器名稱
if [ -z "$PROJECT_CONTAINER_NAME" ]; then
  echo "未能找到容器名稱，請確認 .env 檔案中包含 PROJECT_CONTAINER_NAME"
  exit 1
fi

# 確認容器是否存在且正在運行
if ! docker ps --filter "name=$PROJECT_CONTAINER_NAME" --format '{{.Names}}' | grep -q "$PROJECT_CONTAINER_NAME"; then
  echo "容器 $PROJECT_CONTAINER_NAME 未在運行或不存在。"
  exit 1
fi

# -----------------------------------
# 主程式
# -----------------------------------

# 執行 docker exec 指令，使用設定檔中的容器名稱
docker exec $PROJECT_CONTAINER_NAME date
