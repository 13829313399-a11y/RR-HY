# ───────── 第一阶段：用 Node 打包 Vue 项目 ─────────
FROM node:22-alpine AS build
WORKDIR /app

# 先只拷依赖清单，利用 Docker 缓存：依赖没变就不重装
COPY package*.json ./
RUN npm install

# 拷源码并打包，产物在 /app/dist
COPY . .
RUN npm run build

# ───────── 第二阶段：用 nginx 托管打包产物 ─────────
FROM nginx:1.25-alpine

# 用我们自己的 nginx 配置（含 Vue 路由 fallback）
COPY nginx-docker.conf /etc/nginx/conf.d/default.conf

# 把第一阶段打包好的静态文件拷进 nginx 默认目录
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
