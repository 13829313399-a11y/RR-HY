import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'

// 工具页面在这里登记。以后加新工具，复制一行，改 path / name / component 即可。
const routes = [
  {
    path: '/',
    name: 'home',
    component: Home,
  },
  {
    path: '/heyuan-material',
    name: 'heyuan-material',
    component: () => import('../views/tools/HeyuanMaterial.vue'),
  },
  // 以后加工具：复制上面这块，改 path / name / 文件路径
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
