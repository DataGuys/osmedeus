// filepath: osmedeus-scanner/Dockerfile
# Stage 1: Build the TypeScript application
FROM node:20-slim AS builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production
COPY . .
RUN npm run build

# Stage 2: Create the production image
FROM node:20-slim
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production
COPY --from=builder /usr/src/app/dist ./dist
EXPOSE 3000
CMD [ "node", "dist/index.js" ]