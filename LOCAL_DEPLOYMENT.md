# 💻 本地部署指南

## 📋 前置要求

### 必需软件

- **Node.js**：版本 >= 18.x
- **pnpm**：版本 >= 9.0.0
- **Git**：用于克隆项目

### 安装 pnpm（如果未安装）

```bash
npm install -g pnpm
```

或者使用 corepack：

```bash
corepack enable
```

---

## 🚀 快速开始（5 分钟）

### 第 1 步：克隆项目

```bash
git clone https://github.com/rechard616/word-learning-app.git
cd word-learning-app
```

### 第 2 步：安装依赖

```bash
pnpm install
```

### 第 3 步：启动开发服务器

```bash
# 同时启动前端和后端
pnpm dev
```

### 第 4 步：访问应用

- **前端**：http://localhost:5000
- **后端 API**：http://localhost:3000
- **健康检查**：http://localhost:3000/api/health

---

## 📖 详细步骤

### 1. 克隆项目

```bash
git clone https://github.com/rechard616/word-learning-app.git
cd word-learning-app
```

### 2. 安装依赖

```bash
# 安装所有依赖（前端 + 后端）
pnpm install
```

**预期输出**：
```
Scope: all 2 workspace projects
...
Done in 5.7s
```

### 3. 配置环境变量（可选）

创建 `.env` 文件：

```bash
# 在项目根目录创建 .env 文件
cp .env.example .env
```

`.env` 文件内容：

```env
# 后端配置
PORT=3000
NODE_ENV=development

# 前端配置（如需修改前端端口）
# VITE_PORT=5000

# AI 服务配置（如果需要）
# COZE_API_KEY=your_api_key_here
```

### 4. 启动开发服务器

#### 选项 A：同时启动前端和后端（推荐）

```bash
pnpm dev
```

**输出示例**：
```
[web] vite v4.5.14 dev server running at:
[web]   Local:   http://localhost:5000/
[web]   Network: http://192.168.x.x:5000/
[web]   press h to show help

[server] [Nest] INFO [NestFactory] Starting Nest application...
[server] [Nest] INFO [InstanceLoader] AppModule dependencies initialized +41ms
[server] [Nest] INFO [RouterExplorer] AppController {/api}: +5ms
[server] [Nest] INFO [RouterExplorer] Mapped {/api/health, GET} route +2ms
[server] [Nest] INFO [NestApplication] Nest application successfully started +3ms
[server] ✅ Server running on http://localhost:3000
[server] 🔍 Health check: http://localhost:3000/api/health
```

#### 选项 B：单独启动服务

**只启动前端**：

```bash
# 终端 1
pnpm dev:web
```

**只启动后端**：

```bash
# 终端 2
pnpm dev:server
```

---

## 🧪 测试 API

### 1. 健康检查

```bash
curl http://localhost:3000/api/health
```

返回：
```json
{
  "status": "success",
  "data": "2024-03-02T14:30:00.000Z"
}
```

### 2. 单词分析接口

```bash
curl -X POST http://localhost:3000/api/word/analyze \
  -H "Content-Type: application/json" \
  -d '{"word":"hello"}'
```

返回：
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "word": "hello",
    "partOfSpeech": "名词",
    "phonetic": "/həˈloʊ/",
    "chineseMeaning": "你好，问候",
    "example": "Hello, how are you?"
  }
}
```

### 3. 语音合成接口

```bash
curl -X POST http://localhost:3000/api/tts/synthesize \
  -H "Content-Type: application/json" \
  -d '{"text":"Hello, world"}'
```

返回：
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "audioUrl": "https://..."
  }
}
```

---

## 🏗️ 构建生产版本

### 构建所有项目

```bash
pnpm build
```

**输出示例**：
```
✅ ESLint passed
✅ TypeScript passed
✅ H5 build completed
✅ WeChat build completed
✅ Server build completed
```

### 单独构建

**只构建前端（H5）**：

```bash
pnpm build:web
```

**只构建后端**：

```bash
pnpm build:server
```

### 运行生产版本

```bash
# 启动后端生产版本
cd server
pnpm start:prod
```

---

## 📁 项目结构

