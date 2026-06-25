<script setup>
import { useId } from 'vue'

defineProps({
  size: { type: Number, default: 40 },
  showText: { type: Boolean, default: false },
})

const gradId = useId()
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
        <linearGradient :id="gradId" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stop-color="#34d399" />
          <stop offset="1" stop-color="#10B981" />
        </linearGradient>
      </defs>
      <circle cx="20" cy="20" r="20" :fill="`url(#${gradId})`" />
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
