FROM node:20.11.1 as builder
WORKDIR /
COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:20.11.1 as runner
WORKDIR /
ENV NODE_ENV production

COPY --from=builder /node_modules ./node_modules
COPY --from=builder /public ./public
COPY --from=builder /.next ./.next
COPY --from=builder /package.json ./package.json

EXPOSE 3000
CMD ["npm", "start"]
