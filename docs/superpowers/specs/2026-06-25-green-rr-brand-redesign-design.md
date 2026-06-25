# 河源工具门户 · 绿色 RR 品牌视觉重构 — 设计文档

- 日期：2026-06-25
- 范围：仅门户外壳（Vue 前端），填单工具 `public/tools/heyuan-material/index.html` 内部不动
- 选定风格：**B 清新轻量** + 轻量交互动效

## 1. 目标

把现有蓝色（#2563eb）门户外壳重构为企业品牌绿视觉体系，核心符号是绿色 RR 双字母 LOGO。页面高亮、操作按钮、状态预警统一用品牌绿；布局干净轻量、移动端自适应；优化资源加载。小程序数据联动展示本轮以占位统计卡呈现，不接真实数据。

## 2. 品牌视觉令牌（Design Tokens）

定义为 CSS 变量，放 `src/style.css` `:root`，全站复用。

| 变量 | 值 | 用途 |
|---|---|---|
| `--brand` | `#10B981` | 品牌主绿（高亮、按钮、状态、描边） |
| `--brand-deep` | `#059669` | 主绿加深（hover、渐变终点、数字描边） |
| `--brand-light` | `#34d399` | 主绿提亮（渐变起点、LOGO） |
| `--brand-bg` | `linear-gradient(165deg,#ecfdf5,#f0fdfa 55%,#fff)` | 页面背景 |
| `--brand-tint` | `#ecfdf5` | 浅绿底（hover 背景、次按钮底） |
| `--brand-border` | `#d1fae5` | 卡片描边 |
| `--brand-shadow` | `rgba(16,185,129,.10)` | 卡片柔和绿投影 |
| `--ink` | `#134e4a` | 主文字（深绿墨） |
| `--ink-soft` | `#6b8c80` | 次要文字 |
| `--ok` | `#10B981` | 状态：可用/通过 |
| `--warn` | `#d97706` | 状态：预警 |
| `--off` | `#86c5a8` | 状态：未启用 |

状态预警语义：**可用/成功 = 品牌绿实色**；预警 = 琥珀；未启用 = 浅绿灰。

## 3. RR LOGO

新建 `src/components/BrandLogo.vue`，纯内联 SVG（不依赖图片，省一次请求、可随字号缩放）：

- 圆形徽标，背景 `linear-gradient(135deg, var(--brand-light), var(--brand))`
- 白色 "RR" 字母，字重 900，轻微负字距
- 投影 `0 4px 12px rgba(16,185,129,.4)`
- props：`size`（默认 40），`showText`（是否带"华登 · 河源工具门户"文字）
- 同步替换 `public/favicon.svg`（当前是紫色 Vite 默认图）为绿色 RR 圆标，`index.html` 的 `<title>` 改为"华登 · 河源工具门户"

## 4. 组件改造清单

### 4.1 `src/views/Home.vue`（首页门户）
- 顶栏：毛玻璃半透明白底 + BrandLogo + 导航（工具/关于/EN），导航 hover 绿色下划线滑入
- Hero：标题深绿墨色，副标题次要色
- 工具卡片网格：白底大圆角（18px）+ 浅绿描边 + 柔和绿投影
  - hover：上浮 6px + 品牌绿内描边渐入（伪元素 `::before` opacity 过渡）+ 图标弹跳放大（弹性缓动 `cubic-bezier(.34,1.56,.64,1)`）
  - active：轻微下沉缩放
  - 可用状态徽章 = 品牌绿实色；集成中 = 浅绿灰
  - disabled 卡片不触发动效
- 统计卡区（小程序数据占位）：4 个统计卡（本月填单/校验通过/待处理/活跃工具），白底圆角，数字用品牌绿渐变描边，hover 上浮。**标注为占位数据**，预留后续接小程序接口的数据结构
- 移动端：网格 `auto-fill minmax` 自动单列；统计卡 flex-wrap；顶栏导航收窄

### 4.2 `src/views/tools/HeyuanMaterial.vue`（工具壳）
- 顶部工具栏从深蓝 `#1e293b` 改为白底毛玻璃配品牌绿（与首页顶栏一致）
- 返回按钮从蓝改品牌绿，加 hover 动效
- iframe 区域不变（工具内部不动）

### 4.3 `src/style.css`（全局）
- 注入 design tokens
- body 背景改品牌绿渐变
- 全局缓动/过渡基类（可选）
- 字体保持 Microsoft YaHei 栈

### 4.4 删除/清理
- 删除未引用的脚手架文件（已确认全站无 import）：`src/components/HelloWorld.vue`、`src/assets/vue.svg`、`src/assets/hero.png`（后两者仅被 HelloWorld 引用）

## 5. 动效规范（轻量、零依赖）

纯 CSS `transition`，不引入动画库。

| 元素 | 动效 | 时长/缓动 |
|---|---|---|
| 工具卡片 | 上浮 6px + 绿描边渐入 + 图标弹跳 | .22s `cubic-bezier(.34,1.4,.5,1)` |
| 卡片图标 | 放大 1.18 + 上移 | .3s 弹性 |
| 卡片选中 | 左上角打勾缩放入场 | .3s 弹性 |
| 按钮 | 上浮 2px + 加深 + 投影扩散 | .15s |
| 导航项 | 绿色下划线左→右滑入 | .25s |
| LOGO | 鼠标进顶栏轻转 8° + 微放大 | .35s 弹性 |
| 统计卡 | 上浮 4px + 投影 | .2s |

`prefers-reduced-motion: reduce` 时关闭位移/缩放，仅保留颜色过渡（无障碍）。

## 6. 资源加载优化

- BrandLogo 与 favicon 用内联 SVG，消除图片请求
- 删除未引用的脚手架资源（见 4.4，已确认无 import），减小打包体积
- `src/assets/hero.png` 仅被待删的 HelloWorld 引用，随之移除
- 字体用系统字体栈（已是），无 webfont 请求
- 动效全部 CSS，无 JS 动画库

## 7. 不在本轮范围

- 填单工具 `index.html` 内部（表格渲染、按钮、步骤条颜色）保持现状
- 小程序真实数据接口（仅做占位统计卡 + 预留数据结构）

## 8. 验收标准

- 首页、工具壳、favicon、title 全部为绿色 RR 品牌，无残留蓝色（#2563eb / #1e293b 等）
- 鼠标交互动效按第 5 节规范生效，`prefers-reduced-motion` 下降级正常
- 移动端（≤480px）单列自适应，无横向溢出
- `npm run build` 通过，`npm run preview` 视觉正常
- 填单工具内部功能与外观不受影响
