FROM ubuntu:latest

ARG TERRAGRUNT_VERSION=0.44.4
ARG TERRAFORM_VERSION=1.3.9
ARG AWS_CLI_VERSION=2.11.5
ARG KUBECTL_VERSION=1.25.0

ENV TERRAGRUNT_VERSION=$TERRAGRUNT_VERSION \
    TERRAFORM_VERSION=$TERRAFORM_VERSION \
    AWS_CLI_VERSION=$AWS_CLI_VERSION \
    KUBECTL_VERSION=$KUBECTL_VERSION

RUN apt-get update && apt-get install -y curl unzip git

# Install Terragrunt
RUN curl -LO "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_386" \
    && chmod +x terragrunt_linux_386 \
    && mv terragrunt_linux_386 /usr/local/bin/terragrunt

# Install Terraform
RUN curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_386.zip" \
  && unzip terraform_${TERRAFORM_VERSION}_linux_386.zip \
  && mv terraform /usr/local/bin/ \
  && rm terraform_${TERRAFORM_VERSION}_linux_386.zip

# Install AWS CLI v2
RUN curl -L "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/386/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/kubectl

CMD ["/bin/bash"]
