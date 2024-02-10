FROM golang:1.21-bookworm AS builder


RUN apt update -qq && apt install -qqy git && mkdir -p /build

WORKDIR /build

# packer-plugin-arm-image: https://github.com/solo-io/packer-plugin-arm-image
RUN git clone https://github.com/solo-io/packer-plugin-arm-image.git -b v0.2.7 --depth 1 && \
  cd packer-plugin-arm-image && \
  go mod download && \
  go build -o packer-plugin-arm-image

FROM ubuntu:jammy

RUN apt update -y && \
  apt-get install -y \
  kpartx gdisk qemu-user-static gcc \
  unzip wget curl sudo less vim tmux python3-pip bash-completion && \
  rm -rf /var/lib/apt/lists/*

RUN pip install -U pip && pip install ansible~=8.4.0 pexpect~=4.8.0

# install awscli
RUN cd /tmp && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -r aws awscliv2.zip

ENV PACKER_VERSION=1.9.4

RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -O /tmp/packer.zip && \
  unzip /tmp/packer.zip -d /bin && \
  rm /tmp/packer.zip

COPY image-job /image-job
COPY docker/image-job/packer.sh /packer.sh
COPY docker/image-job/.tmux.conf /root/.tmux.conf
COPY --from=builder /build/packer-plugin-arm-image/packer-plugin-arm-image /bin/packer-plugin-arm-image
RUN chmod +x /packer.sh
RUN chmod +x /bin/packer-plugin-arm-image

WORKDIR /image-job

CMD ["/bin/bash"]
