#!/bin/bash

cat <<EOF > "${GIT_ROOT}/build/Dockerfile-test"
FROM ${GOLANGCI_IMAGE} as cache
ENV GOLANGCI_LINT_CACHE /root/.cache/go-build
WORKDIR \$GOPATH/src/${GO_MODULE}

RUN apk update \
 && apk add make

# download modules and build cache
COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN golangci-lint run --timeout=5m \
 && go test ./...
EOF
