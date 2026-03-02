#!/bin/bash

# 创建完整的项目包

echo "📦 正在创建完整的项目包..."
echo ""

# 创建临时打包目录
PACK_DIR="/tmp/word-learning-app-complete"
rm -rf $PACK_DIR
mkdir -p $PACK_DIR

echo "📋 复制文件..."

# 复制根目录配置文件
files=(
    "package.json"
    "tsconfig.json"
    ".gitignore"
    "vercel.json"
    "railway.toml"
    "pnpm-lock.yaml"
    "pnpm-workspace.yaml"
    "README.md"
    "QUICK_DEPLOY.md"
    "UPLOAD_GUIDE.md"
    "DEPLOYMENT.md"
    "project.config.json"
    "tsconfig.json"
    "package.json"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" $PACK_DIR/
        echo "  ✓ $file"
    fi
done

# 复制前端代码
echo "  复制前端代码..."
cp -r src $PACK_DIR/

# 复制后端代码（排除 node_modules）
echo "  复制后端代码..."
cp -r server $PACK_DIR/

# 删除不需要的文件
echo "  清理不需要的文件..."
rm -rf $PACK_DIR/server/node_modules
rm -rf $PACK_DIR/server/dist
rm -rf $PACK_DIR/node_modules
rm -rf $PACK_DIR/dist
rm -rf $PACK_DIR/dist-web
rm -rf $PACK_DIR/dist-weapp
rm -rf $PACK_DIR/.git
rm -rf $PACK_DIR/.cozeproj
rm -rf $PACK_DIR/key

# 创建上传说明
cat > $PACK_DIR/上传说明.txt << 'EOF'
========================================
单词学习小程序 - 上传到 GitHub 指南
========================================

本项目已打包完成，包含所有必要文件。

💡 快速上传方法（推荐）：

1. 打开 GitHub 仓库：
   https://github.com/rechard616/word-learning-app

2. 点击右上角 "Add file" → "Upload files"

3. 全选所有文件和文件夹（Ctrl+A 或 Cmd+A）

4. 拖拽到 GitHub 上传区域

5. 提交信息填写：feat: 单词学习小程序初始版本

6. 点击 "Commit changes"

✅ 上传完成！

🚀 部署步骤：

后端部署：
1. 访问 https://railway.app/
2. New Project → Deploy from GitHub
3. 选择 word-learning-app 仓库
4. Root Directory 设置为 server
5. 点击 Deploy

前端部署：
1. 访问 https://vercel.com/
2. Add New → Project
3. 选择 word-learning-app 仓库
4. 添加环境变量：
   Key: PROJECT_DOMAIN
   Value: https://your-backend-url.railway.app
5. 点击 Deploy

📖 详细说明请查看：
- QUICK_DEPLOY.md（快速部署指南）
- UPLOAD_GUIDE.md（上传详细指南）

========================================
EOF

# 创建压缩包
echo "📦 创建压缩包..."
cd /tmp
tar -czf word-learning-app-complete.tar.gz word-learning-app-complete/

echo ""
echo "✅ 完整项目包已创建！"
echo ""
echo "📍 压缩包位置：/tmp/word-learning-app-complete.tar.gz"
echo "📦 项目目录：/tmp/word-learning-app-complete"
echo ""
echo "📊 包含内容："
echo "  - src/（前端代码）"
echo "  - server/（后端代码）"
echo "  - package.json（依赖配置）"
echo "  - vercel.json（Vercel 配置）"
echo "  - railway.toml（Railway 配置）"
echo "  - 所有文档和说明文件"
echo ""
echo "💡 如何使用："
echo ""
echo "1. 下载压缩包到您的电脑"
echo "   文件：/tmp/word-learning-app-complete.tar.gz"
echo ""
echo "2. 解压缩"
echo ""
echo "3. 在电脑上打开 GitHub 仓库"
echo "   https://github.com/rechard616/word-learning-app"
echo ""
echo "4. 点击 'Add file' → 'Upload files'"
echo ""
echo "5. 全选所有文件，拖拽到上传区域"
echo ""
echo "6. 提交信息填写：feat: 单词学习小程序初始版本"
echo ""
echo "7. 点击 'Commit changes'"
echo ""
