# TMA
TMA project

## Docker
Build:

```
DOCKER_BUILDKIT=1 docker-compose build
```

Up:

```
docker-compose up -d
```

Server available on http://localhost:8000

## Middleware

First, follow instruction from [eBPF_code/README.md](eBPF_code/README.md) to generate the corresponding eBPF code and eBPF maps.

Then, you can build the middleware with:

```bash
$: go build .
```

Or just run it with:

```bash
$: go run main.go
```

The server will be available on port http://localhost:8000.

Note: make sure to run the middleware as root.

## API

### Get flows

```http
GET /flows
```

Response: 

```csv
# id,src_ip,src_port,dst_ip,dst_port,protocol,blocked,speed(Bps),bytes
ac120001ac120002d0001f4006000000,172.18.0.1,53248,172.18.0.2,8000,6,0,0.000000,2328415923817
```

### Block flow

```http
POST /flows/{id}/block
```

### Unblock flow

```http
POST /flows/{id}/unblock
```

## Demo
[![asciicast](https://asciinema.org/a/552125.svg)](https://asciinema.org/a/552125)


