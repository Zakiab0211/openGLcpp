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

# # Setup Docker Buildx for multi-platform builds
# # buildx-setup:
# # 	@echo "🔧 Setting up Docker Buildx builder..."
# # 	docker buildx rm multiarch-builder || true
# # 	docker buildx create --name multiarch-builder --driver docker-container --bootstrap
# # 	docker buildx use multiarch-builder
# # 	docker buildx inspect --bootstrap

# buildx-setup:
# 	@echo "🔧 Setting up Docker Buildx builder..."
# 	docker buildx rm multiarch-builder || true
# 	docker buildx create --name multiarch-builder --driver docker-container --bootstrap
# 	docker buildx use multiarch-builder
# 	docker buildx inspect --bootstrap

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
IMAGE_REG ?= docker.io
IMAGE_REPO ?= zakiab02/glcpp
IMAGE_TAG ?= multiarch

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

# Source and build configuration
SRCS = main.cpp
TARGET = main
PLATFORMS = linux/amd64,linux/arm64

# Docker configuration
DOCKERFILE ?= Dockerfile
DOCKER_CONTEXT ?= .
BUILDX_BUILDER = multiarch-builder

# Declare phony targets
.PHONY: all clean buildx-setup buildx-push buildx-image test

# Default target
all: $(TARGET)

# Compile the OpenGL application
$(TARGET): $(SRCS)
	@echo "🔨 Building $(TARGET)..."
	$(CXX) -o $@ $^ $(CXXFLAGS)
	@echo "✅ Build complete!"

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -f $(TARGET)
	@echo "✅ Clean complete!"

# Setup Docker Buildx
buildx-setup:
	@echo "🔧 Setting up Docker Buildx builder..."
	@docker buildx version >/dev/null 2>&1 || \
		{ echo "❌ Docker Buildx not installed. Please install it first."; exit 1; }
	docker buildx rm $(BUILDX_BUILDER) 2>/dev/null || true
	docker buildx create --name $(BUILDX_BUILDER) --driver docker-container --bootstrap
	docker buildx use $(BUILDX_BUILDER)
	docker buildx inspect --bootstrap
	@echo "✅ Buildx setup complete!"

# Build and push multi-arch images
buildx-push: buildx-setup
	@echo "🚀 Building and pushing multi-arch images for platforms: $(PLATFORMS)"
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG) \
		--push \
		-f $(DOCKERFILE) \
		$(DOCKER_CONTEXT) || \
		{ echo '❌ Buildx build and push failed'; exit 1; }
	@echo "✅ Successfully built and pushed images for all platforms"

# Build multi-arch images locally
buildx-image: buildx-setup
	@echo "🔨 Building multi-arch images locally for platforms: $(PLATFORMS)"
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG) \
		--load \
		-f $(DOCKERFILE) \
		$(DOCKER_CONTEXT) || \
		{ echo '❌ Buildx build failed'; exit 1; }
	@echo "✅ Successfully built images for all platforms"

# Add a test target (customize as needed)
test: $(TARGET)
	@echo "🧪 Running tests..."
	./$(TARGET) --test || { echo "❌ Tests failed"; exit 1; }
	@echo "✅ All tests passed!"

# Help target
help:
	@echo "Available targets:"
	@echo "  all          - Build the OpenGL application (default)"
	@echo "  clean        - Remove build artifacts"
	@echo "  buildx-setup - Set up Docker Buildx builder"
	@echo "  buildx-push  - Build and push multi-arch Docker images"
	@echo "  buildx-image - Build multi-arch Docker images locally"
	@echo "  test         - Run tests"
	@echo "  help         - Show this help message"


