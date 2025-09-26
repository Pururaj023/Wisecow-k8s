# Use Ubuntu base image
FROM ubuntu:latest

# Install dependencies and dos2unix
RUN apt-get update && apt-get install -y \
    fortune-mod \
    cowsay \
    netcat-openbsd \
    bash \
    dos2unix \
 && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy your wisecow.sh script
COPY wisecow.sh .

# Convert line endings to Unix style
RUN dos2unix wisecow.sh

# Make script executable
RUN chmod +x wisecow.sh

# Ensure PATH includes /usr/games so fortune & cowsay are found
ENV PATH="$PATH:/usr/games"

# Expose default port
EXPOSE 4499

# Run script with bash
CMD ["bash", "wisecow.sh"]
