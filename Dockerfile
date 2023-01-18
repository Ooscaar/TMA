## Build the backend
FROM golang:1.19-buster AS build-backend

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /backend

# Build the client
# C program with ncurses library needed
FROM gcc:latest AS build-client

WORKDIR /app

# Copy makefile and source code
COPY client/Makefile ./
COPY client/main.c ./

# Run make: lab binary will be created
RUN gcc -o /lab main.c -lncurses -pthread

## Ubuntu final base image
FROM ubuntu:latest

WORKDIR /


# Install packages
# clang llvm libelf-dev libpcap-dev gcc-multilib build-essential tcpdump ethtool socat traceroute iproute2 git iputils-ping
RUN apt-get update && apt-get install -y \
    clang \
    llvm \
    libelf-dev \
    libpcap-dev \
    gcc-multilib \
    build-essential \
    tcpdump \
    ethtool \
    socat \
    traceroute \
    iproute2 \
    git \
    wget \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build-backend /backend /usr/local/bin/backend
COPY --from=build-client /lab /usr/local/bin/lab

# Copy ebpf folder
COPY eBPF_code .

# Set up ebpf program and maps
# --auto-mode: needed inside the docker
COPY docker_entrypoint /docker_entrypoint
RUN chmod +x /docker_entrypoint

EXPOSE 8080

ENTRYPOINT ["/docker_entrypoint"]
