## Docker build

```shell

docker buildx build --platform linux/arm64 --no-cache=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')  --build-arg TARGETPLATFORM=linux/arm64 -t "ookangzheng/dnsproxy:arm64" -f Dockerfile .

docker buildx build --platform linux/amd64 --no-cache=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')  --build-arg TARGETPLATFORM=linux/amd64 -t "ookangzheng/dnsproxy:amd64" -f Dockerfile .

docker push ookangzheng/dnsproxy:arm64

docker push ookangzheng/dnsproxy:amd64
```

## Using docker compose

### Edit `docker-compose.yml`

```bash
version: "3.3"
services:
  dnsproxy:
    ports:
      - "53:53/tcp"
      - "53:53/udp"
    environment:
      - "ARGS=-u=https://doh-jp.blahdns.com/dns-query -u quic://dot-sg.blahdns.com:784 -f 94.140.14.14:53 -f 94.140.14.14:8853 -b 9.9.9.9:9953 -b 9.9.9.9:53 --cache --cache-min-ttl=30 --cache-max-ttl=300 --cache-optimistic --edns "
    image: ookangzheng/dnsproxy

```

```shell
docker compose up -d --force-recreate
```

## Credit

1. https://github.com/vmstan/dnsproxy/blob/main/Dockerfile
2. https://github.com/AdguardTeam/dnsproxy
