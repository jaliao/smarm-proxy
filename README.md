## **IIS-SecureProxy 專案說明文件**

---

### **目前版本**

- **1.0** (2024/10/24) - 支援單一站台
- **2.0** - 支援多站台  
- **3.0** - 支援 Let's Encrypt 自動憑證管理  

---

**IIS-SecureProxy 3.0**

透過 `jwilder/nginx-proxy` 將流量通過 80 埠自動分流至多個 Nginx 節點，並轉發到後端的 IIS6。此架構還利用 `jwilder/nginx-proxy` 自動申請和管理 Let's Encrypt 憑證，確保每個連線均具備 SSL 安全性。

**功能亮點：**
- **自動流量分流**：使用 80 埠分流至多台 Nginx 節點，高效管理多伺服器環境。
- **自動 SSL 憑證管理**：Let's Encrypt 憑證自動申請與更新，簡化 SSL 維護。
- **全程安全加密**：確保所有流量均經過 SSL 保護，有效防範未經授權的存取。


## **手動安裝 SSL 憑證的步驟**

### 1. 拼接完整憑證鏈

若網站無法通過 SSL 憑證驗證，通常是因為缺少**中繼憑證**。可以使用以下指令將伺服器憑證與中繼憑證串接為一個完整憑證檔案：

```bash
cat fuconhosp.com.tw.crt ca_bundle.crt > /etc/nginx/certs/fullchain.pem
```

### 2. 配置 Nginx 的 SSL 設定

在 `nginx.conf` 中進行以下配置：

```nginx
server {
    listen 443 ssl;
    server_name www.fuconhosp.com.tw;

    ssl_certificate /etc/nginx/certs/fullchain.pem;  # 完整憑證鏈
    ssl_certificate_key /etc/nginx/certs/fuconhosp.com.tw.key;  # 私鑰
    ssl_trusted_certificate /etc/nginx/certs/ca_bundle.crt;  # 中繼憑證（如需要）
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        proxy_pass http://<IIS_SERVER_IP>:<IIS_SERVER_PORT>;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

### 3. 將憑證檔案放入 Docker 專案

將你的 SSL 憑證和私鑰放入 `certs/` 目錄，例如：

```
./certs/
├── fuconhosp.com.tw.crt
├── fuconhosp.com.tw.key
└── ca_bundle.crt
```

---

### 4. 启动 Nginx 容器

使用 Docker Compose 啟動 Nginx：

```bash
docker-compose up -d nginx
```

---

### 5. 驗證 SSL 安裝

1. 查看 Nginx 日誌檔案，檢查是否有錯誤：

   ```bash
   docker logs nginx-proxy
   ```

2. 使用 `curl` 測試 SSL 連接：

   ```bash
   curl -I https://www.fuconhosp.com.tw
   ```

---

### 6. 手動更新 SSL 憑證

當憑證快到期時，可以從供應商下載新的憑證，替換 `certs/` 內的 `.crt` 和 `.key` 檔案，然後重啟 Nginx：

```bash
docker-compose restart nginx
```

---

## **專案目錄結構**

```
IIS-SecureProxy/
│
├── docker-compose.yml         # Docker Compose 配置檔
├── nginx.conf                 # Nginx 主設定檔
├── sites-enabled/             # 多站台 Nginx 設定檔目錄（可選）
│   └── default.conf           # 預設站台設定檔
├── certs/                     # SSL 憑證目錄
│   ├── fuconhosp.com.tw.crt   # 網站 SSL 憑證
│   ├── fuconhosp.com.tw.key   # 網站 SSL 私鑰
│   └── ca_bundle.crt          # 中繼憑證（如需要）
├── www/                       # 用於 Certbot 驗證的 Webroot 資料夾（可選）
│   └── index.html             # 測試用 HTML 文件
└── logs/                      # Nginx 日誌目錄（可選）
    ├── access.log             # 訪問日誌
    └── error.log              # 錯誤日誌
```

---

## **文件說明**

1. **`docker-compose.yml`**  
   - 定義 Nginx 和 SSL 憑證的服務。
   - 支援快速啟動和管理容器。

2. **`nginx.conf`**  
   - 配置反向代理和 SSL 憑證。

3. **`sites-enabled/`**（可選）  
   - 管理多站台 Nginx 設定。

4. **`certs/`**  
   - 存放 SSL 憑證與私鑰。

5. **`www/`**（可選）  
   - 用於 Certbot 驗證，也可作為靜態資源存放目錄。

6. **`logs/`**（可選）  
   - 紀錄 Nginx 訪問與錯誤日誌。

---

## **未來功能與擴展**

- **2.0**：支援多站台配置  
- **3.0**：整合 Let's Encrypt，自動管理 SSL 憑證  

---

## **結語**

此專案旨在提供 IIS 伺服器的安全代理服務，透過 Nginx 和 Docker 快速部署，支援 SSL 加密和反向代理。如果有任何問題或需要支援，請隨時聯繫管理團隊。

---

