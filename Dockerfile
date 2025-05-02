# Step 1: Build the Angular app
FROM node:18 AS builder

# Set working directory inside container
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the app and build it
COPY . .
RUN npm run build --prod

# Step 2: Serve the app with Nginx
FROM nginx:alpine

# Remove the default Nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy built Angular app to Nginx's public folder
COPY --from=builder /app/dist/frontend-angular /usr/share/nginx/html

# Copy custom Nginx config (optional but recommended for SPAs)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
