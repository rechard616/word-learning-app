# 🔧 小程序预览错误修复指南

## 🚨 错误信息

```
errCode: 20003
errMsg: "3rd upload or preview error, dev platform ext appid not auth"
```

---

## 🔍 问题原因

**当前配置**：
```json
{
  "appid": "touristappid"
}
```

**问题分析**：
1. `touristappid` 是微信开发者工具的**测试 appid**
2. 测试 appid **不支持**通过 `miniprogram-ci` 进行预览和上传
3. 需要使用**真实的小程序 appid**

---

## ✅ 解决方案

### 方案 A：修改为真实的小程序 appid（推荐）

#### 步骤 1：获取真实的小程序 appid

如果您还没有小程序，需要先创建：

1. 访问 [微信公众平台](https://mp.weixin.qq.com/)
2. 点击 **"立即注册"**
3. 选择 **"小程序"**
4. 填写账号信息并完成注册
5. 完成认证（个人或企业）

注册完成后，在 **"设置"** → **"基本设置"** 中可以看到您的 **AppID**

#### 步骤 2：修改配置文件

编辑 `project.config.json`：

```json
{
  "miniprogramRoot": "./dist",
  "projectname": "word-learning-app",
  "description": "单词学习助手",
  "appid": "your_actual_appid_here",  // ← 替换为你的 appid
  "setting": {
    "urlCheck": false,  // 开发阶段设为 false
    "es6": true,
    "enhance": true,
    "compileHotReLoad": true,
    "postcss": true,
    "minified": true
  },
  "compileType": "miniprogram"
}
```

**重要**：
- 将 `"appid": "touristappid"` 改为您的真实 appid
- 例如：`"appid": "wx1234567890abcdef"`

#### 步骤 3：重新编译

```bash
pnpm build:weapp
```

#### 步骤 4：使用微信开发者工具预览

1. 打开微信开发者工具
2. 导入项目（选择 `dist` 文件夹）
3. 使用真实 appid 导入
4. 点击 **"预览"** 生成二维码
5. 扫码预览

---

### 方案 B：使用微信开发者工具直接预览（开发阶段）

如果您还没有小程序 appid，可以在开发阶段使用：

#### 步骤 1：修改配置

保持 `project.config.json` 中的 appid 为 `touristappid`：

```json
{
  "appid": "touristappid"
}
```

#### 步骤 2：使用微信开发者工具预览

1. 打开微信开发者工具
2. 导入项目（选择 `dist` 文件夹）
3. 使用 **"测试号"** 模式
4. 点击 **"预览"** 生成二维码
5. 扫码预览

**注意**：
- ⚠️ 测试号功能有限
- ⚠️ 某些 API 可能无法使用
- ⚠️ 发布到线上必须使用真实 appid

---

## 🔧 在 Coze 环境中修改

如果您在 Coze 环境中，我可以帮您修改配置：<tool_call>write_file<arg_key>content</arg_key><arg_value>#!/bin/bash

echo "=== 小程序 appid 修复脚本 ==="
echo ""

# 备份原配置
cp project.config.json project.config.json.backup

echo "✓ 已备份原配置到 project.config.json.backup"
echo ""

echo "请输入您的小程序 appid："
read new_appid

if [ -z "$new_appid" ]; then
    echo "❌ 错误：appid 不能为空"
    exit 1
fi

# 修改 appid
sed -i "s/\"appid\": \"touristappid\"/\"appid\": \"$new_appid\"/g" project.config.json

echo ""
echo "✓ 已修改 appid 为: $new_appid"
echo ""

# 重新编译
echo "正在重新编译小程序..."
pnpm build:weapp

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ 编译成功"
    echo ""
    echo "下一步："
    echo "1. 打开微信开发者工具"
    echo "2. 导入项目（选择 dist 文件夹）"
    echo "3. 使用 appid: $new_appid"
    echo "4. 点击预览生成二维码"
else
    echo ""
    echo "❌ 编译失败"
    echo "已恢复原配置"
    mv project.config.json.backup project.config.json
    exit 1
fi
