<script setup>
import { tools } from '../tools.js'
import { useRouter } from 'vue-router'

const router = useRouter()

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
    <header class="hero">
      <h1>华登 · 河源工具门户</h1>
      <p>选择下方工具开始使用</p>
    </header>

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
  </div>
</template>

<style scoped>
.home {
  max-width: 1100px;
  margin: 0 auto;
  padding: 40px 24px;
}
.hero {
  text-align: center;
  margin-bottom: 40px;
}
.hero h1 {
  font-size: 28px;
  color: #1e293b;
  margin: 0 0 8px;
}
.hero p {
  color: #64748b;
  margin: 0;
}
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}
.card {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  padding: 20px;
  background: #fff;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  cursor: pointer;
  text-align: left;
  font: inherit;
  transition: all 0.15s;
  position: relative;
}
.card:hover {
  border-color: #2563eb;
  box-shadow: 0 4px 16px rgba(37, 99, 235, 0.12);
  transform: translateY(-2px);
}
.card.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
.card.disabled:hover {
  border-color: #e2e8f0;
  box-shadow: none;
  transform: none;
}
.card-icon {
  font-size: 32px;
  line-height: 1;
}
.card-body {
  flex: 1;
}
.card-title {
  font-size: 16px;
  font-weight: 600;
  color: #1e293b;
  margin-bottom: 4px;
}
.card-desc {
  font-size: 13px;
  color: #64748b;
  line-height: 1.5;
}
.card-status {
  position: absolute;
  top: 12px;
  right: 12px;
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 10px;
  background: #f1f5f9;
  color: #94a3b8;
}
.card-status.on {
  background: #dcfce7;
  color: #16a34a;
}
</style>
