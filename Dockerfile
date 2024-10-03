FROM ubuntu:latest

# Set non-interactive mode for package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        vim g++ make && \
    rm -rf /var/lib/apt/lists/*

# Copy the source code to the container
COPY src/ /src/

# Set the working directory to /src
WORKDIR /src

# Compile the source code using Makefile
RUN make

# Command to run the compiled program
CMD ["./cobaapp"]