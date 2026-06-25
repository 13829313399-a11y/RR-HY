# 绿色 RR 品牌视觉重构 实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 把河源工具门户外壳从蓝色主题重构为企业品牌绿（#10B981）视觉体系，核心符号为内联 SVG 的绿色 RR 圆形 LOGO，配轻量交互动效，移动端自适应。

**Architecture:** 在 `src/style.css` 注入一套 CSS 变量（design tokens）作为全站单一色彩来源；新建 `BrandLogo.vue` 提供可复用的内联 SVG RR 徽标；`Home.vue` 与 `HeyuanMaterial.vue` 改用 tokens + 动效类；favicon/title 同步换绿；删除未引用的脚手架文件。填单工具 `public/tools/heyuan-material/index.html` 内部完全不动。

**Tech Stack:** Vue 3.5（`<script setup>`）、Vue Router 4、Vite 8、纯 CSS transition（无动画库）。

## Global Constraints

- 品牌主绿 `#10B981`，加深 `#059669`，提亮 `#34d399`，浅底 `#ecfdf5`，描边 `#d1fae5`，投影 `rgba(16,185,129,.10)`。这些值只在 `:root` 定义一次，其余文件一律用 `var(--xxx)`，不准再硬编码十六进制。
- 全站不得残留旧蓝：`#2563eb`、`#1d4ed8`、`#1e293b`（作背景/主色）、`#eff6ff`、`rgba(37,99,235,*)`。
- 状态语义：可用/成功 = 品牌绿实色；预警 = 琥珀 `#d97706`；未启用 = 浅绿灰 `#86c5a8`。
- 所有位移/缩放动效必须包在 `@media (prefers-reduced-motion: reduce)` 降级里（关位移与缩放，仅保留颜色过渡）。
- 字体栈保持 `'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif`。
- 弹性缓动统一用 `cubic-bezier(.34,1.56,.64,1)`（图标/LOGO/打勾），卡片上浮用 `cubic-bezier(.34,1.4,.5,1)`。
- 不引入任何新依赖。
- 范围：仅门户外壳。`public/tools/heyuan-material/index.html` 一行都不改。

**验证方式说明：** 本项目无测试框架，且为纯视觉重构，不新增测试框架（YAGNI）。每个任务的验证 = `npm run build` 通过 + 开发服务器（`npm run dev`）肉眼核对 + grep 确认无旧蓝残留。

---

### Task 1: 注入品牌绿 design tokens 与全局背景

**Files:**
- Modify: `src/style.css`

**Interfaces:**
- Produces: `:root` 上的 CSS 变量 `--brand`、`--brand-deep`、`--brand-light`、`--brand-bg`、`--brand-tint`、`--brand-border`、`--brand-shadow`、`--ink`、`--ink-soft`、`--ok`、`--warn`、`--off`。后续所有任务都靠这些变量取色。

- [ ] **Step 1: 用 tokens 重写 `src/style.css`**

把整个文件替换为：

```css
:root {
  /* 品牌绿令牌 —— 全站唯一色彩来源 */
  --brand: #10B981;
  --brand-deep: #059669;
  --brand-light: #34d399;
  --brand-bg: linear-gradient(165deg, #ecfdf5, #f0fdfa 55%, #fff);
  --brand-tint: #ecfdf5;
  --brand-border: #d1fae5;
  --brand-shadow: rgba(16, 185, 129, 0.10);
  --brand-shadow-strong: rgba(16, 185, 129, 0.22);

  /* 文字 */
  --ink: #134e4a;
  --ink-soft: #6b8c80;

  /* 状态语义 */
  --ok: #10B981;
  --warn: #d97706;
  --off: #86c5a8;

  /* 缓动 */
  --ease-bounce: cubic-bezier(.34, 1.56, .64, 1);
  --ease-lift: cubic-bezier(.34, 1.4, .5, 1);
}

* {
  box-sizing: border-box;
}

html,
body {
  margin: 0;
  padding: 0;
}

body {
  font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI',
    Arial, sans-serif;
  background: var(--brand-bg);
  background-attachment: fixed;
  color: var(--ink);
  -webkit-font-smoothing: antialiased;
}

#app {
  min-height: 100vh;
}

button {
  font-family: inherit;
}
```

