# 🚀 Coze 环境使用指南

## ✅ 问题已修复

端口冲突问题已解决：
- ✅ 前端：5000 端口
- ✅ 后端：3000 端口

---

## 🌐 访问应用

### 在 Coze 环境中预览

#### 方式 1：使用 Coze 提供的预览链接

1. 在 Coze 编辑器中，找到预览按钮
2. 点击预览，会自动打开浏览器
3. 或使用 Coze 生成的预览 URL

#### 方式 2：直接访问本地端口

如果您在 Coze 的容器环境中：

**前端（H5）**：
```
http://localhost:5000
```

**后端 API**：
```
http://localhost:3000
```

**健康检查**：
```
http://localhost:3000/api/health
```

---

## 🧪 测试功能

### 1. 测试单词分析

在应用中：
1. 输入单词：`hello`
2. 点击 **"开始分析"**
3. 查看分析结果

**预期结果**：
- 词性：名词/动词
- 音标：`/həˈloʊ/`
- 中文意思：你好，问候
- 例句：`Hello, how are you?`

### 2. 测试语音朗读

1. 输入单词并分析
2. 点击 **"朗读单词"** 按钮
3. 听到英语发音

### 3. 测试后端 API

```bash
# 健康检查
curl http://localhost:3000/api/health

# 单词分析
curl -X POST http://localhost:3000/api/word/analyze \
  -H "Content-Type: application/json" \
  -d '{"word":"test"}'

# 语音合成
curl -X POST http://localhost:3000/api/tts/synthesize \
  -H "Content-Type: application/json" \
  -d '{"text":"Hello, world"}'
```

---

## 🔄 热更新

Coze 环境支持热更新，修改代码后会自动刷新：

### 修改前端代码

1. 编辑 `src/pages/index/index.tsx`
2. 保存文件
3. 浏览器自动刷新

### 修改后端代码

1. 编辑 `server/src/` 下的文件
2. 保存文件
3. 后端自动重新编译

**查看日志**：
```bash
tail -f /tmp/coze-logs/dev.log
```

---

## 📊 查看服务日志

### 查看所有日志

```bash
tail -50 /tmp/coze-logs/dev.log
```

### 实时监控日志

```bash
tail -f /tmp/coze-logs/dev.log
```

### 查看错误日志

```bash
tail -50 /tmp/coze-logs/dev.log | grep -i error
```

---

## 🔧 重启服务

### 方式 1：使用 Coze 命令

```bash
cd /workspace/projects
coze dev
```

### 方式 2：手动重启

```bash
# 停止所有服务
pnpm kill:all

# 重新启动
coze dev
```

---

## 🐛 常见问题

### Q1: 预览链接打不开？

**解决方案**：

1. 检查服务是否启动：
```bash
ss -tuln | grep -E ':(5000|3000)'
```

2. 如果服务未运行，重启：
```bash
cd /workspace/projects
coze dev
```

3. 等待 30 秒后重试

### Q2: 页面显示网络错误？

**解决方案**：

1. 检查后端服务：
```bash
curl http://localhost:3000/api/health
```

2. 查看后端日志：
```bash
tail -50 /tmp/coze-logs/dev.log | grep server
```

3. 如果后端未启动，重启服务

### Q3: 端口被占用？

**解决方案**：

```bash
# 停止所有服务
pnpm kill:all

# 重新启动
coze dev
```

### Q4: 修改代码后没有更新？

**解决方案**：

1. 检查文件是否保存
2. 查看日志是否有编译错误
3. 手动刷新浏览器（Ctrl+Shift+R）

### Q5: API 请求失败？

**解决方案**：

1. 检查浏览器控制台（F12）错误信息
2. 查看后端日志：
```bash
tail -50 /tmp/coze-logs/dev.log
```
3. 确认后端服务正常：
```bash
curl http://localhost:3000/api/health
```

---

## 📱 功能特性

### ✅ 已实现功能

- [x] 单词智能分析（词性、音标、中文意思、例句）
- [x] 语音合成和朗读
- [x] 响应式界面设计
- [x] 跨端兼容（H5 + 微信小程序）
- [x] 热更新支持

### 🔧 核心技术

- **前端**：Taro 4 + React 18 + Tailwind CSS
- **后端**：NestJS + Node.js 18
- **AI 能力**：LLM 单词分析 + TTS 语音合成

---

## 🎯 开发提示

### 快速测试

1. 输入单词：`hello`
2. 点击分析
3. 查看结果
4. 点击朗读

### 调试技巧

- **前端调试**：使用浏览器开发者工具（F12）
- **后端调试**：查看 `/tmp/coze-logs/dev.log`
- **API 测试**：使用 curl 或 Postman

### 性能优化

- 前端已启用 Vite HMR（热模块替换）
- 后端已启用 Watch 模式（文件监听）
- 所有修改实时生效

---

## 📚 相关文档

- **本地部署指南**：`LOCAL_DEPLOYMENT.md`
- **Railway 部署指南**：`RAILWAY_SUCCESS.md`
- **Vercel 部署指南**：`VERCEL_DEPLOYMENT.md`

---

## 💡 提示

- **开发模式**：热更新已启用，修改代码自动刷新
- **日志监控**：使用 `tail -f /tmp/coze-logs/dev.log` 实时查看
- **服务状态**：使用 `ss -tuln | grep 3000` 检查后端
- **快速重启**：使用 `pnpm kill:all && coze dev`

---

## 🎉 开始使用

服务已启动，立即访问：

**前端**：http://localhost:5000
**后端**：http://localhost:3000
**健康检查**：http://localhost:3000/api/health

**功能演示**：
1. 输入单词：`happy`
2. 点击 **"开始分析"**
3. 点击 **"朗读单词"**

---

**在 Coze 环境中尽情体验吧！** 🚀
