FROM golang:1.17-alpine AS builder
ENV CGO_ENABLED=0
WORKDIR /backend
COPY vm/go.* .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go mod download
COPY vm/. .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go build -trimpath -ldflags="-s -w" -o bin/service

FROM --platform=$BUILDPLATFORM node:17.7-alpine3.14 AS client-builder
WORKDIR /ui
# cache packages in layer
COPY ui/package.json ui/yarn.lock ui/.yarnrc.yml ./
COPY ui/.yarn/ ./.yarn/
RUN yarn install --immutable

# install
COPY ui .
RUN yarn build

FROM alpine
LABEL org.opencontainers.image.title="Polyms" \
    org.opencontainers.image.description="Polyms Docker extension" \
    org.opencontainers.image.vendor="Polyms" \
    com.docker.desktop.extension.api.version=">= 0.2.3" \
    com.docker.extension.screenshots="" \
    com.docker.extension.detailed-description="" \
    com.docker.extension.publisher-url="" \
    com.docker.extension.additional-urls="" \
    com.docker.extension.changelog="" \
    com.docker.desktop.extension.icon="https://polyms.app/favicon.png"

COPY --from=builder /backend/bin/service /
COPY docker-compose.yaml .
COPY metadata.json .
COPY favicon.svg .
COPY --from=client-builder /ui/dist ui
CMD /service -socket /run/guest-services/extension-polyms-docker.sock
