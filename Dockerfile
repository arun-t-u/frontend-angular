# Stage 1: Build the Angular application
FROM node:18 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy only the package files first (for better caching of npm ci)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application files
COPY . .

# Build the Angular app in production mode
RUN npm run build -- --configuration production

# Optional: Debug output folder contents
RUN ls -la /app/dist && ls -la /app/dist/frontend-angular

# Stage 2: Serve the app with Nginx
FROM nginx:alpine

# Remove the default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the build output from the builder stage to Nginx's public folder
COPY --from=builder /app/dist/frontend-angular /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
