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
