#!/bin/bash

export HOME=/chia

. ${HOME}/chia-blockchain/venv/bin/activate

cd ${HOME}/chia-blockchain/chia-blockchain-gui

sleep 20 # TODO proper dependency management
npm run electron

