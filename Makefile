# ###########4 paling iso###########
# # Image registry details//untuk menambahakan images detail
# IMAGE_REG ?= docker.io
# IMAGE_REPO ?= zakiab02/glcpp #sesuaikan dengan repo gi docker hub 
# IMAGE_TAG ?= multiarch

# CXX = g++

# # Compiler flags (Linux-specific)
# CXXFLAGS = -I/usr/include/GL -L/usr/lib -lGL -lglut -lGLU -lGLEW -lglfw -lX11 -lXi -lXrandr -lXxf86vm -lXinerama -lXcursor -lrt -lm -pthread

# # Source files
# SRCS = main.cpp

# # Output binary
# TARGET = main

# # Platforms for multi-arch build //menambahkan untuk multi arch platform
# PLATFORMS = linux/amd64,linux/arm64

# # Phony targets to avoid filename conflicts
# .PHONY: all clean buildx-setup buildx-push buildx-image test

# # Default target
# all: $(TARGET)

# # Rule to build the target
# $(TARGET): $(SRCS)
# 	$(CXX) -o $@ $^ $(CXXFLAGS)

# # Clean target to remove compiled files
# clean:
# 	rm -f $(TARGET)

# # Check Docker permissions
# docker-check:
# 	@echo "🔍 Checking Docker permissions..."
# 	@if ! docker info >/dev/null 2>&1; then \
# 		echo "❌ Docker is not running or you don't have sufficient permissions."; \
# 		echo "👉 Suggested fixes:"; \
# 		echo "   1. Add your user to the Docker group:"; \
# 		echo "      sudo usermod -aG docker $$USER"; \
# 		echo "   2. Adjust permissions for the Docker socket:"; \
# 		echo "      sudo chmod 666 /var/run/docker.sock"; \
# 		echo "   3. Start Docker service:"; \
# 		echo "      sudo systemctl start docker"; \
# 		exit 1; \
# 	fi
# 	@echo "✅ Docker permissions are valid"

# # Setup Docker Buildx for multi-platform builds
# # buildx-setup: docker-check
# # 	@echo "🔧 Setting up Docker Buildx builder..."
# # 	@if ! docker buildx version >/dev/null 2>&1; then \
# # 		echo "❌ Docker Buildx not available. Ensure Docker version >= 19.03"; \
# # 		exit 1; \
# # 	fi
# # 	docker run --rm --privileged tonistiigi/binfmt --install all || true
# # 	docker buildx rm multiarch-builder || true
# # 	docker buildx create --name multiarch-builder --driver docker-container --bootstrap
# # 	docker buildx use multiarch-builder
# # 	docker buildx inspect --bootstrap
# # 	docker buildx ls
# # 	@echo "✅ Docker Buildx setup completed"

# buildx-setup: docker-check
# 	@echo "🔧 Setting up Docker Buildx builder..."
# 	@if ! docker buildx version >/dev/null 2>&1; then \
# 		echo "❌ Docker Buildx not available. Ensure Docker version >= 19.03"; \
# 		exit 1; \
# 	fi
# 	@echo "⚙️ Adjusting permissions for Docker..."
# 	sudo chmod 666 /var/run/docker.sock || true
# 	docker run --rm --privileged tonistiigi/binfmt --install all || true
# 	docker buildx rm multiarch-builder || true
# 	docker buildx create --name multiarch-builder --driver docker-container --bootstrap
# 	docker buildx use multiarch-builder
# 	docker buildx inspect --bootstrap
# 	docker buildx ls
# 	@echo "✅ Docker Buildx setup completed"

# # Multi-platform build and push using Buildx
# buildx-push: buildx-setup
# 	@echo "🚀 Building and pushing multi-arch images for platforms: $(PLATFORMS)"
# 	docker buildx build \
# 		--platform $(PLATFORMS) \
# 		-t $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG) \
# 		--push \
# 		. || { echo '❌ Buildx build and push failed'; exit 1; }
# 	@echo "✅ Successfully built and pushed images for AMD64 and ARM64"

# # Multi-arch build without pushing (for local testing)
# buildx-image: buildx-setup
# 	@echo "🔨 Building multi-arch images locally for platforms: $(PLATFORMS)"
# 	docker buildx build \
# 		--platform $(PLATFORMS) \
# 		-t $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG) \
# 		--load \
# 		. || { echo '❌ Buildx build failed'; exit 1; }
# 	@echo "✅ Successfully built images for AMD64 and ARM64"

##########percobaan ke 2##########
# Image registry configuration
# Build configuration and variables
APP_NAME = glcpp
TARGET = main
VERSION ?= 1.0.0

# Docker registry configuration
DOCKER_REGISTRY ?= docker.io
DOCKER_REPO ?= zakiab02/$(APP_NAME)
IMAGE_TAG ?= multiarch
FULL_IMAGE_NAME = $(DOCKER_REGISTRY)/$(DOCKER_REPO):$(IMAGE_TAG)

# Build platforms
PLATFORMS = linux/amd64,linux/arm64

# Compiler settings
CXX = g++
CXXFLAGS = -I/usr/include/GL \
           -L/usr/lib \
           -lGL \
           -lglut \
           -lGLU \
           -lGLEW \
           -lglfw \
           -lX11 \
           -lXi \
           -lXrandr \
           -lXxf86vm \
           -lXinerama \
           -lXcursor \
           -lrt \
           -lm \
           -pthread

# Source files
SRCS = main.cpp
OBJS = $(SRCS:.cpp=.o)

