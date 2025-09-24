#!/bin/bash
# -------------------------
# 查看 Nginx 容器的日誌內容，以了解網站運行情況和錯誤。
# 20241014
# -------------------------

# 引入 .env 檔案
export $(grep -v '^#' ../.env | xargs)

# 檢查是否有指定容器名稱
if [ -z "$PROJECT_URL" ]; then
  echo "未能找到容器名稱，請確認 .env 檔案中包含 PROJECT_URL"
  exit 1
fi

# 檢查是否有提供要查看的日誌行數，預設顯示最近 100 行
LINES=${1:-100}

# 顯示 Nginx 容器日誌的最後幾行
echo "顯示 Nginx 容器 (ngpxy) 中包含當前網域 (${PROJECT_URL}) 最近 $LINES 行日誌："
docker logs --tail $LINES ngpxy | grep "$PROJECT_URL"

