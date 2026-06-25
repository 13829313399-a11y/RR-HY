// 工具清单：门户首页根据这个数组渲染卡片。
// 加新工具 = 在这里加一个对象 + 在 router/index.js 加一条路由。
export const tools = [
  {
    id: 'heyuan-material',
    name: '河源送印尼物料填单',
    desc: '导入 Excel，按模板批量生成送印尼物料填单',
    icon: '📦',
    route: '/heyuan-material',
    group: '河源',
    ready: true, // 已集成
  },
  {
    id: 'placeholder-2',
    name: '工具二（占位）',
    desc: '这里以后放第二个工具的简介',
    icon: '🛠️',
    route: '/',
    group: '河源',
    ready: false,
  },
  {
    id: 'placeholder-3',
    name: '工具三（占位）',
    desc: '这里以后放第三个工具的简介',
    icon: '📊',
    route: '/',
    group: '河源',
    ready: false,
  },
]
