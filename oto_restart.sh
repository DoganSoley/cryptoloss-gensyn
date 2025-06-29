#!/bin/bash

while true; do
    echo "[INFO] Starting Gensyn node inside screen..."

    # Eski screen varsa kapat
    screen -X -S gensyn kill

    # Docker container'ları durdur
    docker kill $(docker ps -q) 2>/dev/null
    docker rm $(docker ps -aq) 2>/dev/null

    # Gensyn screen başlat
    screen -dmS gensyn bash -c "
        cd ~/rl-swarm

        # Nodeyi başlat, otomatik input vermek için printf kullan
        printf 'n\n\n' | docker compose run --rm --build -Pit swarm-cpu &

        # modal-login-1 içeriğini modal-login içine kopyala
        echo '[INFO] Waiting for modal-login-1 to appear...'
        while [ ! -d 'modal-login-1' ]; do
            sleep 2
        done

        echo '[INFO] Copying modal-login-1 contents into user/modal-login...'
        cp -r modal-login-1/* user/modal-login/

        # Sonsuz bekle, screen logları akar
        tail -f /dev/null
    "

    echo "[INFO] Gensyn node stopped or crashed. Restarting in 5 seconds..."
    sleep 5
done
