# Use an official Node.js runtime as a parent image
FROM node:18-alpine AS base

# Set working directory
WORKDIR /app

# Install dependencies for the project
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the project files
COPY . .

# Build the Next.js app for production
RUN npm run build

# Use a minimal Node.js runtime to serve the built app
FROM node:18-alpine AS runner

WORKDIR /app

# Copy the build from the previous stage
COPY --from=base /app/.next ./.next
COPY --from=base /app/public ./public
COPY --from=base /app/node_modules ./node_modules
COPY --from=base /app/package.json ./

# Set environment variable to production
ENV NODE_ENV=production

# Expose port 3000
EXPOSE 3000

# Run Next.js app
CMD ["npm", "start"]
