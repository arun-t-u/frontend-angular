### STAGE 1: Build ###
# Use Node image as the base image for the build process
FROM node:18.20.8-alpine as builder

# Set the working directory for the build process
WORKDIR /ng-app

# Copy the package.json and package-lock.json to install dependencies first
COPY package.json package-lock.json ./

# Install dependencies and cache node_modules separately to optimize Docker caching
RUN npm set progress=false && npm config set depth 0 && npm cache clean --force
RUN npm install && mkdir /ng-app && cp -R ./node_modules ./ng-app

# Copy the source code into the container
COPY . .

# Build the Angular app in production mode and store the artifacts in the dist folder
# Use the environment variable APPLICATION_ENV to set the build mode
RUN ENV=production npm run build --prod

### STAGE 2: Setup ###
# Set environment variables (optional)
#ENV CDN_ALTERNATIVE_SERVICE=$CDN_ALTERNATIVE_SERVICE

# Use Nginx to serve the Angular app
FROM nginx:1.13.3-alpine

# Copy the custom Nginx config file into the container
COPY nginx/default.conf /etc/nginx/conf.d/

# Remove the default Nginx website files
RUN rm -rf /usr/share/nginx/html/*

# Copy the built Angular app from the builder stage to Nginx’s public directory
COPY --from=builder /ng-app/dist/your-angular-app-name /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
