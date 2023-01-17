# TMA
TMA project

## Docker
Build:

```
docker-compose build
```

Up:

```
docker-compose up -d
```

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
# id,src_ip,src_port,dst_ip,dst_port,protocol,blocked,bytes,packets
0a0b01020a0b01011b391b9e06000000,10.11.1.2,6969,10.11.1.1,7070,6,0,13473856056937,7
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


