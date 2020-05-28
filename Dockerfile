FROM rust:slim AS builder

WORKDIR /src
COPY . .
RUN cargo build --release \
    && strip ./target/release/boringtun

FROM debian:stable-slim

WORKDIR /app
COPY --from=builder /src/target/release/boringtun /app

ENV WG_LOG_LEVEL=info \
    WG_THREADS=4 \
    WG_SUDO=1 \
    INTERFACE_NAME=wg0

ENTRYPOINT /app/boringtun --foreground $INTERFACE_NAME
