FROM quay.io/projectquay/golang:1.20 as builder
ARG OS
ARG OS=linux
WORKDIR /go/src/app
COPY . .
RUN make ${OS}

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/telebot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./telebot"]