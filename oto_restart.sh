#!/bin/bash

while true; do
    echo "[INFO] Gensyn screen hazırlanıyor..."

    # Eğer daha önce bir 'gensyn' screen açıksa öldür
    if screen -list | grep -q "gensyn"; then
        echo "[INFO] Eski gensyn screen kapatılıyor..."
        screen -X -S gensyn quit
        sleep 2
    fi

    echo "[INFO] Gensyn screen başlatılıyor..."

    # Screen içinde çalıştırılacak komutları hazırlıyoruz
    screen -dmS gensyn bash -c "
        cd ~/rl-swarm || exit 1

        echo '[INFO] Node başlatılıyor...'
        printf 'n\n\n' | docker compose run --rm --build -Pit swarm-cpu

        echo '[INFO] modal-login-1 klasörü bekleniyor...'
        while [ ! -d 'modal-login-1' ]; do
            sleep 2
        done

        echo '[INFO] modal-login-1 içeriği user/modal-login klasörüne kopyalanıyor...'
        cp -r modal-login-1/* user/modal-login/

        echo '[INFO] Node tamamlandı veya kapandı. Çıkılıyor...'
    "

    # Node kapandığında docker container'ları temizle
    sleep 5
    docker kill $(docker ps -q) 2>/dev/null
    docker rm $(docker ps -aq) 2>/dev/null

    echo "[INFO] 10 saniye sonra yeniden başlatılacak..."
    sleep 10
done
