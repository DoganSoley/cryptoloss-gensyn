#!/bin/bash

# gensyn isimli screen aç ve rl-swarm içinde docker compose başlat
screen -S gensyn -dm bash -c "
    cd ~/rl-swarm || exit 1
    docker compose run --rm --build -Pit swarm-cpu
"
