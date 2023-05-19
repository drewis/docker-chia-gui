FROM jlesage/baseimage-gui:ubuntu-20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
# Stuff for chia install
RUN apt-get install -y \
	bash git lsb-release sudo apt-utils curl wget bc \
	python3.8-venv python3.8-distutils \
	nodejs libxss1
# Electron build deps,
# TODO replace with proper runtime deps
RUN apt-get install -y \
	build-essential clang libdbus-1-dev libgtk-3-dev \
	libnotify-dev \
	libasound2-dev libcap-dev libcups2-dev libxtst-dev \
	libxss1 libnss3-dev gcc-multilib g++-multilib curl \
	gperf bison python3-dbusmock openjdk-11-jre

# Update npm for 1804
RUN npm install -g n \
&& n stable

# Cleanup inherited user management and make our own chia user
# TODO ideally /config would be home but since it is marked as a
#      volume in a previous layer we can't use it because any changes
#      we make will be lost, this is notable for the npm install later
RUN rm /etc/cont-init.d/00-app-user-map.sh \
&& rm /etc/cont-init.d/00-set-home.sh \
&& useradd -d /chia -m -u 1000 -U -G sudo -s /bin/bash chia \
&& echo "%sudo ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
#&& useradd -d /chia -m -u 1000 -U -s /bin/bash chia

# Move xdg off /cache
# TODO XDG_DATA_HOME controls where python_keyring dir is
#      combine with ~/.pki to avoid key import
ENV XDG_DATA_HOME=/chia/xdg/data \
    XDG_CONFIG_HOME=/chia/xdg/config \
    XDG_CACHE_HOME=/chia/xdg/cache

WORKDIR /chia
USER chia

# Clone chia
ARG BRANCH="main"
RUN git clone --branch ${BRANCH} --recursive \
	https://github.com/Chia-Network/chia-blockchain.git

# Copy patches
COPY patches/ chia-blockchain/

# Install patches
RUN cd chia-blockchain/chia-blockchain-gui \
&& patch -p1 < ../0001-gui-docker-compat.patch

# Install chia
RUN cd chia-blockchain \
&& ./install.sh \
&& . ./activate \
&& ./install-gui.sh

USER 0

ENV PATH="/chia/chia-blockchain/venv/bin/:$PATH" \
  APP_USER=chia \
  APP_NAME=ChiaGUI

# configurables from previous layers
# TAKE_CONFIG_OWNERSHIP=1
# DISPLAY_HEIGHT=768
# DISPLAY_WIDTH=1280

COPY root/ /

# TODO versioning label

