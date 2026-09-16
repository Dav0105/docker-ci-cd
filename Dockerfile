# source : https://www.docker.com/blog/how-to-dockerize-react-app/, https://docs.docker.com/guides/nextjs/

# This Dockerfile uses multi-stage builds in order to reduce the final image size. 
# We separate the build and runtime processes, so that the final image (runtime) only contains
# the necessary files to run the application, and not the build tools (node_modules folder here) or source code :D

# Node.js version
ARG NODE_VERSION=22-alpine3.24

# ===========================
# Step 1: Build the React app
# ===========================
FROM node:${NODE_VERSION} AS builder

WORKDIR /app

# Install dependencies using npm
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the app and build
COPY . .
RUN npm run build

# ===========================
# Step 2: Create the server
# ===========================
FROM node:${NODE_VERSION} AS runner

# Set the environment to production for smaller + optimized installs
ENV NODE_ENV=production

WORKDIR /app

# Copy the built app from the builder stage (created in Step 1)
# The --link flag creates a hard link to the files instead of copying them, which helps with optimisation
COPY --link --from=builder /app/out ./out

# Install only the `serve` package (no global install, pinned version)
# The `--mount=type=cache` option caches the npm install to speed up subsequent builds
RUN --mount=type=cache,target=/root/.npm npm install serve@^14.2.6 --omit=dev

# Run the container as a non-root user for security best practices
USER node

# Expose port 3000 (the same port configured in "serve -l 3000")
EXPOSE 3000
 
# Run `serve` directly to serve the built app
ENTRYPOINT ["npx", "serve", "-s", "out", "-l", "3000"]