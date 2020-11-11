FROM rust:1.47-alpine3.11 as build
WORKDIR /tmp
RUN apk --no-cache add musl-dev=~1.1 openssl-dev=~1.1
# As of today (Thu 05 Nov 2020 10:37:09 PM EST), there is no way to build only
# the dependencies unfortunately. To prevent this, we generate a dummy main
# file which will allow the dependencies to be built.
COPY Cargo.lock Cargo.toml /tmp/
RUN mkdir -p /tmp/src && \
    echo "fn main() {print!(\"Dummy main\");}" > src/main.rs
RUN cargo build --target x86_64-unknown-linux-musl --release && \
    rm /tmp/src/main.rs /tmp/target/x86_64-unknown-linux-musl/release/deps/gitignore*

COPY src /tmp/src
RUN cargo build --target x86_64-unknown-linux-musl --release --bin gitignore

FROM rust:1.47-alpine3.11
LABEL maintainer="Antoine Gagné <gagnantoine@gmail.com>"
LABEL name="gitignore"
LABEL description="A tool to generate .gitignore by using the gitignore.io API"
LABEL vcs-url="https://github.com/AntoineGagne/gitignore"

COPY --from=build /tmp/target/x86_64-unknown-linux-musl/release/gitignore /usr/bin/gitignore
RUN set -e && \
    addgroup gitignore && \
    adduser gitignore -S -G gitignore
USER gitignore
ENTRYPOINT ["/usr/bin/gitignore"]
CMD ["list"]
