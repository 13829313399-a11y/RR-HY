<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

// 工具的静态文件路径（放在 public/tools/ 下，打包后原样保留）
const toolUrl = import.meta.env.BASE_URL + 'tools/heyuan-material/index.html'
</script>

<template>
  <div class="tool-page">
    <header class="tool-bar">
      <button class="back-btn" @click="router.push('/')">← 返回门户</button>
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
  gap: 16px;
  padding: 10px 20px;
  background: #1e293b;
  color: #fff;
  flex-shrink: 0;
}
.back-btn {
  background: #2563eb;
  color: #fff;
  border: none;
  padding: 6px 14px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
}
.back-btn:hover {
  background: #1d4ed8;
}
.tool-name {
  font-size: 15px;
  font-weight: 600;
}
.tool-frame {
  flex: 1;
  width: 100%;
  border: none;
}
</style>
