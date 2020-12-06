FROM alpine:edge

RUN apk add --no-cache libcrypto1.1 libssl1.1 libstdc++ --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
  && apk add --no-cache oath-toolkit-libpskc --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
  && apk add --no-cache nettle --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
  # openconnect is not yet available on main
  && apk add --no-cache openconnect socat --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --allow-untrusted

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
