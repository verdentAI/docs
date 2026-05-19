# Stage 1: Build the static site
FROM node:20-alpine AS builder

WORKDIR /app

# Install Mintlify CLI globally
RUN npm install -g mintlify

# Copy all source files into the container
COPY . .

# Build the Mintlify site, generating static files into a 'build' directory
RUN mintlify build

# Stage 2: Serve the static site with Nginx
FROM nginx:1.27-alpine

# Copy the built static files from the builder stage into Nginx's web root
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Healthcheck to ensure the Nginx server is up and serving content
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD wget -q -O /dev/null http://localhost/ || exit 1

# Nginx base image starts Nginx automatically, serving from /usr/share/nginx/html