- [ ] **Step 2: 启动开发服务器核对背景**

Run: `npm run dev`
Expected: 启动成功，打开页面背景变成浅绿渐变（卡片此刻还是旧样式，正常）。

- [ ] **Step 3: 提交**

```bash
git add src/style.css
git commit -m "加品牌绿 design tokens 与全局浅绿背景"
```

---

### Task 2: 新建 BrandLogo 组件（内联 SVG RR 圆标）

**Files:**
- Create: `src/components/BrandLogo.vue`

**Interfaces:**
- Produces: 默认导出的 Vue 组件 `BrandLogo`，props：`size: Number = 40`（徽标直径 px）、`showText: Boolean = false`（是否在徽标右侧显示"华登 · 河源工具门户"）。徽标本身是圆形渐变底 + 白色 "RR"。Task 4、Task 5 都会 import 它。

- [ ] **Step 1: 创建 `src/components/BrandLogo.vue`**

```vue
<script setup>
defineProps({
  size: { type: Number, default: 40 },
  showText: { type: Boolean, default: false },
})
</script>

<template>
  <span class="brand-logo">
    <svg
      class="rr"
      :width="size"
      :height="size"
      viewBox="0 0 40 40"
      role="img"
      aria-label="RR 华登河源工具门户"
    >
      <defs>
        <linearGradient id="rrGrad" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stop-color="#34d399" />
          <stop offset="1" stop-color="#10B981" />
        </linearGradient>
      </defs>
      <circle cx="20" cy="20" r="20" fill="url(#rrGrad)" />
      <text
        x="50%"
        y="53%"
        text-anchor="middle"
        dominant-baseline="middle"
        font-family="'Segoe UI', Arial, sans-serif"
        font-size="17"
        font-weight="900"
        letter-spacing="-1"
        fill="#fff"
      >RR</text>
    </svg>
    <b v-if="showText" class="brand-text">华登 · 河源工具门户</b>
  </span>
</template>

<style scoped>
.brand-logo {
  display: inline-flex;
  align-items: center;
  gap: 11px;
}
.rr {
  border-radius: 50%;
  filter: drop-shadow(0 4px 12px rgba(16, 185, 129, 0.4));
  transition: transform 0.35s var(--ease-bounce), filter 0.35s;
  flex-shrink: 0;
}
.brand-text {
  font-weight: 800;
  font-size: 17px;
  color: var(--brand-deep);
}
</style>
```

- [ ] **Step 2: 临时挂到首页验证渲染**

在 `src/views/Home.vue` 的 `<script setup>` 顶部临时加 `import BrandLogo from '../components/BrandLogo.vue'`，并在 `<template>` 的 `.hero` 上方临时加 `<BrandLogo :size="48" show-text />`。

Run: `npm run dev`
Expected: 页面顶部出现绿色圆形 RR 徽标 + "华登 · 河源工具门户" 文字。

- [ ] **Step 3: 撤掉临时验证代码**

删掉 Step 2 加的那行 import 和那行 `<BrandLogo>`（Task 4 会正式接入）。

- [ ] **Step 4: 提交**

```bash
git add src/components/BrandLogo.vue
git commit -m "加内联 SVG 绿色 RR 圆形 LOGO 组件"
```

---

### Task 3: favicon 与 title 换绿

**Files:**
- Modify: `public/favicon.svg`
- Modify: `index.html:7`

**Interfaces:**
- Produces: 浏览器标签页图标为绿色 RR 圆标，标题为"华登 · 河源工具门户"。无下游依赖。

- [ ] **Step 1: 用绿色 RR 圆标替换 `public/favicon.svg`**

整文件替换为：

```svg
<svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40">
  <defs>
    <linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#34d399"/>
      <stop offset="1" stop-color="#10B981"/>
    </linearGradient>
  </defs>
  <circle cx="20" cy="20" r="20" fill="url(#g)"/>
  <text x="50%" y="53%" text-anchor="middle" dominant-baseline="middle"
    font-family="Arial, sans-serif" font-size="17" font-weight="900"
    letter-spacing="-1" fill="#fff">RR</text>
</svg>
```

- [ ] **Step 2: 改 `index.html` 标题**

把 `index.html:7` 的 `<title>rr-heyuan</title>` 改为：

```html
<title>华登 · 河源工具门户</title>
```

