#!/bin/bash
# -------------------------
# 檢查 SSL 憑證是否申請成功。
# 20241014
# -------------------------

# 引入 .env 檔案
export $(grep -v '^#' ../.env | xargs)

# 檢查是否有指定網域名稱
if [ -z "$PROJECT_URL" ]; then
  echo "未能找到網域名稱，請確認 .env 檔案中包含 PROJECT_URL"
  exit 1
fi

# 檢查 SSL 憑證是否存在
CERT_PATH="/home/psyduck/nginx-proxy/certs/${PROJECT_URL}"
if [ -d "$CERT_PATH" ]; then
  echo "SSL 憑證已存在於 ${CERT_PATH}"
else
  echo "未找到 SSL 憑證，請確認是否已申請"
fi

# 檢查是否有提供要查看的日誌行數，預設顯示最近 100 行
LINES=${1:-100}

# 檢查 Let's Encrypt 申請日誌是否有相關資訊
echo "\n檢查 Let's Encrypt 容器日誌中是否有相關申請資訊："
docker logs --tail $LINES ngpxyletse | grep "$PROJECT_URL"