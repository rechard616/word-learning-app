# 🚨 微信小程序打不开问题完整解决方案

## 📋 快速诊断

### 最可能的原因（按优先级）

1. ⭐⭐⭐ **appid 配置错误** - 使用了测试 appid
2. ⭐⭐⭐ **服务器域名未配置** - 网络请求被拦截
3. ⭐⭐ **后端服务未启动** - 无法连接 API
4. ⭐ **PROJECT_DOMAIN 未配置** - 请求 URL 错误

---

## ✅ 立即修复（3 步）

### 第 1 步：修复 appid

**在微信开发者工具中**：

1. 打开微信开发者工具
2. 点击右上角 **"详情"**
3. 在 **"基本信息"** 标签中
4. 将 **"AppID"** 从 `touristappid` 改为您的小程序 appid
5. 点击 **"保存"**

### 第 2 步：配置服务器域名

**开发阶段**（临时）：

1. 点击 **"详情"**
2. 在 **"本地设置"** 标签中
3. 勾选 **"不校验合法域名、web-view（业务域名）、TLS 版本以及 HTTPS 证书"**
4. 重新编译（`Ctrl + B` / `Cmd + B`）

**生产环境**（推荐）：

1. 登录 [微信公众平台](https://mp.weixin.qq.com/)
2. 进入 **"开发"** → **"开发管理"** → **"开发设置"**
3. 在 **"服务器域名"** 部分
4. 添加后端 URL 到 **"request 合法域名"**
   - 例如：`https://your-backend-url.railway.app`

### 第 3 步：确认后端服务运行

**测试后端健康检查**：

```bash
# 在浏览器中访问
https://your-backend-url.railway.app/api/health
```

或使用 curl：
```bash
curl https://your-backend-url.railway.app/api/health
```

应该返回：
```json
{
  "status": "success",
  "data": "2026-03-02T14:30:00.000Z"
}
```

---

## 🔧 详细排查

### 问题 1：appid 配置错误

**症状**：
- 小程序功能异常
- 无法正常启动

**检查**：
```bash
cat project.config.json | grep appid
```

**修复**：
修改 `project.config.json` 中的 `appid`：
```json
{
  "appid": "your_actual_appid",
  ...
}
```

或在微信开发者工具中直接修改。

---

### 问题 2：服务器域名未配置

**症状**：
- 网络请求失败
- 控制台显示：`request:fail url not in domain list`

**检查**：
在微信开发者工具中查看控制台错误。

**修复**：

**开发阶段**：勾选 **"不校验合法域名..."**

**生产环境**：
1. 登录微信公众平台
2. 进入 **"开发管理"** → **"开发设置"**
3. 添加后端域名到 **"request 合法域名"**

**重要**：
- ✅ 必须使用 HTTPS
- ✅ 必须是完整域名（不能是 IP）
- ✅ 不能带端口号

---

### 问题 3：后端服务未启动

**症状**：
- 网络请求超时
- 控制台显示：`request:fail (empty)` 或 `ERR_CONNECTION_REFUSED`

**检查**：
```bash
curl https://your-backend-url.railway.app/api/health
```

**修复**：

**如果使用 Railway**：
1. 访问 Railway 项目
2. 点击 **"Redeploy"**
3. 等待服务启动

**如果使用 Coze 环境**：
```bash
cd /workspace/projects
coze dev
```

---

### 问题 4：PROJECT_DOMAIN 配置

**症状**：
- 网络请求 URL 错误
- 请求地址为 `undefined/api/word/analyze`

**检查**：
查看 `src/network.ts` 中的 `PROJECT_DOMAIN` 使用。

**修复**：

**方案 A：固定后端 URL**（推荐）
```typescript
// src/network.ts
export namespace Network {
    const createUrl = (url: string): string => {
        if (url.startsWith('http://') || url.startsWith('https://')) {
            return url
        }
        // 替换为实际的后端 URL
        return `https://your-backend-url.railway.app${url}`
    }
    // ...
}
```

**方案 B：环境变量**
确保 `PROJECT_DOMAIN` 环境变量已正确配置。

---

## 📊 常见错误信息

| 错误信息 | 原因 | 解决方案 |
|---------|------|----------|
| `request:fail url not in domain list` | 域名未配置 | 勾选"不校验合法域名"或添加合法域名 |
| `request:fail (empty)` | 后端未启动 | 检查后端服务状态 |
| `ERR_CONNECTION_REFUSED` | 连接被拒绝 | 检查后端端口和服务 |
| `request:fail timeout` | 请求超时 | 检查网络连接或优化性能 |
| `request:fail -2` | 网络错误 | 检查网络连接和域名 |

---

## 🧪 测试步骤

### 1. 测试小程序启动

1. 打开微信开发者工具
2. 确认小程序正常加载
3. 查看控制台是否有错误

### 2. 测试网络请求

1. 输入单词：`hello`
2. 点击 **"开始分析"**
3. 查看 **"Network"** 标签
4. 确认请求成功

### 3. 测试语音功能

1. 分析单词后
2. 点击 **"朗读单词"**
3. 确认能听到发音

### 4. 查看控制台

1. 点击 **"控制台"** 标签
2. 查看所有日志
3. 修复任何错误

---

## 🔍 调试技巧

### 查看网络请求

1. 点击 **"调试器"**
2. 进入 **"Network"** 标签
3. 查看所有请求
4. 点击请求查看详细信息

### 查看控制台日志

1. 点击 **"调试器"**
2. 进入 **"Console"** 标签
3. 查看所有日志和错误

### 查看 AppData

1. 点击 **"调试器"**
2. 进入 **"AppData"** 标签
3. 查看应用状态

---

## 🚀 使用诊断脚本

如果您在 Coze 环境中，可以运行：

```bash
./fix-weapp.sh
```

脚本会自动检查：
1. appid 配置
2. 后端服务状态
3. 小程序编译文件

---

## ✅ 验证修复清单

- [ ] appid 已修改为实际的小程序 appid
- [ ] 服务器域名已配置（开发或生产环境）
- [ ] 后端服务正常运行
- [ ] 小程序成功编译
- [ ] 控制台无错误
- [ ] 单词分析功能正常
- [ ] 语音朗读功能正常

---

## 📚 相关文档

- **本地部署指南**：`LOCAL_DEPLOYMENT.md`
- **Railway 部署指南**：`RAILWAY_SUCCESS.md`
- **Coze 使用指南**：`COZE_USAGE.md`

---

## 💡 提示

### 开发阶段
- ✅ 勾选 **"不校验合法域名..."**
- ✅ 使用测试 appid（仅开发用）
- ✅ 查看控制台错误信息

### 生产环境
- ✅ 使用正式 appid
- ✅ 配置合法域名
- ✅ 使用 HTTPS 后端服务

### 调试技巧
- ✅ 使用 **"Network"** 标签查看请求
- ✅ 使用 **"Console"** 标签查看错误
- ✅ 使用 **"AppData"** 标签查看状态

---

## 🆘 仍然无法解决？

请提供以下信息：

1. **错误截图**：控制台错误信息
2. **appid**：当前使用的 appid
3. **后端 URL**：后端服务的地址
4. **错误日志**：完整的错误日志

我会帮您进一步诊断问题。

---

**立即开始修复，让小程序正常运行！** 🚀
