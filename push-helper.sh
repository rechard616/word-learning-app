#!/bin/bash

# GitHub 推送助手脚本

echo "🚀 GitHub 推送助手"
echo "=================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 检查当前 Git 状态
echo -e "${BLUE}📋 当前状态检查${NC}"
echo ""

# 检查分支
echo -n "当前分支: "
git branch --show-current

# 检查远程仓库
echo -n "远程仓库: "
if git remote get-url origin > /dev/null 2>&1; then
    git remote get-url origin
else
    echo -e "${YELLOW}未配置${NC}"
fi

# 检查待提交的更改
echo -n "待提交的更改: "
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}有未提交的更改${NC}"
    git status --short
else
    echo -e "${GREEN}无（工作区干净）${NC}"
fi

# 检查待推送的提交
if git remote get-url origin > /dev/null 2>&1; then
    echo -n "待推送的提交: "
    if [ -n "$(git log origin/main..HEAD --oneline 2>/dev/null)" ]; then
        echo -e "${YELLOW}有${NC}"
        git log origin/main..HEAD --oneline
    else
        echo -e "${GREEN}无（已同步）${NC}"
    fi
fi

echo ""
echo "=================="
echo ""

# 提供操作建议
if git remote get-url origin > /dev/null 2>&1; then
    echo -e "${GREEN}✓ 远程仓库已配置${NC}"
    echo ""
    echo "推送命令："
    echo -e "${BLUE}git push -u origin main${NC}"
    echo ""
else
    echo -e "${YELLOW}⚠️  远程仓库未配置${NC}"
    echo ""
    echo "请先完成以下步骤："
    echo "1. 访问 GitHub 创建仓库: https://github.com/new"
    echo "2. 仓库名称: word-learning-app"
    echo "3. 复制仓库 URL"
    echo ""
    echo "然后执行："
    echo ""
    echo "# 添加远程仓库（替换为你的仓库地址）"
    echo -e "${BLUE}git remote add origin https://github.com/your-username/word-learning-app.git${NC}"
    echo ""
    echo "# 推送代码"
    echo -e "${BLUE}git branch -M main${NC}"
    echo -e "${BLUE}git push -u origin main${NC}"
    echo ""
fi

# 检查是否有未提交的更改
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}⚠️  有未提交的更改${NC}"
    echo ""
    echo "请先提交更改："
    echo -e "${BLUE}git add .${NC}"
    echo -e "${BLUE}git commit -m '描述你的修改'${NC}"
    echo ""
fi

echo "详细说明请查看: ${BLUE}PUSH_TO_GITHUB.md${NC}"
