From node:18-alpine3.15

Copy . /app

Workdir /app

Run npm ci --omit=dev

CMD ["node", "server.js"]
