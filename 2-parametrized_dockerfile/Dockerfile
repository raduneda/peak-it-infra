FROM alpine:3.12.0

WORKDIR /project

VOLUME /project

ARG TERRAFORM_VERSION

# Add repo modules
RUN apk add --no-cache \
    python3 \
    py3-pip \
    ca-certificates \
    bash \
    openssh \
    openssh-client \
    jq

# AWS CLI Python 3
RUN pip3 install --upgrade pip awscli boto3 \
    && echo "complete -C '/usr/bin/aws_completer' aws" >> ~/.bashrc \
    && ln -s /usr/bin/python3 /usr/bin/python

# Terraform
# Using ADD instead of COPY as we download from URL
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip /usr/bin/
RUN unzip /usr/bin/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin \
    && rm -f /usr/bin/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# GCloud
ADD https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-307.0.0-linux-x86_64.tar.gz /opt/
RUN tar zxf /opt/google-cloud-sdk-307.0.0-linux-x86_64.tar.gz -C /opt \
    && rm -f /opt/google-cloud-sdk-307.0.0-linux-x86_64.tar.gz \
    && ln -s /opt/google-cloud-sdk/bin/gcloud /usr/bin/ \
    && ln -s /opt/google-cloud-sdk/bin/gsutil /usr/bin/ \
    && echo "source /opt/google-cloud-sdk/completion.bash.inc" >> ~/.bashrc