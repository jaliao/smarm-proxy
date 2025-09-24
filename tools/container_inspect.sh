#!/bin/bash
# -------------------------
# 查詢容器的內部狀況和配置參數
# 20241014
# -------------------------

# 引入設定檔案
export $(grep -v '^#' ../.env | xargs)

# 檢查是否有指定容器名稱
if [ -z "$PROJECT_CONTAINER_NAME" ]; then
  echo "未能找到容器名稱，請確認 .env 檔案中包含 PROJECT_CONTAINER_NAME"
  exit 1
fi

docker inspect $PROJECT_CONTAINER_NAME