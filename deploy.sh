#!/bin/bash

# 单词学习小程序部署脚本

echo "🚀 单词学习小程序 - 部署助手"
echo "================================"

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查 Git 是否初始化
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Git 未初始化，正在初始化...${NC}"
    git init
    echo -e "${GREEN}✓ Git 初始化完成${NC}"
fi

# 检查是否已配置远程仓库
if ! git remote get-url origin > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  未配置远程仓库${NC}"
    echo "请执行以下步骤："
    echo "1. 在 GitHub 创建新仓库"
    echo "2. 运行: git remote add origin <your-repo-url>"
    echo "3. 运行: git add ."
    echo "4. 运行: git commit -m 'feat: 单词学习小程序'"
    echo "5. 运行: git push -u origin main"
    exit 1
fi

# 显示当前状态
echo -e "\n${GREEN}📋 当前状态：${NC}"
echo "Git 仓库: $(git remote get-url origin)"
echo "当前分支: $(git branch --show-current)"

# 部署步骤提示
echo -e "\n${YELLOW}📝 部署步骤：${NC}"
echo ""
echo "1️⃣  后端部署 (Railway)"
echo "   - 访问: https://railway.app/"
echo "   - 创建新项目 → 选择 GitHub 仓库"
echo "   - 自动部署后端"
echo "   - 复制后端 URL"
echo ""
echo "2️⃣  前端部署 (Vercel)"
echo "   - 访问: https://vercel.com/"
echo "   - 创建新项目 → 选择 GitHub 仓库"
echo "   - 配置环境变量: PROJECT_DOMAIN=<后端URL>"
echo "   - 点击部署"
echo ""
echo "3️⃣  获取访问链接"
echo "   - Vercel 会提供永久访问链接"
echo "   - 例如: https://word-learning.vercel.app"
echo ""

read -p "是否查看部署详细文档？(y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cat DEPLOYMENT.md
fi
