# syntax=docker/dockerfile:1
FROM golang:1.21.0 as builder
WORKDIR /app
COPY . .
RUN go mod download

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64
RUN go build -o main main.go

FROM gcr.io/distroless/base-debian10
COPY --from=builder /app/main /usr/local/bin/app
EXPOSE 8080
USER nonroot:nonroot
CMD ["/usr/local/bin/app"]
