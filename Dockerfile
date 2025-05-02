### STAGE 1: Build Angular ###
FROM node:16.10.0-alpine as builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Replace `your-app-name` with the folder name generated in dist/
RUN npm run build --prod

### STAGE 2: Serve using Nginx ###
FROM nginx:alpine

# Copy built Angular app to Nginx HTML folder
COPY --from=builder /app/dist/frontend-angular /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
