# 🚨 微信小程序打不开问题排查指南

## 📋 可能的原因及解决方案

### 问题 1：appid 配置错误 ⭐⭐⭐

**症状**：小程序无法正常启动或功能异常

**检查方法**：
```bash
# 查看配置文件
cat project.config.json
```

**当前配置**：
```json
{
  "appid": "touristappid",
  ...
}
```

**问题**：`touristappid` 是微信开发者工具的测试 appid，不是正式的小程序 appid

**解决方案**：

#### 步骤 1：在微信开发者工具中配置 appid

1. 打开微信开发者工具
2. 点击右上角 **"详情"**
3. 在 **"基本信息"** 标签中
4. 修改 **"AppID"** 为您的小程序 appid

或直接编辑 `project.config.json`：
```json
{
  "appid": "your_actual_appid",
  ...
}
```

#### 步骤 2：重新编译

在微信开发者工具中：
- 点击 **"编译"** 按钮
- 或按 `Ctrl + B`（Windows）/ `Cmd + B`（Mac）

---

### 问题 2：服务器域名未配置 ⭐⭐⭐

**症状**：网络请求失败，无法连接后端

**检查方法**：
- 打开微信开发者工具
- 点击 **"详情"**
- 查看 **"本地设置"** → **"不校验合法域名..."** 是否勾选

**解决方案**：

#### 方式 A：开发阶段（临时解决）

在微信开发者工具中：
1. 点击右上角 **"详情"**
2. 在 **"本地设置"** 标签中
3. 勾选 **"不校验合法域名、web-view（业务域名）、TLS 版本以及 HTTPS 证书"**
4. 重新编译

#### 方式 B：生产环境（推荐）

在微信公众平台配置服务器域名：

