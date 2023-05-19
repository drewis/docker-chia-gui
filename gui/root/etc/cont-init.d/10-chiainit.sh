#!/usr/bin/with-contenv sh
export HOME=/chia

s6-setuidgid chia chia init --fix-ssl-permissions
s6-setuidgid chia chia keys add -f ${HOME}/.chia/mnemonic.txt -l ""

