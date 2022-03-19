FROM alpine:latest
LABEL MAINTAINER git-ed <https://github.com/ookangzheng>

EXPOSE 53
EXPOSE 5353

RUN apk update && apk upgrade
RUN set -ex \
  apk add --no-cache curl \
  && rm -rf /var/cache/apk/*

# /usr/bin/dnsproxy
RUN if [ "$TARGETPLATFORM" == "linux/amd64" ]; then cd /tmp \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest' | sed -n '/url.*linux-amd64/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && mv linux-amd64/dnsproxy /usr/bin/ \
    && dnsproxy --version \
    && rm -rf /tmp/*; fi

RUN if [ "$TARGETPLATFORM" == "linux/arm64" ]; then cd /tmp \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest' | sed -n '/url.*linux-arm64/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && mv linux-arm64/dnsproxy /usr/bin/ \
    && dnsproxy --version \
    && rm -rf /tmp/*; fi

ENV ARGS="--cache --cache-min-ttl=30  --cache-max-ttl=300 --cache-optimistic --edns --all-servers --tls-min-version=1.2 --refuse-any -p 53 -p 5353 -u quic://dns.adguard.com -u tls://1.1.1.2 -u tls://9.9.9.9 -u https://dns.adguard.com/dns-query -f tcp://9.9.9.11:9953 -b 8.8.8.8 -b 1.0.0.1 -f 94.140.14.14"

ENV ARGS_SP="-u=[/github.com/]tcp://80.80.80.80 -u=[/githubassets.com/]tcp://80.80.80.80 -u=[/githubusercontent.com/]tcp://80.80.80.80"

CMD /usr/bin/dnsproxy ${ARGS} ${ARGS_SP}
