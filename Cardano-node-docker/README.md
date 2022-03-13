# Cardano Node Docker Image (for ARM64 devices)

In this project you will find the files to build a docker image containing all the needed files to run a Cardano full node.
The docker image can run on any arm64 device (such as a RaspberryPi, Mac Mini M1, etc.). It can be configured as a relay or bock production node.

If you are enjoying the content of this project, please consider supporting me by delegating to my stake pool, ticker [MINI1](https://www.adaministake.com) or
donating ₳D₳ to: addr1qygv5fqsfjhfgkx7fhkkegxksx56dsu262vhaxr4mvuukt8uqh7nhjs3pcl98xr2zhmtqk6qkmr4gszxjrs3lnpedqdqyr3jzc

## Why using docker image to run a Cardano node?

The elegant thing of a Cardano node deployed as a Docker images is, that it can be installed and started seamlessly straight out-of-the box.
The day you should decide to remove it, you just have to remove one file - the image. Another advantage is that it can run on any operating 
system that has Docker installed. Using this Docker image reduces the complexity and effort of setting up a Cardano node from scratch. 
It is therefore recommended for less experienced users.

## System requirements

* CPU: ARM64 processor min 2 cores at 2GHz or faster.
* Memory: 12GB of RAM.
* Storage: 50 GB.
* OS: Linux, MacOS, Win
* Additional Software: Docker
* Broadband: 10 Mbps +

If you intend to use a Raspberry Pi 8GB RAM for the deployment of this docker image, I highly recommend to follow the Armada Alliance 
[Server Setup guide](https://docs.armada-alliance.com/learn/stake-pool-guides/pi-pool-tutorial/pi-node-full-guide/server-setup) first. 
This guide describes how to optimize the Hardware to satisfy the above listed system requirements.  

# 1.Install Docker

The installation of Docker varies from operating system to operating system. For this reason, I share some helpful and good installation 
guide links for the different operating systems.

* [Install Docker on Linux (Ubuntu)](https://github.com/speedwing/cardano-staking-pool-edu/blob/master/DOCKER.md)
* [Install Docker on MacOs](https://docs.docker.com/desktop/mac/install/)
* [Install Docker on Windows](https://docs.docker.com/desktop/windows/install/)

# 2. Download repository and Cardano node configuration files

Let's clone this repository to your host system first

```bash
cd ${HOME}
sudo git clone https://github.com/jterrier84/minipool.git
cd minipool/Cardano-node-docker
```  

We will now download the latest official Cardano node configuration files from the IOHK repository and store them on our host system.

For the sake of this tutorial we will download and set up the configuration files for the Cardano testnet. If you need the files for the mainnet
just replace "testnet" with "mainnet" here below.
 
Note: As the configuration files might require modifications over time, it is way more practical to have them stored on the host, 
rather than have them stored inside the Docker container. The Docker image will then access to these files via file sharing.

```bash
cd node/files
export NODE_CONFIG="testnet"
export NODE_BUILD_NUM=$(curl https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html | grep -e "build" | sed 's/.*build\/\([0-9]*\)\/download.*/\1/g') 
sudo wget -N https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/${NODE_CONFIG}-config.json
sudo wget -N https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/${NODE_CONFIG}-byron-genesis.json
sudo wget -N https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/${NODE_CONFIG}-shelley-genesis.json
sudo wget -N https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/${NODE_CONFIG}-alonzo-genesis.json
sudo wget -N https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/${NODE_CONFIG}-topology.json
```

# 3. Build the Cardano node docker container

At this point it's time to build the docker container. The container will include:

1. cardano-node & cardano-cli v1.34.1 - Cardano binaries to run the node (Download compiled binaries from [Armada Alliance GitHub](https://github.com/armada-alliance/cardano-node-binaries)) 
2. gLiveView - Monitoring tool for the Cardano node
3. [SchedluedBlocks - Tool to query the scheduled slots for a block productin node. (Credits for this tool goes to [SNAKE POOL](https://github.com/asnakep/ScheduledBlocks))

```bash
cd /${HOME}/minipool/Cardano-node-docker/dockerfiles
sudo ./build.sh
```
















