# 单词学习小程序设计指南

## 1. 品牌定位

**应用定位**: 智能单词学习助手，帮助用户快速学习英语单词
**设计风格**: 简洁、专业、易读
**目标用户**: 英语学习者（学生、职场人士）

## 2. 配色方案

### 主色调
- 主色（Primary）: `blue-500` (#3b82f6) - 用于按钮、高亮、重点信息
- 辅色（Secondary）: `indigo-500` (#6366f1) - 用于次要按钮、装饰

### 中性色
- 文本主色: `text-gray-900` (#111827) - 标题、主要内容
- 文本次色: `text-gray-600` (#4b5563) - 正文、说明文字
- 文本弱色: `text-gray-400` (#9ca3af) - 占位符、辅助信息

### 背景色
- 页面背景: `bg-gray-50` (#f9fafb) - 整体背景
- 卡片背景: `bg-white` (#ffffff) - 内容区域
- 输入框背景: `bg-gray-100` (#f3f4f6) - 输入区域

### 语义色
- 成功/正确: `green-500` (#22c55e)
- 错误/警告: `red-500` (#ef4444)
- 加载中: `blue-400` (#60a5fa)

## 3. 字体规范

### 标题层级
- H1 (页面标题): `text-2xl font-bold` (24px, 粗体)
- H2 (卡片标题): `text-xl font-semibold` (20px, 半粗体)
- H3 (小节标题): `text-lg font-medium` (18px, 中等)

### 正文层级
- 正文大: `text-base` (16px)
- 正文小: `text-sm` (14px)
- 辅助文字: `text-xs` (12px)

### 特殊样式
- 单词: `text-xl font-bold text-blue-600`
- 音标: `text-sm text-gray-500 italic`
- 例句: `text-base text-gray-700`

## 4. 间距系统

### 页面间距
- 页面边距: `p-4` (16px)
- 卡片间距: `gap-4` (16px)
- 组件间距: `gap-3` (12px)

### 卡片内边距
- 大卡片: `p-6` (24px)
- 中卡片: `p-4` (16px)
- 小卡片: `p-3` (12px)

### 间距缩写
- 极小: `gap-1` (4px)
- 小: `gap-2` (8px)
- 中: `gap-3` (12px)
- 大: `gap-4` (16px)
- 超大: `gap-6` (24px)

## 5. 组件规范

### 按钮

**主按钮** (Primary Button):
```tsx
<Button className="w-full bg-blue-500 text-white rounded-xl py-3 text-base font-medium">
  提交
</Button>
```

**次按钮** (Secondary Button):
```tsx
<Button className="w-full bg-indigo-50 text-indigo-600 rounded-xl py-3 text-base font-medium">
  取消
</Button>
```

**禁用状态**:
```tsx
<Button disabled className="w-full bg-gray-300 text-gray-500 rounded-xl py-3 text-base">
  提交
</Button>
```

### 卡片

**信息卡片**:
```tsx
<View className="bg-white rounded-2xl p-6 shadow-sm">
  <Text className="block text-xl font-semibold mb-3">卡片标题</Text>
  <Text className="block text-base text-gray-600">卡片内容</Text>
</View>
```

**单词卡片**:
```tsx
<View className="bg-white rounded-2xl p-6 shadow-sm mb-4">
  <Text className="block text-2xl font-bold text-blue-600 mb-2">单词</Text>
  <Text className="block text-sm text-gray-500 italic mb-4">/音标/</Text>
  <View className="flex items-center gap-2 mb-3">
    <View className="bg-blue-100 text-blue-700 px-3 py-1 rounded-full">
      <Text className="block text-sm">词性</Text>
    </View>
  </View>
  <Text className="block text-base text-gray-700 mb-4">中文意思</Text>
  <View className="border-t border-gray-200 pt-4">
    <Text className="block text-sm text-gray-500 mb-2">例句</Text>
    <Text className="block text-base text-gray-700">例句内容</Text>
  </View>
</View>
```

### 输入框

**文本输入框** (H5/小程序兼容):
```tsx
<View className="bg-white rounded-xl shadow-sm mb-4">
  <View className="px-4 py-3">
    <Input
      className="w-full text-base bg-transparent"
      placeholder="请输入单词"
      placeholderClass="text-gray-400"
    />
  </View>
</View>
```

### 空状态

**空状态卡片**:
```tsx
<View className="flex flex-col items-center justify-center py-16">
  <Text className="block text-6xl mb-4">📚</Text>
  <Text className="block text-lg font-semibold text-gray-900 mb-2">还没有学习记录</Text>
  <Text className="block text-base text-gray-500">输入单词开始学习吧</Text>
</View>
```

### 加载状态

**加载中卡片**:
```tsx
<View className="flex items-center justify-center py-16">
  <Text className="block text-base text-blue-500">正在分析单词...</Text>
</View>
```

### 朗读按钮

**朗读按钮**:
```tsx
<View className="flex items-center justify-center gap-3 mt-4">
  <View className="flex-1">
    <Button className="w-full bg-green-500 text-white rounded-xl py-3 text-base font-medium flex items-center justify-center gap-2">
      <Text className="block">🔊 朗读单词</Text>
    </Button>
  </View>
  <View className="flex-1">
    <Button className="w-full bg-indigo-500 text-white rounded-xl py-3 text-base font-medium flex items-center justify-center gap-2">
      <Text className="block">🎧 朗读例句</Text>
    </Button>
  </View>
</View>
```

## 6. 导航结构

**应用为单页应用，使用简单的顶部导航**

```typescript
// src/app.config.ts
export default defineAppConfig({
  pages: [
    'pages/index/index'
  ],
  window: {
    backgroundTextStyle: 'light',
    navigationBarBackgroundColor: '#ffffff',
    navigationBarTitleText: '单词学习',
    navigationBarTextStyle: 'black'
  }
})
```

## 7. 小程序约束

### 包体积限制
- 主包大小限制: 2MB
- 整个小程序所有分包大小限制: 20MB
- 单个分包大小限制: 2MB

### 图片策略
- 优先使用 Tailwind 颜色和样式
- 必要时使用 emoji 替代图标
- 避免使用大图片

### 性能优化
- 使用 Taro 的按需加载
- 避免频繁的 API 调用
- 合理使用缓存

### 网络请求
- 所有请求使用 `Network.request` 封装
- 添加加载状态提示
- 处理错误情况

## 8. 跨端兼容性规范

### H5/小程序通用规则

**Text 组件**:
- 所有需要垂直排列的 Text 必须添加 `block` 类
- 小程序端 Text 默认 block，H5 端默认 inline

**Input 组件**:
- 必须使用 View 包裹，样式放在 View 上
- Input 设置 `className="w-full bg-transparent"`

**平台检测**:
- 使用 `const isWeapp = Taro.getEnv() === Taro.ENV_TYPE.WEAPP` 直接判断

**示例**:
```tsx
// ✅ 正确：Text 添加 block 类
<Text className="block text-xl font-bold">单词</Text>

// ❌ 错误：H5 端会白屏
<Text className="text-xl font-bold">单词</Text>

// ✅ 正确：Input 用 View 包裹
<View className="bg-white rounded-xl p-4">
  <Input className="w-full bg-transparent" placeholder="请输入" />
</View>

// ❌ 错误：H5 端样式失效
<Input className="bg-white rounded-xl p-4 w-full" placeholder="请输入" />
```

## 9. 交互规范

### 页面加载
- 显示加载状态："正在分析单词..."

### 错误处理
- 显示错误提示："单词分析失败，请重试"
- 使用 `Taro.showToast()` 显示短暂提示

### 成功状态
- 显示分析结果
- 自动聚焦到朗读按钮

### 朗读功能
- 朗读中禁用按钮
- 朗读完成后恢复按钮
- 使用 Taro 内置音频播放 API

## 10. 颜色使用总结

### 常用 Tailwind 类名
- 蓝色系: `bg-blue-500`, `text-blue-600`, `bg-blue-100`, `text-blue-700`
- 灰色系: `bg-gray-50`, `text-gray-900`, `text-gray-600`, `text-gray-400`
- 绿色系: `bg-green-500`, `text-green-700`, `bg-green-100`
- 红色系: `bg-red-500`, `text-red-600`, `bg-red-100`
- 白色: `bg-white`, `text-white`
- 圆角: `rounded-xl`, `rounded-2xl`, `rounded-full`
- 阴影: `shadow-sm`, `shadow-md`
