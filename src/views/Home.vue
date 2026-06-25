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
.card.disabled:active {
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
  .nav span::after {
    transition: none;
  }
}
</style>
