FROM ubuntu:bionic

ENV KUBE_LATEST_VERSION="v1.18.3"
# Note: Latest version of helm may be found at
# https://github.com/kubernetes/helm/releases
ENV HELM3_VERSION="v3.2.4"
ENV HELM2_VERSION="v2.16.9"

WORKDIR /root

RUN apt-get update \
    && apt-get install --no-install-recommends --yes \
    less \
    locales \
    apache2-utils \
    software-properties-common \
    bind9-host \
    curl \
    dnsutils \
    httpie \
    iputils-ping \
    jq \
    netcat-openbsd \
    mongodb-clients \
    mysql-client \
    net-tools \
    postgresql-client \
    redis-tools \
    swaks \
    telnet \
    vim \
    nano \
    wget \
    influxdb-client \
    rabbitmq-server \
    python-setuptools \
    python-pip \
    gnupg \
    git \
    unzip \
    apt-transport-https \
    ca-certificates \
    zsh \
    openssh-client \
    bash-completion \
    make
    
ENV SHELL /usr/bin/bash

# Install kubectl

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && apt-get -y install --no-install-recommends kubectl

# Install Helm 3

RUN wget -q https://get.helm.sh/helm-${HELM3_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

# Install Helm 2

RUN wget -q https://get.helm.sh/helm-${HELM2_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm2 \
    && chmod +x /usr/local/bin/helm2

# Install rke cli

RUN wget https://github.com/rancher/rke/releases/download/v1.1.7/rke_linux-amd64 \
    && chmod +x rke_linux-amd64 \
    && mv rke_linux-amd64 /usr/local/bin/rke

## Install Docker 19.03 CLI

ENV DOCKERVERSION=19.03.9
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

# Install kubectx and kunens

RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx \
    && ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx \
    && ln -s /opt/kubectx/kubens /usr/local/bin/kubens \
    && rm -rf kubectx \
    && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install

COPY .bashrc /root

WORKDIR /tmp

RUN exec bash

ENTRYPOINT ["/bin/bash"]
