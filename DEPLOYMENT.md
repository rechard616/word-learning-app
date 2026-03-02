# 单词学习小程序 H5 部署指南

## 🚀 部署方案总览

### 方案一：Vercel + Railway（推荐，免费）
- ✅ 完全免费
- ✅ 自动 HTTPS
- ✅ 全球 CDN
- ✅ 简单易用

### 方案二：Docker 部署
- ✅ 可控性强
- ✅ 适合企业部署
- ⚠️ 需要自己的服务器

### 方案三：直接使用开发服务器
- ✅ 快速测试
- ⚠️ 仅限本地访问

---

## 📦 方案一：Vercel + Railway 部署（推荐）

### 步骤 1：准备项目

#### 1.1 修改前端配置

修改 `src/network.ts` 中的 API 地址，使其支持环境变量：

```typescript
// 前端 API 基础 URL
const API_BASE_URL = process.env.API_BASE_URL || 'http://localhost:3000'
```

#### 1.2 创建环境变量文件

创建 `.env.production`：

```env
API_BASE_URL=https://your-backend-url.railway.app
```

### 步骤 2：部署后端到 Railway

#### 2.1 创建 Railway 账号
访问：https://railway.app/

#### 2.2 创建新项目
1. 点击 "New Project"
2. 选择 "Deploy from GitHub repo"
3. 选择或创建 GitHub 仓库

#### 2.3 配置后端
创建 `railway.toml` 文件：

```toml
[build]
builder = "NIXPACKS"

[deploy]
startCommand = "node dist/main.js"
healthcheckPath = "/api/health"
healthcheckTimeout = 300
restartPolicyType = "ON_FAILURE"
```

#### 2.4 添加环境变量
在 Railway 项目设置中添加：
- `COZE_API_KEY`（你的 API 密钥）
- 其他必要的环境变量

#### 2.5 获取后端 URL
部署完成后，Railway 会提供一个 URL，例如：
```
https://word-learning-backend-production.up.railway.app
```

### 步骤 3：部署前端到 Vercel

#### 3.1 创建 Vercel 账号
访问：https://vercel.com/

#### 3.2 部署项目
1. 点击 "New Project"
2. 导入你的 GitHub 仓库
3. 配置构建设置：

**Framework Preset**: Vite

**Build Command**:
```bash
pnpm install && pnpm build:web
```

**Output Directory**: `dist-web`

#### 3.3 配置环境变量
在 Vercel 项目设置中添加：
- `API_BASE_URL` = `https://your-backend-url.railway.app`

#### 3.4 部署完成
Vercel 会提供一个 URL，例如：
```
https://word-learning.vercel.app
```

---

## 🐳 方案二：Docker 部署

### 步骤 1：创建 Dockerfile

#### 后端 Dockerfile（`server/Dockerfile`）
```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN pnpm install

COPY . .
RUN pnpm build

EXPOSE 3000

CMD ["node", "dist/main.js"]
```

#### 前端 Dockerfile（`Dockerfile`）
```dockerfile
FROM node:18-alpine as builder

WORKDIR /app

COPY package*.json ./
RUN pnpm install

COPY . .
RUN pnpm build:web

FROM nginx:alpine

COPY --from=builder /app/dist-web /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### 步骤 2：创建 nginx.conf

```nginx
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html;
            try_files $uri $uri/ /index.html;
        }

        location /api {
            proxy_pass http://backend:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }
    }
}
```

### 步骤 3：创建 docker-compose.yml

```yaml
version: '3.8'

services:
  backend:
    build:
      context: ./server
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - COZE_API_KEY=${COZE_API_KEY}
    restart: unless-stopped

  frontend:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "80:80"
    depends_on:
      - backend
    environment:
      - API_BASE_URL=http://backend:3000
    restart: unless-stopped
```

### 步骤 4：构建和运行

```bash
# 构建镜像
docker-compose build

# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f
```

---

## 💡 方案三：快速测试（当前环境）

如果只是想快速测试，可以直接使用当前的开发服务器：

```bash
# 确保服务正在运行
cd /workspace/projects

# 启动开发服务器
pnpm dev
```

然后访问：
- 前端：http://localhost:5000
- 后端：http://localhost:3000

---

## 📝 部署检查清单

### 部署前检查
- [ ] 所有环境变量已配置
- [ ] API 密钥已设置
- [ ] 后端服务可以正常访问
- [ ] 前端构建成功
- [ ] 前后端 API 地址正确配置

### 部署后验证
- [ ] 前端页面可以打开
- [ ] 输入单词可以正常分析
- [ ] 语音朗读功能正常
- [ ] 没有跨域错误
- [ ] 移动端适配正常

---

## 🔧 常见问题

### Q1: 前端无法连接后端
**解决方法**：
1. 检查 CORS 配置
2. 确认 API_BASE_URL 正确
3. 检查网络连接

### Q2: 语音播放失败
**解决方法**：
1. 确认音频 URL 可访问
2. 检查浏览器音频权限
3. 确认音频格式支持

### Q3: 部署后样式丢失
**解决方法**：
1. 检查静态资源路径
2. 确认 nginx 配置正确
3. 清除浏览器缓存

---

## 🎯 推荐方案总结

| 方案 | 难度 | 成本 | 适合场景 |
|------|------|------|----------|
| Vercel + Railway | ⭐ 简单 | 免费 | 个人项目、快速上线 |
| Docker | ⭐⭐⭐ 中等 | 需要服务器 | 企业部署、高可控 |
| 开发服务器 | ⭐ 简单 | 免费 | 本地测试、开发 |

**推荐**：如果需要公网访问，使用 **Vercel + Railway** 方案
