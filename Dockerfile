# Use a lightweight Ubuntu image
FROM ubuntu:22.04

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update packages and install gcc, make, and valgrind
RUN apt-get update && apt-get install -y \
    gcc \
    valgrind \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /code

# Open a bash terminal when the container starts
CMD ["/bin/bash"]