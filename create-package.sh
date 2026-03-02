#!/bin/bash

# 创建可下载的项目包

echo "📦 正在创建项目包..."
echo ""

# 创建临时打包目录
PACK_DIR="/tmp/word-learning-app"
rm -rf $PACK_DIR
mkdir -p $PACK_DIR

# 复制必要的文件和目录
echo "📋 复制文件..."

# 根目录文件
cp package.json $PACK_DIR/
cp tsconfig.json $PACK_DIR/
cp .gitignore $PACK_DIR/
cp vercel.json $PACK_DIR/
cp railway.toml $PACK_DIR/
cp pnpm-lock.yaml $PACK_DIR/
cp pnpm-workspace.yaml $PACK_DIR/
cp README.md $PACK_DIR/
cp QUICK_DEPLOY.md $PACK_DIR/
cp UPLOAD_GUIDE.md $PACK_DIR/

# 前端代码
cp -r src $PACK_DIR/

# 后端代码
cp -r server $PACK_DIR/

# H5 构建产物（可选）
if [ -d "dist-web" ]; then
    cp -r dist-web $PACK_DIR/
fi

# 创建打包说明
cat > $PACK_DIR/上传说明.txt << 'EOF'
========================================
单词学习小程序 - 上传到 GitHub 指南
========================================

本项目已打包完成，包含所有必要文件。

如何上传到 GitHub：

方法一：在 GitHub 网页界面上传

1. 访问：https://github.com/rechard616/word-learning-app
2. 点击右上角 "Add file" → "Upload files"
3. 从电脑拖拽此文件夹中的所有文件到 GitHub
4. 点击 "Commit changes"

方法二：使用 Git 命令行上传

1. 打开终端，进入此文件夹目录
2. 执行以下命令：

   git init
   git add .
   git commit -m "feat: 单词学习小程序初始版本"
   git remote add origin https://github.com/rechard616/word-learning-app.git
   git branch -M main
   git push -u origin main

上传完成后，可以开始部署：

后端部署：https://railway.app/
前端部署：https://vercel.com/

详细部署步骤请查看 QUICK_DEPLOY.md 文件。
========================================
EOF

# 创建压缩包
echo "📦 创建压缩包..."
cd /tmp
tar -czf word-learning-app.tar.gz word-learning-app/

echo ""
echo "✅ 项目包已创建！"
echo ""
echo "📍 压缩包位置：/tmp/word-learning-app.tar.gz"
echo "📦 项目目录：/tmp/word-learning-app"
echo ""
echo "💡 如何使用："
echo ""
echo "1. 下载压缩包到您的电脑"
echo "2. 解压缩"
echo "3. 在电脑上打开 GitHub 仓库："
echo "   https://github.com/rechard616/word-learning-app"
echo "4. 点击 'Add file' → 'Upload files'"
echo "5. 拖拽所有文件到 GitHub 上传区域"
echo "6. 点击 'Commit changes'"
echo ""
