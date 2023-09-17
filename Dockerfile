# Name the node stage "builder"
FROM node:16-alpine AS builder

# Set working directory
WORKDIR /app

# Copy our node module specification
COPY package.json package.json

# install node modules and build assets
RUN npm install

# Copy all files from current directory to working dir in image
# Except the one defined in '.dockerignore'
COPY . ./

# Create production build of React App
RUN npm run build

# Choose NGINX as our base Docker image
FROM nginx:alpine

# Copy our nginx configuration
COPY reactapp.conf /etc/nginx/conf.d/reactapp.conf

# Set working directory to nginx asset directory
WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf *

# Copy static assets from builder stage
COPY --from=builder /app/dist ./

# Define environment variables for Cloud Run
ENV PORT 80
ENV HOST 0.0.0.0
EXPOSE 8080

# Substitute $PORT variable in config file with the one passed via "docker run"
CMD ["systemctl","restart","nginx"]