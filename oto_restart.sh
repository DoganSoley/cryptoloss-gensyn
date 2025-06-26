#!/bin/bash

cd ~/rl-swarm || exit 1

# Swarm başlamadan önce modal-login klasörünü güncelle
rm -rf user/modal-login
cp -r modal-login-1 user/modal-login

# Log dosyasını sıfırla (önceden oluştur ki grep hatası vermesin)
touch node_output.log

# Önceki screen ve docker'ları kapat
screen -S gensyn -X quit 2>/dev/null
docker kill $(docker ps -q) 2>/dev/null

# Gensyn screen başlat
screen -dmS gensyn bash -c '
  cd ~/rl-swarm || exit 1
  touch node_output.log

  while true; do
    echo "🔁 Gensyn node başlatılıyor: $(date)"

    (
      sleep 10
      cp -rf modal-login-1 user/modal-login
      printf "n\n"
      sleep 1
      printf "\n"
    ) | docker compose run --rm --build -Pit swarm-cpu 2>&1 | tee node_output.log &

    NODE_PID=$!

    sleep 30

    for i in {1..6}; do
      sleep 5
      if grep -q "Waiting for API key to be activated..." node_output.log; then
        echo "❌ Tıkandı, yeniden başlatılıyor..."
        docker kill $(docker ps -q) 2>/dev/null
        kill -9 $NODE_PID
        break
      fi
    done

    echo "🔄 Yeniden deneme başlıyor..."
    sleep 3
  done
'
