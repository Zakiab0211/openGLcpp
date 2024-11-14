###########4 paling iso###########
# Image registry details//untuk menambahakan images detail
IMAGE_REG ?= docker.io
IMAGE_REPO ?= zakiab02/glcpp #sesuaikan dengan repo gi docker hub 
IMAGE_TAG ?= multiarch

CXX = g++

# Compiler flags (Linux-specific)
CXXFLAGS = -I/usr/include/GL -L/usr/lib -lGL -lglut -lGLU -lGLEW -lglfw -lX11 -lXi -lXrandr -lXxf86vm -lXinerama -lXcursor -lrt -lm -pthread

# Source files
SRCS = main.cpp

# Output binary
TARGET = main

# Default target
all: $(TARGET)

# Rule to build the target
$(TARGET): $(SRCS)
	$(CXX) -o $@ $^ $(CXXFLAGS)

# Clean target to remove compiled files
clean:
	rm -f $(TARGET)

# Setup Docker Buildx for multi-platform builds
buildx-setup:
	@echo "🔧 Setting up Docker Buildx builder..."
	docker buildx rm multiarch-builder || true
	docker buildx create --name multiarch-builder --driver docker-container --bootstrap
	docker buildx use multiarch-builder
	docker buildx inspect --bootstrap

# Multi-platform build and push using Buildx
buildx-push: buildx-setup
	@echo "🚀 Building and pushing multi-arch images for platforms: $(PLATFORMS)"
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG) \
		--push \
		. || { echo '❌ Buildx build and push failed'; exit 1; }
	@echo "✅ Successfully built and pushed images for AMD64 and ARM64"

# Multi-arch build without pushing (for local testing)
buildx-image: buildx-setup
	@echo "🔨 Building multi-arch images locally for platforms: $(PLATFORMS)"
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG) \
		--load \
		. || { echo '❌ Buildx build failed'; exit 1; }
	@echo "✅ Successfully built images for AMD64 and ARM64"



