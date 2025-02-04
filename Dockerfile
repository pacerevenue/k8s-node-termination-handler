# build stage
FROM golang:latest@sha256:a83ce262aae35c84eae5df3e4298e62ac224672280b8cb6254134745c62595c9 AS build-env
RUN go get github.com/golang/dep/cmd/dep
RUN go get -d github.com/GoogleCloudPlatform/k8s-node-termination-handler || true
WORKDIR /go/src/github.com/GoogleCloudPlatform/k8s-node-termination-handler
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -tags netgo -o node-termination-handler

# final stage
FROM gcr.io/distroless/static:latest@sha256:1cc74da80bbf80d89c94e0c7fe22830aa617f47643f2db73f66c8bd5bf510b25
WORKDIR /app
COPY --from=build-env /go/src/github.com/GoogleCloudPlatform/k8s-node-termination-handler/node-termination-handler /app/
ENTRYPOINT ["./node-termination-handler"]
