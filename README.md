# Overview

Use at your own risk

Start by editing the `docker-compose.yaml` to suit.

The idea is that persistent storage is bind mounted in so upgrades and restarts require no further intervention beyond initial setup. The containers assume you already have a chia config (`~/.chia`), copy this somewhere else e.g `/srv/chia/config`  for the bind mount into `/chia/.chia`. The container imports your key from `/chia/.chia/nmemonic.txt` file see `gui/root/etc/cont-init.d/10-chiainit.sh`.

# GUI

Run the container
```
docker-compose -p chia up --build -d
```
The gui will be available on port `5800`, it takes a couple minutes to startup

## First time init

TODO can't remember

# Issues

- The GUI tries to start all the services (which were already started by s6) this causes errors to show in logs, these can be ignored
- Lots of TODOs

