FROM golang:1.14.3

ENV TERRAFORM_VERSION="0.12.26"
ENV TERRAGRUNT_VERSION="0.23.28"
ENV TF_INPUT="0"

# Install utilities
RUN apt-get update \
    && apt-get install unzip

# Get Terraform
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O /tmp/terraform_${TERRAFORM_VERSION} \
    && unzip -d /usr/local/bin /tmp/terraform_${TERRAFORM_VERSION}

# Get Terragrunt
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -O /usr/local/bin/terragrunt \
    && chmod +x /usr/local/bin/terragrunt

ENTRYPOINT ["terragrunt"]