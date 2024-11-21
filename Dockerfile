# Build stage
FROM golang:1.23-alpine3.20 AS builder
WORKDIR /app
COPY . . 
RUN go build -o main main.go
RUN apk add curl
RUN curl -L -o /app/migrate.tar.gz https://github.com/golang-migrate/migrate/releases/download/v4.18.1/migrate.linux-amd64.tar.gz \
    && tar -xvzf /app/migrate.tar.gz -C /app \
    && mv /app/migrate /app/migrate.linux-amd64 \
    && chmod +x /app/migrate.linux-amd64 \
    && rm /app/migrate.tar.gz

# Run stage
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate.linux-amd64 ./migrate
COPY app.env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migration ./migration

EXPOSE 8080
CMD ["/app/main"]
ENTRYPOINT [ "/app/start.sh" ]
