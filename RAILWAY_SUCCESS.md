# 🎉 Railway 部署成功指南

## ✅ 所有问题已修复

### 问题 1：端口配置 ✅
**问题**：服务使用固定端口 3000，Railway 使用动态端口
**修复**：修改 `server/src/main.ts` 优先使用 `PORT` 环境变量

### 问题 2：pnpm-lock.yaml 不同步 ✅
**问题**：lockfile 包含已删除的依赖
**修复**：添加 `better-sqlite3` 为可选依赖

### 问题 3：TypeScript 语法错误 ✅
**问题**：`server/src/main.ts` 缺少右大括号
**修复**：添加缺失的 `}`

---

## 🚀 完整部署步骤

### 第 1 步：确认 Railway 配置

1. 访问 Railway 项目页面
2. 点击 **"Settings"**
3. 设置 **"Root Directory"** 为：`server`
4. 点击 **"Save"**

### 第 2 步：重新部署

1. 回到项目主页
2. 点击 **"Redeploy"** 按钮
3. 等待 5-7 分钟

### 第 3 步：验证部署

部署成功后，查看日志应该看到：

```
✅ Build completed successfully
✅ pnpm install completed
✅ pnpm run build completed
✅ Starting server...
✅ Server running on http://localhost:PORT
✅ Health check: http://localhost:PORT/api/health
✅ Health check passed
```

---

## 📋 端点测试

### 1. 健康检查

获取 Railway 分配的 URL（在 Settings → Domains），然后访问：

```
https://your-project-url.up.railway.app/api/health
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
curl -X POST https://your-project-url.railway.app/api/word/analyze \
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
curl -X POST https://your-project-url.railway.app/api/tts/synthesize \
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

## 🎯 部署检查清单

- [ ] Root Directory 设置为 `server`
- [ ] GitHub 代码已更新（commit: 6c9ae07）
- [ ] pnpm-lock.yaml 已同步
- [ ] TypeScript 编译通过
- [ ] 构建成功
- [ ] 健康检查通过
- [ ] API 端点可访问

---

## 📖 配置文件说明

### server/railway.toml

```toml
[build]
builder = "NIXPACKS"

[deploy]
buildCommand = "pnpm install && pnpm run build"
startCommand = "node dist/main.js"
healthcheckPath = "/api/health"
healthcheckTimeout = 300
restartPolicyType = "ON_FAILURE"

[deploy.env]
NODE_ENV = "production"
```

### server/src/main.ts

```typescript
function parsePort(): number {
  // 优先使用 Railway 环境变量 PORT
  const envPort = process.env.PORT;
  if (envPort) {
    const port = parseInt(envPort, 10);
    if (!isNaN(port) && port > 0 && port < 65536) {
      return port;
    }
  }
  return 3000;
}
```

---

## 🎉 部署成功后

### 复制后端 URL

1. 在 Railway 项目中点击 **"Settings"**
2. 进入 **"Domains"** 标签
3. 复制后端 URL，例如：
   ```
   https://word-learning-backend-production.up.railway.app
   ```

### 配置前端环境变量

在部署前端（Vercel）时：

1. 设置环境变量：
   - Key: `PROJECT_DOMAIN`
   - Value: `https://word-learning-backend-production.up.railway.app`

---

## 💡 常见问题

### Q: 部署失败怎么办？
A: 查看部署日志，根据错误信息排查

### Q: 健康检查失败怎么办？
A: 确认服务已启动，端口配置正确

### Q: API 返回 404？
A: 确认 Root Directory 设置为 `server`

### Q: 依赖安装失败？
A: 确认 pnpm-lock.yaml 已同步

---

**后端部署成功后，可以继续部署前端！** 🚀
