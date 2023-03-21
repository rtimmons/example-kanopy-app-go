#!/bin/bash

cat <<EOF > "${GIT_ROOT}/.drone.yml"
---
kind: pipeline
name: test

trigger:
  branch: [main]

workspace:
  path: /go/src/github.com/\${DRONE_REPO}

volumes:
  - name: cache
    temp: {}

steps:
  - name: test
    image: ${GOLANGCI_IMAGE}
    volumes:
      - name: cache
        path: /go
    commands:
      - make test

  - name: license-check
    image: ${LICENSED_IMAGE}
    commands:
      - licensed cache
      - licensed status

  - name: build
    image: plugins/kaniko-ecr
    pull: always
    volumes:
      - name: cache
        path: /go
    settings:
      no_push: true
    when:
      event: [pull_request]
---
kind: pipeline
name: publish-amd64
platform:
  arch: amd64

depends_on:
  - test

trigger:
  branch: main
  event: [push, tag]

steps:
  - name: publish
    image: plugins/kaniko-ecr
    pull: always
    environment:
      VERSION: \${DRONE_TAG:=0.0.0}
      GIT_COMMIT: \${DRONE_COMMIT_SHA:0:7}
    settings:
      create_repository: true
      repo: \${DRONE_REPO_NAME}
      build_args:
        - VERSION
        - GIT_COMMIT
      auto_tag: true
      auto_tag_suffix: amd64
      registry:
        from_secret: ecr_registry
      access_key:
        from_secret: ecr_access_key
      secret_key:
        from_secret: ecr_secret_key
---
kind: pipeline
name: publish-arm64
platform:
  arch: arm64

depends_on:
  - test

trigger:
  branch: main
  event: [push, tag]

steps:
  - name: publish
    image: plugins/kaniko-ecr
    pull: always
    environment:
      VERSION: \${DRONE_TAG:=0.0.0}
      GIT_COMMIT: \${DRONE_COMMIT_SHA:0:7}
    settings:
      create_repository: true
      repo: \${DRONE_REPO_NAME}
      build_args:
        - VERSION
        - GIT_COMMIT
      auto_tag: true
      auto_tag_suffix: arm64
      registry:
        from_secret: ecr_registry
      access_key:
        from_secret: ecr_access_key
      secret_key:
        from_secret: ecr_secret_key
EOF
