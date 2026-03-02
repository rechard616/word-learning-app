#!/bin/bash

# 部署前检查脚本

echo "🔍 部署前检查工具"
echo "=================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

all_passed=true

# 检查 1: Git 仓库
echo -n "检查 Git 仓库... "
if [ -d ".git" ]; then
    echo -e "${GREEN}✓ 已初始化${NC}"
else
    echo -e "${RED}✗ 未初始化${NC}"
    all_passed=false
fi

# 检查 2: 远程仓库
echo -n "检查远程仓库... "
if git remote get-url origin > /dev/null 2>&1; then
    echo -e "${GREEN}✓ 已配置${NC}"
    echo "  URL: $(git remote get-url origin)"
else
    echo -e "${YELLOW}⚠️  未配置${NC}"
    echo "  提示: 运行 'git remote add origin <repo-url>'"
    all_passed=false
fi

# 检查 3: 必要文件
echo -n "检查必要文件... "
required_files=("vercel.json" "railway.toml" ".env.example" "src/network.ts")
missing_files=()
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -eq 0 ]; then
    echo -e "${GREEN}✓ 全部存在${NC}"
else
    echo -e "${RED}✗ 缺少文件${NC}"
    for file in "${missing_files[@]}"; do
        echo "  - $file"
    done
    all_passed=false
fi

# 检查 4: 构建产物
echo -n "检查构建产物... "
if [ -d "dist-web" ] && [ -f "dist-web/index.html" ]; then
    echo -e "${GREEN}✓ H5 构建完成${NC}"
else
    echo -e "${YELLOW}⚠️  未构建${NC}"
    echo "  提示: 运行 'pnpm build:web'"
    all_passed=false
fi

# 检查 5: 后端构建
echo -n "检查后端构建... "
if [ -d "server/dist" ] && [ -f "server/dist/main.js" ]; then
    echo -e "${GREEN}✓ 后端构建完成${NC}"
else
    echo -e "${YELLOW}⚠️  未构建${NC}"
    echo "  提示: 运行 'pnpm build:server'"
    all_passed=false
fi

# 检查 6: package.json
echo -n "检查依赖配置... "
if [ -f "package.json" ]; then
    echo -e "${GREEN}✓ 配置正确${NC}"
else
    echo -e "${RED}✗ 缺少 package.json${NC}"
    all_passed=false
fi

# 检查 7: 环境变量
echo -n "检查环境变量配置... "
if [ -f ".env.example" ]; then
    echo -e "${GREEN}✓ 已提供示例${NC}"
else
    echo -e "${YELLOW}⚠️  缺少示例文件${NC}"
fi

echo ""
echo "=================="

if [ "$all_passed" = true ]; then
    echo -e "${GREEN}🎉 所有检查通过！可以开始部署了${NC}"
    echo ""
    echo "下一步："
    echo "1. 查看 QUICK_DEPLOY.md 了解详细部署步骤"
    echo "2. 创建 GitHub 仓库并推送代码"
    echo "3. 访问 https://railway.app/ 部署后端"
    echo "4. 访问 https://vercel.com/ 部署前端"
else
    echo -e "${YELLOW}⚠️  发现一些问题，请解决后再部署${NC}"
    echo ""
    echo "建议操作："
    echo "1. 初始化 Git: git init"
    echo "2. 配置远程仓库: git remote add origin <repo-url>"
    echo "3. 构建项目: pnpm build"
    echo "4. 提交代码: git add . && git commit -m 'feat: ready to deploy'"
fi

echo ""
