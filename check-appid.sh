#!/bin/bash

echo "=== 小程序预览错误修复 ==="
echo ""

# 检查当前配置
echo "当前 appid 配置："
grep '"appid"' project.config.json
echo ""

if grep -q '"touristappid"' project.config.json; then
    echo "⚠️  当前使用的是测试 appid"
    echo ""
    echo "问题：测试 appid 不支持 miniprogram-ci 预览"
    echo ""
    echo "解决方案："
    echo "1. 在微信公众平台注册小程序"
    echo "2. 获取真实的小程序 appid"
    echo "3. 修改 project.config.json 中的 appid"
    echo "4. 重新编译"
    echo ""
    echo "注册地址：https://mp.weixin.qq.com/"
else
    echo "✓ 已使用真实 appid"
    echo ""
    echo "下一步："
    echo "1. 重新编译: pnpm build:weapp"
    echo "2. 使用微信开发者工具预览"
fi
