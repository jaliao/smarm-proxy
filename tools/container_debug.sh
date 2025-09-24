#!/bin/bash
# -------------------------
# 綜合多種查詢功能，用於對容器進行快速除錯，可能包括 log、inspect 和 stats 等信息
# 20241014
# -------------------------

# 引入 .env 檔案
export $(grep -v '^#' ../.env | xargs)

# 檢查是否有指定容器名稱
if [ -z "$PROJECT_CONTAINER_NAME" ]; then
  echo "未能找到容器名稱，請確認 .env 檔案中包含 PROJECT_CONTAINER_NAME"
  exit 1
fi

# 提示用戶選擇操作
echo "選擇要執行的操作:"
echo "1) 查看容器日誌 (logs)"
echo "2) 檢查容器詳細信息 (inspect)"
echo "3) 查看容器資源使用統計 (stats)"
echo "4) 查看容器啟動時間 (uptime)"
echo "5) 退出"

# 讀取用戶輸入
read -p "請輸入選項 (1-5): " action

case $action in
  1)
    echo "顯示 $PROJECT_CONTAINER_NAME 的日誌..."
    docker logs $PROJECT_CONTAINER_NAME
    ;;
  2)
    echo "顯示 $PROJECT_CONTAINER_NAME 的詳細信息..."
    docker inspect $PROJECT_CONTAINER_NAME
    ;;
  3)
    echo "顯示 $PROJECT_CONTAINER_NAME 的資源使用統計..."
    docker stats $PROJECT_CONTAINER_NAME --no-stream
    ;;
  4)
    echo "顯示 $PROJECT_CONTAINER_NAME 的啟動時間..."
    docker exec $PROJECT_CONTAINER_NAME uptime
    ;;
  5)
    echo "退出程序"
    exit 0
    ;;
  *)
    echo "無效的選項，請輸入 1 到 5 之間的數字"
    ;;
esac