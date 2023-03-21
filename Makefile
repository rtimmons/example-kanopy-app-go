all: main.go internal/cli/cli.go internal/cli/version.go go.mod Dockerfile build/Dockerfile-test .drone.yml self-destruct reset-history

export GO_VERSION := 1.16
export GOLANGCI_IMAGE := golangci/golangci-lint:v1.42.1
export LICENSED_IMAGE := public.ecr.aws/kanopy/licensed-go:3.4.4
export DEFAULT_APP_PORT := 8080

export GIT_ROOT := $(shell git rev-parse --show-toplevel)
export GO_MODULE := $(shell git config --get remote.origin.url | grep -o 'github\.com[:/][^.]*' | tr ':' '/')
export CMD_NAME := $(shell basename ${GO_MODULE})

.PHONY: reset-history
reset-history:
	git checkout --orphan latest
	git add --all
	git commit --all --message "initial commit"
	git branch -D main
	git branch --move main

.PHONY: self-destruct
self-destruct:
	./template/Makefile.sh
	./template/README.md.sh
	rm -rf template/

.PHONY: clean
clean:
	rm -rf go.mod go.sum main.go internal/cli/ Dockerfile .drone.yml build/

go.mod:
	./template/go.mod.sh
	go mod tidy

main.go:
	./template/main.go.sh

internal/cli/cli.go:
	mkdir -p internal/cli
	./template/cli.go.sh

internal/cli/version.go:
	mkdir -p internal/cli
	./template/version-cli.go.sh

Dockerfile:
	./template/Dockerfile.sh

build/Dockerfile-test:
	mkdir -p build
	./template/Dockerfile-test.sh

.drone.yml:
	./template/.drone.yml.sh
