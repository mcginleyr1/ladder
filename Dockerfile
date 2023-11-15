# Building the binary of the App
FROM golang:1.21 AS build

WORKDIR /go/src/ladder

COPY . .

RUN mkdir -p /dev/net && \
    mknod /dev/net/tun c 10 200 && \
    chmod 600 /dev/net/tun

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux go build -o ladder cmd/main.go

FROM tailscale/tailscale:stable as release

WORKDIR /app

COPY --from=build /go/src/ladder/ladder .
RUN chmod +x /app/ladder


COPY start.sh .

EXPOSE 8080

CMD ["/app/start.sh"]
