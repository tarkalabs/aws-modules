FROM alpine/terragrunt:1.3.9

ARG KUBECTL_VERSION="1.26"

RUN apk update \
  && apk add --no-cache curl

RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && chmod +x kubectl \
  && mv kubectl /usr/local/bin/kubectl