1. 登录 [微信公众平台](https://mp.weixin.qq.com/)
2. 进入 **"开发"** → **"开发管理"** → **"开发设置"**
3. 在 **"服务器域名"** 部分
4. 添加后端 API 域名到 **"request 合法域名"**
5. 例如：`https://your-backend-url.railway.app`

**注意**：
- ✅ 必须使用 HTTPS
- ✅ 必须是完整的域名（不能是 IP 地址）
- ✅ 不能带端口号（使用 443）
- ✅ 需要实名认证

---

### 问题 3：后端服务未启动 ⭐⭐

**症状**：网络请求超时或失败

**检查方法**：
```bash
# 测试后端健康检查
curl https://your-backend-url.railway.app/api/health
```

**解决方案**：

#### 如果使用 Railway 部署

1. 访问 Railway 项目页面
2. 查看服务状态
3. 如果未运行，点击 **"Redeploy"**

#### 如果使用 Coze 环境

```bash
# 启动开发服务器
cd /workspace/projects
coze dev
```

---

### 问题 4：PROJECT_DOMAIN 环境变量未配置 ⭐⭐

**症状**：网络请求 URL 错误

**检查方法**：
- 在小程序代码中查看 `src/network.ts`
- 确认 `PROJECT_DOMAIN` 是否正确配置

**解决方案**：

#### 在微信开发者工具中配置

1. 打开微信开发者工具
2. 点击右上角 **"详情"**
3. 在 **"本地设置"** 标签中
4. 确认没有额外的环境变量配置

#### 确认代码中的 PROJECT_DOMAIN

小程序应该使用固定或动态配置的后端 URL：

**方案 A：固定后端 URL**（推荐生产环境）

```typescript
// src/network.ts
export namespace Network {
    const createUrl = (url: string): string => {
        if (url.startsWith('http://') || url.startsWith('https://')) {
            return url
        }
        // 直接使用固定的后端 URL
        return `https://your-backend-url.railway.app${url}`
    }
    // ...
}
```

**方案 B：动态配置**

```typescript
// 在 app.tsx 中配置
const APP_CONFIG = {
  apiBaseUrl: 'https://your-backend-url.railway.app'
}
```

---

### 问题 5：小程序编译错误 ⭐

**症状**：小程序编译失败或空白

**检查方法**：
- 查看微信开发者工具的 **"控制台"** 输出
- 查看是否有编译错误

**解决方案**：

#### 重新编译项目

```bash
# 在项目根目录
pnpm build:weapp
```

#### 清除缓存

在微信开发者工具中：
1. 点击 **"工具"** → **"清除缓存"**
2. 选择 **"清除文件缓存"**
3. 重新编译

---

## 🔧 完整排查步骤

### 第 1 步：检查 appid

1. 打开微信开发者工具
2. 点击 **"详情"**
3. 查看 **"AppID"** 是否正确
4. 如果是 `touristappid`，修改为实际的小程序 appid

### 第 2 步：配置服务器域名

**开发阶段**：
- 勾选 **"不校验合法域名..."**

**生产环境**：
- 在微信公众平台配置合法域名

### 第 3 步：检查后端服务

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

### 第 4 步：检查网络请求

在小程序中：
1. 点击 **"详情"** → **"AppData"**
2. 查看是否有网络请求
3. 查看请求 URL 是否正确

### 第 5 步：查看控制台错误

在微信开发者工具中：
1. 点击 **"控制台"** 标签
2. 查看是否有错误信息
3. 根据错误信息修复问题

---

## 📸 常见错误信息

### 错误 1：request:fail url not in domain list

**原因**：域名未在微信公众平台的合法域名列表中

**解决方案**：
- 开发阶段：勾选 **"不校验合法域名..."**
- 生产环境：在微信公众平台添加域名

### 错误 2：request:fail (empty)

**原因**：后端服务未启动或网络不通

**解决方案**：
- 检查后端服务是否运行
- 检查网络连接
- 确认后端 URL 正确

### 错误 3：request:fail -2 net::ERR_CONNECTION_REFUSED

**原因**：后端服务拒绝连接

**解决方案**：
- 检查后端服务是否正常启动
- 检查端口是否正确
- 检查防火墙设置

### 错误 4：request:fail timeout

**原因**：请求超时

**解决方案**：
- 检查网络连接
- 增加请求超时时间
- 优化后端性能

---

## ✅ 验证修复

### 测试步骤

1. **启动小程序**
   - 在微信开发者工具中打开小程序
   - 确认小程序正常加载

2. **测试单词分析**
   - 输入单词：`hello`
   - 点击 **"开始分析"**
   - 查看是否返回结果

3. **测试语音朗读**
   - 分析单词后
   - 点击 **"朗读单词"**
   - 确认能听到发音

4. **查看控制台**
   - 查看网络请求是否成功
   - 确认没有错误信息

---

## 🚀 快速修复脚本

如果您使用 Coze 环境，可以运行以下命令：<tool_call>write_file<arg_key>content</arg_key><arg_value>#!/bin/bash

echo "=== 微信小程序问题诊断 ==="
echo ""

# 1. 检查 project.config.json
echo "1. 检查 appid 配置..."
appid=$(grep -o '"appid": "[^"]*"' project.config.json | cut -d'"' -f4)
echo "   当前 appid: $appid"
if [ "$appid" = "touristappid" ]; then
    echo "   ⚠️  警告: 使用的是测试 appid"
    echo "   请在微信开发者工具中修改为实际的小程序 appid"
fi
echo ""

# 2. 检查后端服务
echo "2. 检查后端服务..."
echo "   请输入您的后端 URL:"
read backend_url
if [ -n "$backend_url" ]; then
    echo "   测试: $backend_url/api/health"
    curl -s "$backend_url/api/health" | head -20
fi
echo ""

# 3. 检查小程序编译
echo "3. 检查小程序编译文件..."
if [ -d "dist" ]; then
    echo "   ✅ dist 目录存在"
    if [ -f "dist/app.js" ]; then
        echo "   ✅ app.js 存在"
    else
        echo "   ❌ app.js 不存在，需要重新编译"
        echo "   运行: pnpm build:weapp"
    fi
else
    echo "   ❌ dist 目录不存在，需要编译"
    echo "   运行: pnpm build:weapp"
fi
echo ""

echo "=== 诊断完成 ==="
echo ""
echo "下一步："
echo "1. 在微信开发者工具中配置正确的 appid"
echo "2. 勾选'不校验合法域名...'（开发阶段）"
echo "3. 确认后端服务正常运行"
echo "4. 重新编译小程序"