- [ ] **Step 3: 核对**

Run: `npm run dev`
Expected: 浏览器标签页图标变绿色 RR 圆标，标题变"华登 · 河源工具门户"。

- [ ] **Step 4: 提交**

```bash
git add public/favicon.svg index.html
git commit -m "favicon 与页面标题换成绿色 RR 品牌"
```

---

### Task 4: 重构首页 Home.vue（品牌绿 + 卡片动效 + 统计占位 + 移动端）

**Files:**
- Modify: `src/views/Home.vue`

**Interfaces:**
- Consumes: `BrandLogo`（Task 2）、`src/style.css` 的 CSS 变量（Task 1）、`tools.js` 的 `tools` 数组（已存在）。
- Produces: 完整绿色首页。新增本地常量 `stats`（占位统计数据数组，结构 `{ label: String, value: String }`），为后续接小程序数据预留。

- [ ] **Step 1: 整体替换 `src/views/Home.vue`**

```vue
<script setup>
import { tools } from '../tools.js'
import { useRouter } from 'vue-router'
import BrandLogo from '../components/BrandLogo.vue'

const router = useRouter()

// 占位统计数据（小程序数据联动预留：以后把这里替换为接口返回）
const stats = [
  { label: '本月填单', value: '128' },
  { label: '校验通过', value: '96%' },
  { label: '待处理', value: '3' },
  { label: '活跃工具', value: '12' },
]

function openTool(tool) {
  if (!tool.ready) {
    alert('「' + tool.name + '」还在集成中，敬请期待')
    return
  }
  router.push(tool.route)
}
</script>

<template>
  <div class="home">
    <header class="topbar">
      <BrandLogo :size="40" show-text />
      <nav class="nav">
        <span>工具</span>
        <span>关于</span>
        <span>EN</span>
      </nav>
    </header>

    <section class="hero">
      <h1>选择下方工具开始使用</h1>
      <p>轻松上手，专注把事做完</p>
    </section>

    <main class="grid">
      <button
        v-for="tool in tools"
        :key="tool.id"
        class="card"
        :class="{ disabled: !tool.ready }"
        @click="openTool(tool)"
      >
        <div class="card-icon">{{ tool.icon }}</div>
        <div class="card-body">
          <div class="card-title">{{ tool.name }}</div>
          <div class="card-desc">{{ tool.desc }}</div>
        </div>
        <span class="card-status" :class="{ on: tool.ready }">
          {{ tool.ready ? '可用' : '集成中' }}
        </span>
      </button>
    </main>

    <section class="stats">
      <div v-for="s in stats" :key="s.label" class="stat">
        <div class="stat-num">{{ s.value }}</div>
        <div class="stat-label">{{ s.label }}</div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.home {
  max-width: 1040px;
  margin: 0 auto;
  padding: 22px 20px 60px;
}

/* 顶栏：毛玻璃半透明白底 */
.topbar {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 20px;
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.72);
  backdrop-filter: blur(8px);
  border: 1px solid rgba(16, 185, 129, 0.18);
  margin-bottom: 26px;
}
.topbar:hover :deep(.rr) {
  transform: rotate(-8deg) scale(1.06);
  filter: drop-shadow(0 6px 18px rgba(16, 185, 129, 0.55));
}
.nav {
  margin-left: auto;
  display: flex;
  gap: 20px;
  font-size: 13px;
  color: var(--ink-soft);
}
.nav span {
  cursor: pointer;
  position: relative;
  padding-bottom: 3px;
  transition: color 0.2s;
}
.nav span::after {
  content: '';
  position: absolute;
  left: 0;
  bottom: 0;
  width: 0;
  height: 2px;
  background: var(--brand);
  border-radius: 2px;
  transition: width 0.25s;
}
.nav span:hover {
  color: var(--brand-deep);
}
.nav span:hover::after {
  width: 100%;
}

.hero {
  margin-bottom: 22px;
  padding: 0 4px;
}
.hero h1 {
  font-size: 22px;
  color: #065f46;
  margin: 0 0 6px;
}
.hero p {
  font-size: 13px;
  color: var(--ink-soft);
  margin: 0;
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
  gap: 18px;
  margin-bottom: 24px;
}
.card {
  position: relative;
  display: flex;
  align-items: flex-start;
  gap: 14px;
  padding: 20px;
  background: #fff;
  border: 1px solid var(--brand-border);
  border-radius: 18px;
  cursor: pointer;
  text-align: left;
  font: inherit;
  overflow: hidden;
  box-shadow: 0 6px 18px var(--brand-shadow);
  transition: transform 0.22s var(--ease-lift), box-shadow 0.22s,
    border-color 0.22s;
}
.card::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: 18px;
  pointer-events: none;
  box-shadow: inset 0 0 0 2px var(--brand);
  opacity: 0;
  transition: opacity 0.22s;
}
.card:hover {
  transform: translateY(-6px);
  box-shadow: 0 16px 34px var(--brand-shadow-strong);
}
.card:hover::before {
  opacity: 1;
}
.card:active {
  transform: translateY(-2px) scale(0.99);
}
.card-icon {
  font-size: 30px;
  line-height: 1;
  transition: transform 0.3s var(--ease-bounce);
}
.card:hover .card-icon {
  transform: scale(1.18) translateY(-2px);
}
.card-body {
  flex: 1;
}
.card-title {
  font-size: 15px;
  font-weight: 700;
  color: var(--ink);
  margin-bottom: 5px;
}
.card-desc {
  font-size: 12px;
  color: var(--ink-soft);
  line-height: 1.5;
}
.card-status {
  position: absolute;
  top: 14px;
  right: 14px;
  font-size: 10.5px;
  padding: 3px 9px;
  border-radius: 10px;
  font-weight: 600;
  background: var(--brand-tint);
  color: var(--off);
}
.card-status.on {
  background: var(--ok);
  color: #fff;
}

/* 集成中卡片：禁用态不触发动效 */
.card.disabled {
  opacity: 0.62;
  cursor: not-allowed;
}
.card.disabled:hover {
  transform: none;
  box-shadow: 0 6px 18px var(--brand-shadow);
}
.card.disabled:hover::before {
  opacity: 0;
}
.card.disabled:hover .card-icon {
  transform: none;
}

/* 统计占位卡（小程序数据预留） */
.stats {
  display: flex;
  gap: 14px;
  flex-wrap: wrap;
}
.stat {
  flex: 1;
  min-width: 150px;
  background: #fff;
  border: 1px solid var(--brand-border);
  border-radius: 18px;
  padding: 16px;
  text-align: center;
  box-shadow: 0 4px 14px var(--brand-shadow);
  transition: transform 0.2s, box-shadow 0.2s;
}
.stat:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 26px var(--brand-shadow-strong);
}
.stat-num {
  font-size: 26px;
  font-weight: 800;
  background: linear-gradient(135deg, var(--brand), var(--brand-deep));
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}
.stat-label {
  font-size: 11px;
  color: var(--ink-soft);
  margin-top: 3px;
}

/* 移动端自适应 */
@media (max-width: 480px) {
  .home {
    padding: 16px 14px 40px;
  }
  .topbar {
    padding: 12px 14px;
  }
  .nav {
    gap: 14px;
  }
  .grid {
    grid-template-columns: 1fr;
  }
}

/* 无障碍：降低动效偏好时关掉位移/缩放 */
@media (prefers-reduced-motion: reduce) {
  .card,
  .card-icon,
  .stat,
  .topbar:hover :deep(.rr) {
    transition: color 0.2s, background 0.2s, box-shadow 0.2s;
    transform: none !important;
  }
}
</style>
```

