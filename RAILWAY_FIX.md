# 🔧 Railway 部署问题修复说明

## ❌ 问题描述

健康检查失败，服务无法通过 `/api/health` 端点的访问。

### 错误表现
```
第一次尝试失败，服务不可用。将继续重试，预计耗时 4 分 49 秒。
第二次尝试失败，服务不可用。将继续重试，预计持续 4 分 38 秒。
...
```

---

## ✅ 已修复的问题

### 问题 1：端口配置不正确

**原因**：
- 服务使用固定端口 3000
- Railway 使用动态端口（通过 `PORT` 环境变量）
- 导致服务启动在错误端口，健康检查无法访问

**修复**：
修改 `server/src/main.ts`，优先使用 `PORT` 环境变量：

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
  
  // 其次使用命令行参数
  const args = process.argv.slice(2);
  const portIndex = args.indexOf('-p');
  if (portIndex !== -1 && args[portIndex + 1]) {
    const port = parseInt(args[portIndex + 1], 10);
    if (!isNaN(port) && port > 0 && port < 65536) {
      return port;
    }
  }
  
  // 默认端口
  return 3000;
}
```

### 问题 2：Native 依赖导致构建失败

**原因**：
- `better-sqlite3` 是需要编译的原生模块
- Railway 环境中编译可能失败
- 项目中实际并未使用此依赖

**修复**：
从 `server/package.json` 中移除：
```json
{
  "dependencies": {
    // 移除了 "better-sqlite3": "^11.9.1"
  },
  "devDependencies": {
    // 移除了 "@types/better-sqlite3": "^7.6.13"
  }
}
```

### 问题 3：Railway 配置优化

**原因**：
- 缺少明确的构建命令
- 配置不够清晰

**修复**：
更新 `server/railway.toml`：

```toml
[build]
builder = "NIXPACKS"

[deploy]
# 构建命令：安装依赖并构建
buildCommand = "pnpm install && pnpm run build"
# 启动命令：使用 Railway 环境变量中的端口
startCommand = "node dist/main.js"
# 健康检查路径（注意：应用已设置全局前缀 'api'）
healthcheckPath = "/api/health"
healthcheckTimeout = 300
restartPolicyType = "ON_FAILURE"

[deploy.env]
NODE_ENV = "production"
# Railway 会自动设置 PORT 环境变量
```

---

## 🚀 重新部署步骤

### 第 1 步：确认配置

1. 访问 Railway 项目页面
2. 点击 **"Settings"**
3. 确认 **"Root Directory"** 设置为：`server`
4. 点击 **"Save"**

### 第 2 步：触发重新部署

1. 回到项目主页
2. 点击 **"Redeploy"** 按钮
3. 等待 3-5 分钟

### 第 3 步：查看日志

1. 点击项目名称
2. 点击 **"Logs"** 标签
3. 查看是否显示：
   ```
   ✅ Server running on http://localhost:PORT
   🔍 Health check: http://localhost:PORT/api/health
   ```
4. 确认健康检查是否通过

---

## ✅ 预期结果

### 成功日志示例

```
✅ Build completed successfully
✅ Starting server...
✅ Server running on http://localhost:12345
✅ Health check: http://localhost:12345/api/health
✅ Health check passed
✅ Deployment successful
```

### 健康检查端点

部署成功后，您可以通过以下 URL 访问：
```
https://your-project-url.up.railway.app/api/health
```

返回示例：
```json
{
  "status": "success",
  "data": "2024-03-02T14:30:00.000Z"
}
```

---

## 📋 检查清单

部署前确认：
- [ ] Root Directory 设置为 `server`
- [ ] GitHub 代码已更新（包含最新修复）
- [ ] 无 better-sqlite3 依赖
- [ ] 端口配置支持 `PORT` 环境变量

部署后验证：
- [ ] 服务成功启动
- [ ] 日志显示端口和健康检查路径
- [ ] 健康检查通过
- [ ] `/api/health` 端点可访问

---

## 💡 如果仍然失败

### 可能的原因

1. **依赖安装失败**
   - 检查日志中的 `pnpm install` 输出
   - 可能是网络问题或依赖冲突

2. **TypeScript 编译错误**
   - 检查日志中的 `pnpm run build` 输出
   - 查看具体的编译错误

3. **运行时错误**
   - 检查应用启动后的日志
   - 可能是环境变量缺失或配置错误

### 解决方案

请提供完整的部署日志，包括：
- 构建阶段的输出
- 启动阶段的输出
- 健康检查的输出

我会帮您进一步分析问题。

---

**代码已推送至 GitHub，请在 Railway 中重新部署！** 🚀

GitHub 仓库：https://github.com/rechard616/word-learning-app
