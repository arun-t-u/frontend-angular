# Stage 1: Build the Angular application
FROM node:18 AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the application using Nginx
FROM nginx:alpine

# Copy the built application to Nginx's serve directory
COPY --from=build /app/dist/frontend-angular /usr/share/nginx/html

# Copy custom Nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
