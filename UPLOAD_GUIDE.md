# 📤 GitHub 网页界面上传指南

## ✅ 必须上传的文件清单

### 1️⃣ 核心配置文件（重要！）

这些文件必须在项目根目录：
- ✅ `package.json` - 项目依赖配置
- ✅ `tsconfig.json` - TypeScript 配置
- ✅ `.gitignore` - Git 忽略规则
- ✅ `vercel.json` - Vercel 部署配置
- ✅ `railway.toml` - Railway 部署配置
- ✅ `pnpm-lock.yaml` - 依赖锁文件
- ✅ `pnpm-workspace.yaml` - 工作区配置
- ✅ `README.md` - 项目说明
- ✅ `QUICK_DEPLOY.md` - 快速部署指南

### 2️⃣ 前端源代码（`src/` 文件夹）

**src/ 目录下的所有文件**：
- `src/app.config.ts`
- `src/app.tsx`
- `src/app.css`
- `src/network.ts`
- `src/index.html`
- `src/presets/` 文件夹及其内容
- `src/pages/` 文件夹及其内容

### 3️⃣ 后端源代码（`server/` 文件夹）

**server/ 目录下的所有文件**（不包括 node_modules）：
- `server/package.json`
- `server/tsconfig.json`
- `server/nest-cli.json`
- `server/src/` 文件夹及其所有内容

### 4️⃣ 构建产物（用于快速部署）

虽然不是必需的，但建议上传：
- ✅ `dist-web/` 文件夹（H5 构建产物）

**不需要上传的**：
- ❌ `node_modules/` 文件夹
- ❌ `dist-weapp/` 文件夹
- ❌ `server/dist/` 文件夹
- ❌ `server/node_modules/` 文件夹
- ❌ `.cozeproj/` 文件夹
- ❌ `key/` 文件夹

---

## 🎯 详细上传步骤

### 步骤 1：打开仓库
访问：https://github.com/rechard616/word-learning-app

### 步骤 2：上传配置文件

1. 点击右上角的 **"Add file"** → **"Upload files"**

2. 在本地文件管理器中打开 `/workspace/projects` 目录

3. **第一批：上传配置文件**
   选择并拖拽以下文件到上传区域：
   - `package.json`
   - `tsconfig.json`
   - `.gitignore`
   - `vercel.json`
   - `railway.toml`
   - `pnpm-lock.yaml`
   - `pnpm-workspace.yaml`
   - `README.md`
   - `QUICK_DEPLOY.md`
   - `design_guidelines.md`

4. 在 "Commit changes" 中填写：
   - "Add an extended description": `配置文件上传`

5. 点击 **"Commit changes"**

### 步骤 3：上传前端代码

1. 再次点击 **"Add file"** → **"Upload files"**

2. 创建文件夹：在 GitHub 页面中，输入文件夹名称 `src` 并回车

3. 进入 `src/` 文件夹

4. 上传以下文件：
   - `app.config.ts`
   - `app.tsx`
   - `app.css`
   - `network.ts`
   - `index.html`
   - `presets/` 文件夹（整个文件夹拖拽）
   - `pages/` 文件夹（整个文件夹拖拽）

5. 提交信息：`添加前端源代码`

### 步骤 4：上传后端代码

1. 点击 **"Add file"** → **"Upload files"**

2. 创建文件夹：输入 `server` 并回车

3. 进入 `server/` 文件夹

4. 上传文件：
   - `package.json`
   - `tsconfig.json`
   - `nest-cli.json`
   - `src/` 文件夹（整个文件夹拖拽，包含所有子文件）

5. 提交信息：`添加后端源代码`

### 步骤 5：上传 H5 构建产物（可选，但推荐）

1. 点击 **"Add file"** → **"Upload files"**

2. 创建文件夹：输入 `dist-web` 并回车

3. 进入 `dist-web/` 文件夹

4. 上传所有内容：
   - `index.html`
   - `js/` 文件夹

5. 提交信息：`添加 H5 构建产物`

---

## 📋 上传文件完整清单

### 根目录文件（9 个）
```
✅ package.json
✅ tsconfig.json
✅ .gitignore
✅ vercel.json
✅ railway.toml
✅ pnpm-lock.yaml
✅ pnpm-workspace.yaml
✅ README.md
✅ QUICK_DEPLOY.md
```

### src/ 目录（1 个文件夹 + 7 个文件）
```
src/
  ✅ app.config.ts
  ✅ app.tsx
  ✅ app.css
  ✅ network.ts
  ✅ index.html
  ✅ presets/（整个文件夹）
  ✅ pages/（整个文件夹）
```

### server/ 目录（3 个文件 + 1 个文件夹）
```
server/
  ✅ package.json
  ✅ tsconfig.json
  ✅ nest-cli.json
  ✅ src/（整个文件夹，包含所有子文件）
```

### dist-web/ 目录（可选）
```
dist-web/
  ✅ index.html
  ✅ js/（整个文件夹）
```

---

## 🔍 验证上传结果

上传完成后，在 GitHub 仓库页面检查：

1. **文件结构**应该包含：
   ```
   word-learning-app/
   ├── package.json
   ├── tsconfig.json
   ├── vercel.json
   ├── railway.toml
   ├── src/
   │   ├── app.config.ts
   │   ├── app.tsx
   │   ├── pages/
   │   └── ...
   ├── server/
   │   ├── package.json
   │   ├── src/
   │   └── ...
   ├── dist-web/（可选）
   └── ...
   ```

2. **检查关键文件**：
   - 点击 `vercel.json`，确认内容正确
   - 点击 `railway.toml`，确认内容正确
   - 点击 `server/src/word/word.service.ts`，确认代码完整

---

## 🚀 上传完成后

一旦所有文件上传成功，您就可以：

### 1. 部署后端到 Railway
访问：https://railway.app/
1. 点击 "New Project" → "Deploy from GitHub repo"
2. 选择 `word-learning-app` 仓库
3. 设置 Root Directory 为 `server`
4. 点击 Deploy

### 2. 部署前端到 Vercel
访问：https://vercel.com/
1. 点击 "Add New" → "Project"
2. 选择 `word-learning-app` 仓库
3. 添加环境变量：
   - Key: `PROJECT_DOMAIN`
   - Value: `https://your-backend-url.up.railway.app`
4. 点击 Deploy

---

## 💡 提示

- **批量上传**：可以一次性拖拽多个文件
- **文件夹上传**：可以拖拽整个文件夹
- **提交信息**：每次上传都要填写清晰的提交信息
- **耐心等待**：大文件夹上传可能需要几分钟

---

## ❓ 遇到问题？

如果上传过程中遇到问题：
- 文件过大：可以分批上传
- 网络超时：刷新页面重试
- 权限错误：确认您是仓库所有者

---

**准备好开始上传了吗？** 🚀

按照上面的步骤，依次上传所有文件即可！
