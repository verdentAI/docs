FROM node:20-alpine AS builder

WORKDIR /app

RUN npm install -g mintlify

COPY . .

RUN mintlify export --output /app/export.zip && \
    apk add --no-cache unzip && \
    unzip /app/export.zip -d /app/build

FROM nginx:1.27-alpine

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD wget -q -O /dev/null http://localhost/ || exit 1
