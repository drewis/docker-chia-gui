#!/usr/bin/with-contenv sh
export HOME=/chia

s6-setuidgid chia chia init
s6-setuidgid chia chia keys add -f ${HOME}/.chia/mnemonic.txt

