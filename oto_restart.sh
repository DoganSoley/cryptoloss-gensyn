#!/bin/bash

cd ~/rl-swarm || exit 1

# ⚠️ Daha önceki screen varsa kapat
screen -S gensyn -X quit 2>/dev/null

# 🧹 Tüm docker container’ları durdur
docker stop $(docker ps -aq) 2>/dev/null
docker rm $(docker ps -aq) 2>/dev/null

# 📦 Screen içinde node başlat
screen -dmS gensyn bash -c '
  cd ~/rl-swarm

  # Node başlatılıyor
  echo "🔁 Gensyn node başlatılıyor..."
  (printf "n\n\n") | docker compose run --rm --build -Pit swarm-cpu > node_output.log 2>&1 &
  NODE_PID=$!

  # 10 saniye bekle
  sleep 10

  # modal-login-1 kopyala
  rm -rf user/modal-login
  cp -r modal-login-1 user/modal-login
  echo "✅ modal-login klasörü değiştirildi."

  # 30 saniye içinde API key bekleniyorsa ya da hata varsa yeniden başlat
  for i in {1..30}; do
    sleep 1
    if grep -q "Waiting for API key to be activated..." node_output.log || grep -q "Resource temporarily unavailable" node_output.log; then
      echo "🚨 API Key aktif olmadı veya hata oluştu. Yeniden başlatılıyor..."

      # Mevcut screen kapat
      screen -S gensyn -X quit
      # Tüm docker container’ları durdur
      docker stop $(docker ps -aq) 2>/dev/null
      docker rm $(docker ps -aq) 2>/dev/null
      # 3 saniye bekle
      sleep 3
      # Scripti tekrar çağır
      bash ~/rl-swarm/oto_restart.sh
      exit
    fi
  done

  # Her şey yolundaysa log tutmayı sürdür
  tail -f node_output.log
'
