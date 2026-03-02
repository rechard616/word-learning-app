# 🚀 快速部署指南（有 GitHub 账号版）

## 前置条件

✅ 已有 GitHub 账号
✅ 代码已完成开发
✅ 准备好部署

---

## 📋 部署前准备（5 分钟）

### 1. 创建 GitHub 仓库

1. 访问：https://github.com/new
2. 仓库名称：`word-learning-app`
3. 设置为 Public（公开）
4. 不要初始化 README
5. 点击 "Create repository"

### 2. 推送代码到 GitHub

```bash
# 在项目根目录执行
cd /workspace/projects

# 添加远程仓库（替换为你的仓库地址）
git remote add origin https://github.com/your-username/word-learning-app.git

# 添加所有文件
git add .

# 提交代码
git commit -m "feat: 单词学习小程序 - 支持单词分析和语音朗读"

# 推送到 GitHub
git branch -M main
git push -u origin main
```

---

## 🎯 步骤一：部署后端到 Railway（5 分钟）

### 1.1 创建 Railway 账号

1. 访问：https://railway.app/
2. 点击右上角 "Login"
3. 选择 "Continue with GitHub"
4. 授权 GitHub 登录

### 1.2 创建新项目

1. 登录后点击 "New Project" 按钮
2. 选择 "Deploy from GitHub repo"
3. 在列表中找到 `word-learning-app` 仓库
4. 点击 "Import"

### 1.3 配置后端

Railway 会自动检测到项目，需要进行以下配置：

#### 选择部署目录
在项目配置中，找到 "Root Directory" 选项，设置为：
```
server
```

#### 环境变量
点击 "Variables" 标签，添加以下环境变量：

```
NODE_ENV=production
PORT=3000
COZE_API_KEY=your-coze-api-key-here  # 如果有 API 密钥
```

### 1.4 部署后端

1. 点击 "Deploy" 按钮
2. 等待部署完成（约 2-3 分钟）
3. 部署成功后，点击 "Settings"
4. 找到 "Domains" 标签
5. 复制后端 URL，格式类似：
   ```
   https://word-learning-backend-production.up.railway.app
   ```

### 1.5 验证后端部署

在浏览器中访问：
```
https://word-learning-backend-production.up.railway.app/api/health
```

应该看到：
```json
{"status":"ok"}
```

**✅ 后端部署完成！** 复制这个 URL，下一步会用到。

---

## 🎨 步骤二：部署前端到 Vercel（5 分钟）

### 2.1 创建 Vercel 账号

1. 访问：https://vercel.com/
2. 点击右上角 "Sign Up"
3. 选择 "Continue with GitHub"
4. 授权 GitHub 登录

### 2.2 导入项目

1. 登录后点击 "Add New" → "Project"
2. 在 "Import Git Repository" 列表中找到 `word-learning-app`
3. 点击 "Import"

### 2.3 配置项目

#### 框架预设
Vercel 会自动检测为 "Vite" 项目

#### 构建设置
在 "Build & Development Settings" 中确认：

```
Framework Preset: Vite
Build Command: pnpm install && pnpm build:web
Output Directory: dist-web
Install Command: pnpm install
```

#### 环境变量
在 "Environment Variables" 中添加：

**注意**：将 `YOUR_RAILWAY_URL` 替换为步骤一中的实际后端 URL

```
Key: PROJECT_DOMAIN
Value: https://word-learning-backend-production.up.railway.app
```

### 2.4 部署前端

1. 点击 "Deploy" 按钮
2. 等待构建和部署（约 3-5 分钟）
3. 部署成功后，会看到：
   ```
   🎉 Production: https://word-learning.vercel.app
   ```

### 2.5 访问应用

点击部署成功的链接，应该可以看到单词学习应用的界面。

### 2.6 测试功能

1. 输入单词：`hello`
2. 点击 "开始分析"
3. 查看分析结果
4. 点击 "朗读单词" 测试语音功能

**✅ 前端部署完成！** 🎉

---

## 🔧 常见问题排查

### 问题 1：部署失败

**检查清单**：
- [ ] GitHub 仓库是否正确推送
- [ ] 环境变量是否正确配置
- [ ] Railway 根目录是否设置为 `server`
- [ ] Vercel 输出目录是否设置为 `dist-web`

### 问题 2：前端无法连接后端

**解决方法**：
1. 检查 Vercel 环境变量 `PROJECT_DOMAIN` 是否正确
2. 确认后端 Railway 项目正在运行
3. 在浏览器控制台查看错误信息
4. 访问后端健康检查接口：`https://your-backend-url.railway.app/api/health`

### 问题 3：语音播放失败

**解决方法**：
1. 检查后端 API 密钥是否配置
2. 确认音频 URL 可以访问
3. 检查浏览器音频权限
4. 查看后端日志确认 TTS 调用是否成功

### 问题 4：样式显示异常

**解决方法**：
1. 清除浏览器缓存
2. 使用硬刷新：Ctrl + Shift + R（Windows）或 Cmd + Shift + R（Mac）
3. 检查浏览器控制台是否有加载错误

---

## 📊 部署架构图

```
用户浏览器
    ↓
Vercel (前端 H5)
    ↓
Railway (后端 API)
    ↓
Coze SDK (AI 服务)
    ↓
  LLM + TTS
```

---

## 🎉 部署完成检查清单

- [ ] 代码已推送到 GitHub
- [ ] Railway 后端部署成功
- [ ] Vercel 前端部署成功
- [ ] 可以访问前端页面
- [ ] 单词分析功能正常
- [ ] 语音朗读功能正常
- [ ] 移动端显示正常

---

## 📝 后续维护

### 更新代码

```bash
# 修改代码后
git add .
git commit -m "fix: 修复某个问题"
git push

# Railway 和 Vercel 会自动检测到更新并重新部署
```

### 查看日志

- **Railway**: 点击项目 → 选择部署 → "Logs" 标签
- **Vercel**: 点击项目 → "Deployments" → 选择部署 → "View Logs"

### 监控

- **Railway**: 查看资源使用情况、API 调用次数
- **Vercel**: 查看访问统计、错误率

---

## 💡 优化建议

### 1. 性能优化
- 启用 CDN 缓存
- 压缩静态资源
- 优化图片加载

### 2. 安全加固
- 启用 HTTPS
- 配置 CORS
- 添加速率限制

### 3. 用户体验
- 添加加载动画
- 优化错误提示
- 支持离线访问

---

## 🆘 需要帮助？

- **Vercel 文档**: https://vercel.com/docs
- **Railway 文档**: https://docs.railway.app
- **GitHub Issues**: https://github.com/your-repo/issues

---

**🎊 恭喜！您的单词学习小程序已成功部署到公网！**

现在任何人都可以通过 `https://word-learning.vercel.app` 访问您的应用了！