# Docker and buildx configuration
DOCKER = docker
BUILDX = docker buildx
BUILDX_BUILDER = multiarch-builder
DOCKERFILE = Dockerfile
DOCKER_CONTEXT = .

# Build artifacts directory
BUILD_DIR = build
DIST_DIR = dist

# Declare phony targets
.PHONY: all clean setup test docker-login buildx-setup buildx-build buildx-push help install-deps

# Default target
all: clean setup test buildx-build

# Create necessary directories
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(DIST_DIR):
	@mkdir -p $(DIST_DIR)

# Setup build environment
setup: $(BUILD_DIR) $(DIST_DIR) install-deps
	@echo "🔧 Setting up build environment..."

# Install dependencies
install-deps:
	@echo "📦 Installing dependencies..."
	@command -v $(CXX) >/dev/null 2>&1 || { \
		echo "Installing build essentials..."; \
		sudo apt-get update && \
		sudo apt-get install -y build-essential; \
	}
	@command -v glxinfo >/dev/null 2>&1 || { \
		echo "Installing OpenGL dependencies..."; \
		sudo apt-get install -y \
			libgl1-mesa-dev \
			freeglut3-dev \
			libglew-dev \
			libglfw3-dev \
			libx11-dev \
			libxi-dev \
			libxrandr-dev \
			libxxf86vm-dev \
			libxinerama-dev \
			libxcursor-dev; \
	}

# Build the OpenGL application
$(BUILD_DIR)/$(TARGET): $(SRCS) | $(BUILD_DIR)
	@echo "🔨 Building $(TARGET)..."
	$(CXX) $(SRCS) $(CXXFLAGS) -o $@
	@echo "✅ Build complete!"

# Run tests
test: $(BUILD_DIR)/$(TARGET)
	@echo "🧪 Running tests..."
	@# Add your test commands here
	@echo "✅ Tests passed!"

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR) $(DIST_DIR)
	@echo "✅ Clean complete!"

# Docker login (requires DOCKER_USERNAME and DOCKER_PASSWORD environment variables)
docker-login:
	@echo "🔑 Logging in to Docker registry..."
	@echo "$(DOCKER_PASSWORD)" | $(DOCKER) login $(DOCKER_REGISTRY) -u "$(DOCKER_USERNAME)" --password-stdin

# Setup Docker Buildx
buildx-setup:
	@echo "🔧 Setting up Docker Buildx..."
	@$(BUILDX) version >/dev/null 2>&1 || { \
		echo "Installing Docker Buildx..."; \
		mkdir -p ~/.docker/cli-plugins/; \
		BUILDX_VERSION=$$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | grep '"tag_name":' | cut -d'"' -f4); \
		curl -L "https://github.com/docker/buildx/releases/download/$${BUILDX_VERSION}/buildx-$${BUILDX_VERSION}.linux-amd64" -o ~/.docker/cli-plugins/docker-buildx; \
		chmod a+x ~/.docker/cli-plugins/docker-buildx; \
	}
	@$(BUILDX) rm $(BUILDX_BUILDER) 2>/dev/null || true
	@$(BUILDX) create --name $(BUILDX_BUILDER) --driver docker-container --bootstrap
	@$(BUILDX) use $(BUILDX_BUILDER)
	@$(BUILDX) inspect --bootstrap

# Build multi-arch Docker images
buildx-build: buildx-setup $(BUILD_DIR)/$(TARGET)
	@echo "🚀 Building multi-arch images for platforms: $(PLATFORMS)"
	@$(BUILDX) build \
		--platform $(PLATFORMS) \
		-t $(FULL_IMAGE_NAME) \
		--load \
		-f $(DOCKERFILE) \
		$(DOCKER_CONTEXT)
	@echo "✅ Build complete!"

# Build and push multi-arch images
buildx-push: buildx-setup docker-login
	@echo "📤 Building and pushing multi-arch images..."
	@$(BUILDX) build \
		--platform $(PLATFORMS) \
		-t $(FULL_IMAGE_NAME) \
		--push \
		-f $(DOCKERFILE) \
		$(DOCKER_CONTEXT)
	@echo "✅ Push complete!"

# Generate distribution package
dist: $(DIST_DIR) $(BUILD_DIR)/$(TARGET)
	@echo "📦 Creating distribution package..."
	@cp $(BUILD_DIR)/$(TARGET) $(DIST_DIR)/
	@cd $(DIST_DIR) && tar czf $(APP_NAME)-$(VERSION).tar.gz $(TARGET)
	@echo "✅ Distribution package created!"

# Help target
help:
	@echo "Available targets:"
	@echo "  all          - Clean, setup, test, and build Docker images"
	@echo "  setup        - Set up build environment and install dependencies"
	@echo "  clean        - Remove build artifacts"
	@echo "  test         - Run tests"
	@echo "  buildx-setup - Set up Docker Buildx"
	@echo "  buildx-build - Build multi-arch Docker images"
	@echo "  buildx-push  - Build and push multi-arch Docker images"
	@echo "  dist         - Create distribution package"
	@echo "  help         - Show this help message"
	@echo ""
	@echo "Environment variables:"
	@echo "  DOCKER_REGISTRY  - Docker registry (default: docker.io)"
	@echo "  DOCKER_REPO     - Docker repository (default: zakiab02/$(APP_NAME))"
	@echo "  IMAGE_TAG       - Image tag (default: multiarch)"
	@echo "  VERSION        - Application version (default: 1.0.0)"

