# # Menggunakan base image Ubuntu terbaru
# FROM ubuntu:latest

# # Set non-interactive mode untuk instalasi package
# ENV DEBIAN_FRONTEND=noninteractive

# # Install dependency yang diperlukan untuk OpenGL dan C++
# RUN apt-get update && apt-get install -y \
#     build-essential \
#     freeglut3-dev \
#     libglew-dev \
#     libglfw3-dev \
#     libgl1-mesa-dev \
#     libglu1-mesa-dev \
#     mesa-utils \
#     xorg \
#     vim && \
#     rm -rf /var/lib/apt/lists/*

# # Copy source code ke dalam container
# COPY src/ /src/

# # Set working directory di /src
# WORKDIR /src

# # Compile source code menggunakan Makefile
# RUN make

# # Command untuk menjalankan program yang sudah dikompilasi
# CMD ["./main"]

########coba 1###
# Menggunakan base image Ubuntu
# FROM ubuntu:latest

# # Memasang dependensi yang diperlukan
# RUN apt-get update && apt-get install -y \
#     build-essential \
#     g++ \
#     libgl1-mesa-dev \
#     freeglut3-dev \
#     libglew-dev \
#     libglfw3-dev \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# # Set working directory
# WORKDIR /src

# # Salin semua file dari host ke container
# COPY . .

# # List file untuk memastikan file sudah di-copy
# RUN ls -al

# # Compile source code menggunakan Makefile
# RUN make

# # Command untuk menjalankan aplikasi yang sudah di-compile
# CMD ["./main"]

##########iki paling iso#####
# Menggunakan base image Ubuntu
FROM ubuntu:latest

# Memasang dependensi yang diperlukan
RUN apt-get update && apt-get install -y \
    build-essential \
    g++ \
    libgl1-mesa-dev \
    freeglut3-dev \
    libglew-dev \
    libglfw3-dev \
    libglu1-mesa-dev \
    x11-xserver-utils \
    libxi-dev \
    libxrandr-dev \
    libxcursor-dev \
    libxinerama-dev \
    libxxf86vm-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /src

# Salin semua file dari host ke container
COPY . .

# List file untuk memastikan file sudah di-copy
RUN ls -al

# Compile source code menggunakan Makefile
RUN make

# Command untuk menjalankan aplikasi yang sudah di-compile
CMD ["./main"]


# ini coba dulu nanti dihapus kalo tidak dapat berjalan #
FROM ubuntu:latest

# Memasang dependensi yang diperlukan
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential \
    g++ \
    libgl1-mesa-dev \
    freeglut3-dev \
    libglew-dev \
    libglfw3-dev \
    libglu1-mesa-dev \
    x11-xserver-utils \
    libxi-dev \
    libxrandr-dev \
    libxcursor-dev \
    libxinerama-dev \
    libxxf86vm-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /src

# Salin semua file dari host ke container
COPY . .

# List file untuk memastikan file sudah di-copy
RUN ls -al

# Compile source code menggunakan Makefile
RUN make

# Command untuk menjalankan aplikasi yang sudah di-compile
ENTRYPOINT ["./main"]
