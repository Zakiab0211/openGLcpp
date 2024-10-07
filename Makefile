# CXX = g++

# # Compiler flags khusus untuk Linux (menghapus -mconsole)
# CXXFLAGS = -I/usr/include -L/usr/lib -lGL -lGLU -lglut -lGLEW -lglfw

# # Source files
# SRCS = main.cpp

# # Output binary
# TARGET = main

# # Default target
# all: $(TARGET)

# # Rule untuk membangun target
# $(TARGET):	$(SRCS)
# 	$(CXX) -o $@ $^ $(CXXFLAGS)

# # Clean target untuk menghapus file yang sudah di-compile
# clean:
# 	rm -f $(TARGET)

##############2 bisa###############
# # Compiler
# CXX = g++

# # Compiler flags (Windows/MSYS2-specific)
# CXXFLAGS = -I/msys64/mingw64/include/GL -L/msys64/mingw64/lib -lopengl32 -lfreeglut -lglu32 -lglew32 -lglfw3 -lgdi32 -lwinmm -mconsole

# # Source files
# SRCS = main.cpp

# # Output binary
# TARGET = main

# # Default target
# all: $(TARGET)

# # Rule to build the target
# $(TARGET):	$(SRCS)
# 	$(CXX) -o $@ $^ $(CXXFLAGS)

# # Clean target to remove compiled files
# clean:
# 	rm -f $(TARGET)
#####3########
# CC = g++
# CXXFLAGS = -I/msys64/mingw64/include/GL -L/msys64/mingw64/lib -lopengl32 -lfreeglut -lglu32 -lglew32 -lglfw3 -lgdi32 -lwinmm
# LDFLAGS = 

# # Makefile settings - Can be customized.
# APPNAME = cobaapp
# EXT = .cpp
# SRCDIR =  # Pastikan ini mengarah ke direktori yang benar
# OBJDIR = 

# ############## Do not change anything from here downwards! #############
# SRC = $(wildcard $(SRCDIR)/*$(EXT))
# OBJ = $(SRC:$(SRCDIR)/%$(EXT)=$(OBJDIR)/%.o)
# DEP = $(OBJ:$(OBJDIR)/%.o=%.d)

# # UNIX-based OS variables & settings
# RM = rm -f
# DELOBJ = $(OBJ)

# ########################################################################
# ####################### Targets beginning here #########################
# ########################################################################

# all: $(APPNAME)

# # Builds the app
# $(APPNAME): $(OBJ)
# 	$(CC) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

# # Creates the dependency rules
# %.d: $(SRCDIR)/%$(EXT)
# 	@$(CPP) $(CXXFLAGS) $< -MM -MT $(@:%.d=$(OBJDIR)/%.o) > $@

# # Includes all .h files
# -include $(DEP)

# # Building rule for .o files and its .cpp in combination with all .h
# $(OBJDIR)/%.o: $(SRCDIR)/%$(EXT)
# 	mkdir -p $(OBJDIR)
# 	$(CC) $(CXXFLAGS) -o $@ -c $<

# ################### Cleaning rules for Unix-based OS ###################
# # Cleans complete project
# .PHONY: clean
# clean:
# 	$(RM) $(DELOBJ) $(DEP) $(APPNAME)

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