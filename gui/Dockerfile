FROM jlesage/baseimage-gui:ubuntu-18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
# Stuff for chia install
RUN apt-get install -y \
	bash git lsb-release sudo apt-utils curl wget bc \
	python3.7-venv python3.7-distutils \
	nodejs libxss1
# Electron build deps,
# TODO replace with proper runtime deps
RUN apt-get install -y \
	build-essential clang libdbus-1-dev libgtk-3-dev \
	libnotify-dev libgnome-keyring-dev \
	libasound2-dev libcap-dev libcups2-dev libxtst-dev \
	libxss1 libnss3-dev gcc-multilib g++-multilib curl \
	gperf bison python-dbusmock openjdk-8-jre

# Update npm for 1804
RUN npm install -g n \
&& n stable

# Cleanup inherited user management and make our own chia user
# TODO ideally /config would be home but since it is marked as a
#      volume in a previous layer we can't use it because any changes
#      we make will be lost, this is notable for the npm install later
RUN rm /etc/cont-init.d/00-app-user-map.sh \
&& rm /etc/cont-init.d/00-set-home.sh \
&& useradd -d /chia -m -u 1000 -U -s /bin/bash chia
#&& useradd -d /chia -m -u 1000 -U -G sudo -s /bin/bash chia \
#&& echo "%sudo ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# Move xdg off /cache
# TODO XDG_DATA_HOME controls where python_keyring dir is
#      combine with ~/.pki to avoid key import
ENV XDG_DATA_HOME=/chia/xdg/data \
    XDG_CONFIG_HOME=/chia/xdg/config \
    XDG_CACHE_HOME=/chia/xdg/cache

WORKDIR /chia
USER chia

# Clone chia
ARG BRANCH="latest"
RUN git clone --branch ${BRANCH} --recursive \
	https://github.com/Chia-Network/chia-blockchain.git
COPY patches/ chia-blockchain/

# Install chia
RUN cd chia-blockchain \
&& python3.7 -m venv venv \
&& . ./venv/bin/activate \
&& python -m pip install --upgrade pip \
&& python -m pip install wheel \
&& python -m pip install --extra-index-url https://pypi.chia.net/simple/ miniupnpc==2.2.2 \
&& python -m pip install -e . --extra-index-url https://pypi.chia.net/simple/

# Install chia gui
# TODO still need to deal with all the startService calls in patch
#      since we manage the daemons the gui should not try to start them
RUN cd chia-blockchain/chia-blockchain-gui \
&& patch -p1 < ../0001-gui-docker-compat.patch \
&& . ../venv/bin/activate \
&& npm install \
&& (npm audit fix || true) \
&& npm run build

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

