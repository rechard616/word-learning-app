# Railway 部署说明

## 🔧 后端部署失败排查

### 常见问题及解决方案

#### 问题 1：Root Directory 配置错误

**症状**：部署时提示找不到文件或依赖

**解决方案**：
1. 在 Railway 项目设置中
2. 找到 **"Root Directory"** 选项
3. 设置为：`server`
4. 重新部署

#### 问题 2：依赖安装失败

**症状**：`pnpm install` 或 `npm install` 失败

**解决方案**：
1. 检查 `server/package.json` 是否正确
2. 确保没有使用私有依赖
3. 检查 node 版本兼容性

#### 问题 3：构建失败

**症状**：`pnpm run build` 失败

**解决方案**：
1. 检查 TypeScript 编译错误
2. 确保所有依赖都已安装
3. 查看构建日志

#### 问题 4：启动失败

**症状**：服务无法启动，healthcheck 失败

**解决方案**：
1. 检查启动命令是否正确
2. 确保端口配置正确
3. 查看应用日志

---

## ✅ 正确的部署配置

### 1. Railway 配置

在 Railway 项目中：

```
Root Directory: server
Start Command: node dist/main.js
Healthcheck Path: /api/health
```

### 2. 验证配置

Railway 会自动：
1. 进入 `server` 目录
2. 安装依赖：`pnpm install`
3. 构建项目：`pnpm run build`
4. 启动服务：`node dist/main.js`
5. 健康检查：访问 `/api/health`

---

## 📝 已修复的配置

我已经更新了以下文件并推送到 GitHub：

1. ✅ `railway.toml` - 添加了 server 目录支持
2. ✅ `server/railway.toml` - server 子目录配置

---

## 🚀 重新部署步骤

### 第 1 步：在 Railway 中更新配置

1. 访问 Railway 项目页面
2. 点击 **"Settings"**
3. 找到 **"Root Directory"**
4. 设置为：`server`
5. 点击 **"Save"**

### 第 2 步：重新部署

1. 回到项目主页
2. 点击 **"Redeploy"**
3. 等待部署完成

### 第 3 步：查看日志

如果仍然失败，查看部署日志：

1. 点击项目名称
2. 点击 **"Logs"**
3. 查看错误信息

---

## 💡 如果仍然失败

请提供以下信息：

1. **错误日志**：Railway 部署日志中的错误信息
2. **Root Directory 配置**：确认是否设置为 `server`
3. **错误阶段**：
   - 依赖安装失败？
   - 构建失败？
   - 启动失败？
   - Healthcheck 失败？

---

## 📋 手动检查清单

- [ ] Root Directory 设置为 `server`
- [ ] `server/package.json` 存在且正确
- [ ] `server/tsconfig.json` 存在
- [ ] `server/src/main.ts` 存在
- [ ] 部署日志中没有依赖错误
- [ ] 部署日志中没有构建错误
- [ ] 健康检查端点 `/api/health` 可访问

---

**需要帮助？请提供 Railway 的部署日志，我会帮您具体分析问题。** 🚀
