FROM rust:1.47-alpine3.11 as build
WORKDIR /tmp
RUN apk --no-cache add musl-dev=~1.1 openssl-dev=~1.1
# As of today (Thu 05 Nov 2020 10:37:09 PM EST), there is no way to build only
# the dependencies unfortunately. With every source changes, these steps will
# be run and cargo will rebuild everything.
COPY . /tmp/
RUN cargo build --release --bin gitignore

FROM rust:1.47-alpine3.11
LABEL maintainer="Antoine Gagné <gagnantoine@gmail.com>"
LABEL name="gitignore"
LABEL description="A tool to generate .gitignore by using the gitignore.io API"
LABEL vcs-url="https://github.com/AntoineGagne/gitignore"

RUN set -e \
    && addgroup gitignore \
    && adduser gitignore -S -G gitignore
USER gitignore
COPY --from=build /tmp/target/release/gitignore /usr/bin/
ENTRYPOINT ["/usr/bin/gitignore"]
CMD ["list"]