```
word-learning-app/
├── src/                    # 前端源代码
│   ├── pages/             # 页面
│   │   └── index/         # 首页
│   ├── app.config.ts      # 应用配置
│   └── network.ts         # 网络请求封装
├── server/                # 后端源代码
│   ├── src/               # NestJS 源码
│   │   ├── word/          # 单词分析模块
│   │   ├── tts/           # 语音合成模块
│   │   └── main.ts        # 入口文件
│   └── dist/              # 编译输出
├── package.json           # 根依赖配置
├── pnpm-workspace.yaml    # pnpm 工作区配置
└── vercel.json            # Vercel 部署配置
```

---

## 🔧 常用命令

### 开发

```bash
pnpm dev              # 同时启动前端和后端
pnpm dev:web          # 只启动前端
pnpm dev:server       # 只启动后端
pnpm dev:weapp        # 启动微信小程序开发模式
```

### 构建

```bash
pnpm build            # 构建所有项目
pnpm build:web        # 只构建前端（H5）
pnpm build:weapp      # 只构建微信小程序
pnpm build:server     # 只构建后端
```

### 检查

```bash
pnpm lint:build       # ESLint 检查
pnpm tsc              # TypeScript 类型检查
pnpm validate         # 同时运行 ESLint 和 TypeScript 检查
```

### 清理

```bash
pnpm kill:all         # 停止所有开发进程
```

---

## 🐛 常见问题

### Q1: pnpm install 失败

**错误**：`ERR_PNPM_NO_CONFIG_FILE`

**解决方案**：
```bash
# 重新安装 pnpm
npm install -g pnpm@latest
# 或启用 corepack
corepack enable
```

### Q2: 端口被占用

**错误**：`EADDRINUSE: address already in use :::3000`

**解决方案**：

**方案 A**：修改端口

```bash
# 修改 server/.env
PORT=3001
```

**方案 B**：杀死占用端口的进程

```bash
# 查找占用 3000 端口的进程
lsof -i :3000

# 杀死进程
kill -9 <PID>

# 或使用 npx kill-port
npx kill-port 3000
```

### Q3: Node.js 版本不兼容

**错误**：`Taro 将不再支持 Node.js 小于 20 的版本`

**解决方案**：

```bash
# 使用 nvm 安装 Node.js 20
nvm install 20
nvm use 20
```

### Q4: 依赖安装很慢

**解决方案**：

```bash
# 使用国内镜像
pnpm config set registry https://registry.npmmirror.com
```

### Q5: 前端无法访问后端 API

**错误**：`Network Error`

**解决方案**：

检查 `src/network.ts` 中的配置，确保后端 URL 正确：

```typescript
// 开发环境
const API_BASE_URL = 'http://localhost:3000'
```

### Q6: 构建失败

**错误**：TypeScript 编译错误

**解决方案**：

```bash
# 先运行类型检查
pnpm tsc

# 修复错误后再构建
pnpm build
```

---

## 🔒 安全提示

### 1. 不要提交敏感信息

确保 `.gitignore` 包含：
```
.env
.env.local
*.key
node_modules/
dist/
dist-*/
```

### 2. 环境变量

使用 `.env.example` 作为模板，不要直接修改 `.env`：

```bash
cp .env.example .env
```

---

## 🎯 生产环境部署

### 使用 PM2 管理进程

```bash
# 安装 PM2
npm install -g pm2

# 启动后端
cd server
pm2 start dist/main.js --name word-learning-backend

# 查看日志
pm2 logs

# 重启
pm2 restart word-learning-backend

# 停止
pm2 stop word-learning-backend
```

### 使用 Nginx 反向代理

```nginx
server {
    listen 80;
    server_name your-domain.com;

    # 前端
    location / {
        root /path/to/dist-web;
        try_files $uri $uri/ /index.html;
    }

    # 后端 API
    location /api/ {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

---

## 📚 参考文档

- [Taro 官方文档](https://taro.jd.com/)
- [NestJS 官方文档](https://nestjs.com/)
- [pnpm 官方文档](https://pnpm.io/)

---

## 💡 提示

- **开发模式**：使用 `pnpm dev` 同时启动前后端，支持热更新
- **生产构建**：先运行 `pnpm build` 构建所有项目
- **调试**：使用浏览器开发者工具和后端日志
- **测试**：使用 curl 或 Postman 测试 API 端点

---

**准备好了吗？开始本地部署吧！** 🚀

1. 克隆项目
2. 安装依赖
3. 运行 `pnpm dev`
4. 访问 http://localhost:5000
