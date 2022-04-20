FROM alpine:3.14

RUN apk add curl

RUN case $(uname -m) in x86_64) arch=amd64;; aarch64) arch=arm64;; esac; \
    curl -Lo /kubectl https://dl.k8s.io/release/v1.23.5/bin/linux/$arch/kubectl && chmod +x /kubectl

COPY kubectl-proxy.sh /kubectl-proxy.sh
RUN chmod +x /kubectl-proxy.sh

ENTRYPOINT ["/kubectl-proxy.sh"]
