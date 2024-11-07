###########4 paling iso###########
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


