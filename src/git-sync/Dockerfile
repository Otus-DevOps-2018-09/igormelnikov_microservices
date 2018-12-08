FROM alpine:3.8

RUN apk add --no-cache git

WORKDIR /app/
COPY sync.sh .
CMD ["/bin/sh", "sync.sh"]