- [ ] **Step 2: 开发服务器全面核对**

Run: `npm run dev`
Expected: 首页绿色顶栏 + RR 徽标；卡片白底大圆角、hover 上浮 + 绿描边 + 图标弹跳；可用徽章绿、集成中灰且不动效；底部 4 个统计卡数字绿渐变。窗口拉窄到手机宽度变单列。

- [ ] **Step 3: 提交**

```bash
git add src/views/Home.vue
git commit -m "重构首页为品牌绿+卡片动效+统计占位+移动端自适应"
```

---

### Task 5: 重构工具壳 HeyuanMaterial.vue（顶栏换绿 + 返回按钮动效）

**Files:**
- Modify: `src/views/tools/HeyuanMaterial.vue`

**Interfaces:**
- Consumes: `BrandLogo`（Task 2）、CSS 变量（Task 1）。
- Produces: 工具页顶栏与首页风格一致。iframe 内容不变。

- [ ] **Step 1: 整体替换 `src/views/tools/HeyuanMaterial.vue`**

```vue
<script setup>
import { useRouter } from 'vue-router'
import BrandLogo from '../../components/BrandLogo.vue'

const router = useRouter()

// 工具的静态文件路径（放在 public/tools/ 下，打包后原样保留）
const toolUrl = import.meta.env.BASE_URL + 'tools/heyuan-material/index.html'
</script>

<template>
  <div class="tool-page">
    <header class="tool-bar">
      <button class="back-btn" @click="router.push('/')">← 返回门户</button>
      <BrandLogo :size="28" />
      <span class="tool-name">河源送印尼物料填单</span>
    </header>
    <iframe :src="toolUrl" class="tool-frame" title="河源送印尼物料填单"></iframe>
  </div>
</template>

<style scoped>
.tool-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
}
.tool-bar {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 10px 20px;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(8px);
  border-bottom: 1px solid var(--brand-border);
  color: var(--ink);
  flex-shrink: 0;
}
.back-btn {
  background: var(--brand);
  color: #fff;
  border: none;
  padding: 7px 15px;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
  transition: transform 0.15s, box-shadow 0.2s, background 0.2s;
}
.back-btn:hover {
  background: var(--brand-deep);
  transform: translateY(-2px);
  box-shadow: 0 8px 18px rgba(16, 185, 129, 0.42);
}
.back-btn:active {
  transform: translateY(0);
}
.tool-name {
  font-size: 15px;
  font-weight: 700;
  color: var(--brand-deep);
}
.tool-frame {
  flex: 1;
  width: 100%;
  border: none;
}
@media (prefers-reduced-motion: reduce) {
  .back-btn {
    transition: background 0.2s;
    transform: none !important;
  }
}
</style>
```

