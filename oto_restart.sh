#!/bin/bash

echo "[INFO] gensyn screen başlatılıyor..."

# Daha önce açıksa kapat
screen -X -S gensyn quit

# Ekranda görünmesi için 1 saniye beklet
sleep 1

# gensyn screen aç ve komutları içinde çalıştır
screen -S gensyn -d -m

# komutları screen içine gönder
screen -S gensyn -X stuff "cd ~/rl-swarm && docker compose run --rm --build -Pit swarm-cpu\n"

echo "[INFO] gensyn screen başlatıldı. 'screen -r gensyn' ile logları izleyebilirsin."
