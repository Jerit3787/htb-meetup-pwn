FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    gcc-multilib \
    socat \
    && rm -rf /var/lib/apt/lists/*

# Create challenge user
RUN useradd -m ctf

# Set working directory
WORKDIR /home/ctf

# Copy challenge files
COPY challenge.c .
COPY flag.txt .

# Compile the challenge
RUN gcc -m32 -fno-stack-protector -no-pie -o challenge challenge.c

# Set permissions
RUN chmod +x challenge && \
    chmod 444 flag.txt && \
    chown ctf:ctf challenge flag.txt

# Expose port
EXPOSE 9001

# Run as ctf user
USER ctf

# Start the challenge with socat
CMD ["socat", "TCP-LISTEN:9001,reuseaddr,fork", "EXEC:./challenge,stderr"]
