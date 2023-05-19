FROM jlesage/baseimage-gui:ubuntu-20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y ca-certificates curl gnupg
#RUN apt-get install -y \
#	libgbm1 libgtk-3-0 libnotify4 libnss3 libxss1 xdg-utils libatspi2.0-0 libsecret-1-0
RUN curl -sL https://repo.chia.net/FD39E6D3.pubkey.asc | gpg --dearmor -o /usr/share/keyrings/chia.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/chia.gpg] https://repo.chia.net/debian/ stable main" | tee /etc/apt/sources.list.d/chia.list > /dev/null
RUN apt-get update
RUN apt-get install -y chia-blockchain

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
ENV X DG_DATA_HOME=/chia/xdg/data \
    XDG_CONFIG_HOME=/chia/xdg/config \
    XDG_CACHE_HOME=/chia/xdg/cache

#WORKDIR /chia
#USER chia

#USER 0

#COPY chia-blockchain_1.8.1_amd64.deb /chia/
#RUN dpkg -i /chia/chia-blockchain_1.8.1_amd64.deb

#ENV PATH="/chia/chia-blockchain/venv/bin/:$PATH" \
ENV \
  APP_USER=chia \
  APP_NAME=ChiaGUI

# configurables from previous layers
# TAKE_CONFIG_OWNERSHIP=1
# DISPLAY_HEIGHT=768
# DISPLAY_WIDTH=1280

COPY root/ /

# TODO versioning label

