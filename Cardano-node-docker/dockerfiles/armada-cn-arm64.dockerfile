FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y zip wget automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev \
    zlib1g-dev make g++ tmux git jq curl libncursesw5 libtool autoconf llvm libnuma-dev

WORKDIR /cardano-node

##download latest cardano-cli & cardano-node version static build from armada-alliance.com
RUN wget -O 1_34_1.zip https://github.com/armada-alliance/cardano-node-binaries/blob/main/static-binaries/1_34_1.zip?raw=true \
    && unzip *.zip

##Install libsodium (needed for ScheduledBlocks.py)
WORKDIR /build/libsodium
RUN git clone https://github.com/input-output-hk/libsodium
RUN cd libsodium && \
    git checkout 66f017f1 && \
    ./autogen.sh && ./configure && make && make install

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y curl wget zip netbase jq libnuma-dev lsof bc python3-pip git && \
    rm -rf /var/lib/apt/lists/*

## Libsodium refs
COPY --from=builder /usr/local/lib /usr/local/lib

##Create node folders
WORKDIR /home/cardano
WORKDIR /home/cardano/.local/bin
WORKDIR /home/cardano/pi-pool/files
WORKDIR /home/cardano/pi-pool/scripts
WORKDIR /home/cardano/pi-pool/logs
WORKDIR /home/cardano/pi-pool/.keys
WORKDIR /home/cardano/git
WORKDIR /home/cardano/tmp

COPY --from=builder /cardano-node/cardano-node/cardano-* /home/cardano/.local/bin/
WORKDIR /home/cardano/pi-pool/scripts
COPY /files/run.sh /home/cardano/pi-pool/scripts
RUN git clone https://github.com/asnakep/ScheduledBlocks.git
RUN pip install -r /home/cardano/pi-pool/scripts/ScheduledBlocks/requirements.txt

##download gLiveView from original source
RUN wget https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/env \
    && wget https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/gLiveView.sh
RUN chmod +x env
RUN chmod +x gLiveView.sh

ENV PATH="/home/cardano/.local/bin:$PATH"

HEALTHCHECK --interval=10s --timeout=60s --start-period=300s --retries=3 CMD curl -f http://localhost:12798/metrics || exit 1

ENTRYPOINT ["bash", "-c"]