- [ ] **Step 2: 核对**

Run: `npm run dev`，点首页可用卡片进入工具页。
Expected: 顶栏白底毛玻璃 + 绿返回按钮（hover 上浮加深）+ RR 小徽标 + 绿色工具名；下方 iframe 填单工具内部外观不变。

- [ ] **Step 3: 提交**

```bash
git add src/views/tools/HeyuanMaterial.vue
git commit -m "工具壳顶栏换品牌绿+返回按钮动效"
```

---

### Task 6: 清理脚手架残留 + 全量验收

**Files:**
- Delete: `src/components/HelloWorld.vue`
- Delete: `src/assets/vue.svg`
- Delete: `src/assets/hero.png`

**Interfaces:**
- Consumes: 无。
- Produces: 更干净的打包产物。

- [ ] **Step 1: 确认无引用后删除**

Run: `grep -rn "HelloWorld\|hero.png\|vue.svg" src/ index.html`
Expected: 无输出（无任何引用）。

然后删除：

```bash
git rm src/components/HelloWorld.vue src/assets/vue.svg src/assets/hero.png
```

- [ ] **Step 2: grep 确认无旧蓝残留**

Run: `grep -rniE "#2563eb|#1d4ed8|#1e293b|#eff6ff|rgba\(37, ?99, ?235" src/`
Expected: 无输出。

- [ ] **Step 3: 构建验收**

Run: `npm run build`
Expected: 构建成功，无报错。

- [ ] **Step 4: 预览验收**

Run: `npm run preview`
Expected: 首页 + 工具页全绿色品牌，动效正常，favicon/title 为绿色 RR。

- [ ] **Step 5: 提交**

```bash
git add -A
git commit -m "删除未引用脚手架文件，完成绿色 RR 品牌重构验收"
```

---

## 验收标准（对应 spec 第 8 节）

- [ ] 首页、工具壳、favicon、title 全部绿色 RR 品牌，无残留蓝（Task 6 Step 2 grep 为空）
- [ ] 鼠标动效按 spec 第 5 节生效，`prefers-reduced-motion` 降级正常（Task 4/5 已含降级块）
- [ ] 移动端 ≤480px 单列自适应，无横向溢出（Task 4 媒体查询）
- [ ] `npm run build` 通过（Task 6 Step 3）
- [ ] 填单工具内部功能与外观不受影响（全程未碰 `public/tools/`）
