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
# Image registry details
IMAGE_REG ?= docker.io
IMAGE_REPO ?= zakiab02/glcpp
IMAGE_TAG ?= multiarch

# Compiler settings
CXX = g++
CXXFLAGS = -I/usr/include/GL -L/usr/lib -lGL -lglut -lGLU -lGLEW -lglfw -lX11 -lXi -lXrandr -lXxf86vm -lXinerama -lXcursor -lrt -lm -pthread

# Source files and output
SRCS = main.cpp
TARGET = main

# Platforms for multi-arch build
PLATFORMS = linux/amd64,linux/arm64

# Docker configuration
DOCKER = sudo docker
BUILDX = sudo docker buildx
BUILDX_BUILDER = multiarch-builder

# Phony targets
.PHONY: all clean docker-setup buildx-setup buildx-push buildx-image test

# Default target
all: $(TARGET)

# Build target
$(TARGET): $(SRCS)
	$(CXX) -o $@ $^ $(CXXFLAGS)

# Clean target
clean:
	rm -f $(TARGET)# Setup Docker environment
docker-setup:
	@echo "🔧 Setting up Docker environment..."
	@# Ensure Docker service is running
	@sudo systemctl start docker || true
	@# Set proper permissions for Docker socket
	@sudo chmod 666 /var/run/docker.sock || true
	@# Add jenkins user to docker group
	@sudo usermod -aG docker jenkins || true
	@# Verify Docker is working
	@$(DOCKER) info >/dev/null 2>&1 || { \
		echo "❌ Docker setup failed. Please check system requirements."; \
		exit 1; \
	}
	@echo "✅ Docker environment setup complete"

# Setup Docker Buildx
buildx-setup: docker-setup
	@echo "🔧 Setting up Docker Buildx..."
	@# Ensure Docker Buildx is installed and available
	@$(DOCKER) buildx version || { \
		echo "❌ Docker Buildx not installed."; \
		exit 1; \
	}
	@# Install QEMU for multi-architecture support
	@$(DOCKER) run --rm --privileged multiarch/qemu-user-static --reset -p yes || true
	@# Remove existing builder if exists
	@$(BUILDX) rm $(BUILDX_BUILDER) 2>/dev/null || true
	@# Create and configure new builder
	@$(BUILDX) create --name $(BUILDX_BUILDER) --driver docker-container --bootstrap
	@$(BUILDX) use $(BUILDX_BUILDER)
	@$(BUILDX) inspect --bootstrap
	@echo "✅ Docker Buildx setup complete"

# Build and push multi-arch images
buildx-push: buildx-setup
	@echo "🚀 Building and pushing multi-arch images for platforms: $(PLATFORMS)"
	@$(BUILDX) build \
		--platform $(PLATFORMS) \
		-t $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG) \
		--push \
		. || { \
			echo "❌ Build and push failed"; \
			exit 1; \
		}
	@echo "✅ Successfully built and pushed multi-arch images"

# Build multi-arch images locally
buildx-image: buildx-setup
	@echo "🔨 Building multi-arch images locally for platforms: $(PLATFORMS)"
	@$(BUILDX) build \
		--platform $(PLATFORMS) \
		-t $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG) \
		--load \
		. || { \
			echo "❌ Local build failed"; \
			exit 1; \
		}
	@echo "✅ Successfully built multi-arch images locally"

# Test target (customize as needed)
test: $(TARGET)
	@echo "🧪 Running tests..."
	@echo "✅ Tests completed"
