#!/bin/bash

echo "=========================================="
echo "📱 微信小程序快速部署脚本"
echo "=========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# 步骤 1：检查项目状态
echo -e "${BLUE}📋 第 1 步：检查项目状态${NC}"
echo ""

if [ ! -f "project.config.json" ]; then
    echo -e "${RED}❌ 未找到 project.config.json${NC}"
    exit 1
fi

echo "当前 AppID："
grep '"appid"' project.config.json
echo ""

# 步骤 2：检查 AppID
echo -e "${BLUE}📋 第 2 步：检查 AppID${NC}"
echo ""

if grep -q '"touristappid"' project.config.json; then
    echo -e "${YELLOW}⚠️  当前使用的是测试 AppID${NC}"
    echo ""
    echo "测试 AppID 不支持发布到线上"
    echo ""
    echo "请先完成以下步骤："
    echo "1. 访问 https://mp.weixin.qq.com/"
    echo "2. 注册小程序"
    echo "3. 获取真实 AppID"
    echo "4. 修改 project.config.json 中的 AppID"
    echo ""
    echo "是否需要修改 AppID？(y/n)"
    read answer
    
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        echo ""
        echo "请输入您的小程序 AppID（格式：wx1234567890abcdef）："
        read new_appid
        
        if [ -z "$new_appid" ]; then
            echo -e "${RED}❌ AppID 不能为空${NC}"
            exit 1
        fi
        
        # 备份原配置
        cp project.config.json project.config.json.backup
        
        # 修改 AppID
        sed -i "s/\"appid\": \"touristappid\"/\"appid\": \"$new_appid\"/g" project.config.json
        
        echo -e "${GREEN}✓ 已修改 AppID 为: $new_appid${NC}"
    else
        echo -e "${YELLOW}跳过 AppID 修改${NC}"
    fi
else
    echo -e "${GREEN}✓ 已使用真实 AppID${NC}"
fi

echo ""

# 步骤 3：检查 urlCheck 配置
echo -e "${BLUE}📋 第 3 步：检查 urlCheck 配置${NC}"
echo ""

if grep -q '"urlCheck": false' project.config.json; then
    echo -e "${YELLOW}⚠️  urlCheck 设为 false${NC}"
    echo ""
    echo "这是开发阶段的配置"
    echo "发布前需要改为 true"
    echo ""
    echo "是否现在修改为 true？(y/n)"
    read answer
    
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        sed -i 's/"urlCheck": false/"urlCheck": true/g' project.config.json
        echo -e "${GREEN}✓ 已修改 urlCheck 为 true${NC}"
    fi
else
    echo -e "${GREEN}✓ urlCheck 配置正确${NC}"
fi

echo ""

# 步骤 4：编译小程序
echo -e "${BLUE}📋 第 4 步：编译小程序${NC}"
echo ""

echo "正在编译..."
pnpm build:weapp

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 编译成功${NC}"
    echo ""
    echo "编译输出：dist/"
    echo ""
else
    echo -e "${RED}❌ 编译失败${NC}"
    exit 1
fi

# 步骤 5：检查编译结果
echo -e "${BLUE}📋 第 5 步：检查编译结果${NC}"
echo ""

if [ -f "dist/app.js" ] && [ -f "dist/app.json" ]; then
    echo -e "${GREEN}✓ 编译文件完整${NC}"
    echo ""
    echo "主要文件："
    ls -lh dist/ | head -10
else
    echo -e "${RED}❌ 编译文件不完整${NC}"
    exit 1
fi

echo ""

# 步骤 6：配置服务器域名
echo -e "${BLUE}📋 第 6 步：配置服务器域名${NC}"
echo ""

echo "后端服务配置："
echo ""
echo "请确认以下事项："
echo "1. 后端服务已部署并可公网访问"
echo "2. 后端使用 HTTPS 协议"
echo "3. 域名已备案（如在中国大陆）"
echo ""
echo "后端健康检查测试："
echo "  curl https://your-backend-url.railway.app/api/health"
echo ""
echo "添加合法域名："
echo "1. 登录 https://mp.weixin.qq.com/"
echo "2. 进入 开发 → 开发管理 → 开发设置"
echo "3. 在 request 合法域名中添加后端 URL"
echo ""

# 步骤 7：上传和发布
echo -e "${BLUE}📋 第 7 步：上传和发布${NC}"
echo ""

echo "接下来的步骤："
echo ""
echo "1. 打开微信开发者工具"
echo "2. 导入项目（选择 dist 文件夹）"
echo "3. 使用 AppID 导入"
echo "4. 点击预览，测试功能"
echo "5. 点击上传，填写版本号和备注"
echo "6. 登录微信公众平台，提交审核"
echo "7. 等待审核通过"
echo "8. 点击发布"
echo ""

# 步骤 8：总结
echo "=========================================="
echo -e "${GREEN}✓ 部署准备完成${NC}"
echo "=========================================="
echo ""
echo "已完成："
echo "  ✓ 项目状态检查"
echo "  ✓ AppID 配置"
echo "  ✓ urlCheck 配置"
echo "  ✓ 代码编译"
echo "  ✓ 编译结果验证"
echo ""
echo "接下来需要："
echo "  1. 配置服务器域名（在微信公众平台）"
echo "  2. 使用微信开发者工具上传代码"
echo "  3. 提交审核"
echo "  4. 发布上线"
echo ""
echo "详细文档：${BLUE}WEAPP_DEPLOYMENT.md${NC}"
echo "快速开始："
echo "  访问：https://mp.weixin.qq.com/"
echo ""
