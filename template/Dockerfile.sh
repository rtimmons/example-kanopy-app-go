#!/bin/bash

cat <<EOF > "${GIT_ROOT}/Dockerfile"
FROM golang:${GO_VERSION} as build
ARG VERSION="0.0.0"
ARG GIT_COMMIT
WORKDIR /go/src/app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -ldflags="-X '${GO_MODULE}/internal/version.version=\${VERSION}' -X '${GO_MODULE}/internal/version.gitCommit=\${GIT_COMMIT}'" -o /go/bin/app

FROM debian:buster-slim
RUN apt-get update && apt-get install --yes ca-certificates
RUN groupadd -r app && useradd --no-log-init -r -g app app
USER app
COPY --from=build /go/bin/app /
ENV APP_ADDR ":${DEFAULT_APP_PORT}"
EXPOSE ${DEFAULT_APP_PORT}
ENTRYPOINT ["/app"]
EOF
