##########iki paling iso#####
#Menggunakan base image Ubuntu
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


##### ini coba dulu nanti dihapus kalo tidak dapat berjalan #

