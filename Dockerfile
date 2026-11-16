FROM node:22-bookworm-slim
# Ferramentas para compilar o better-sqlite3 caso não haja binário pronto
RUN apt-get update && apt-get install -y --no-install-recommends python3 make g++ \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build
# O banco fica em /data: monte um volume/disco persistente nesse caminho
ENV NODE_ENV=production \
    DATABASE_PATH=/data/achei.sqlite \
    PORT=3000
RUN mkdir -p /data
EXPOSE 3000
CMD ["npm", "run", "start:prod"]
