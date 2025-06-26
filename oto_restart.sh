#!/bin/bash

set -e

cd ~/rl-swarm || exit 1

LOGFILE="node_output.log"
SCREEN_NAME="gensyn"

trap_ctrl_c() {
  echo "🛑 CTRL+C alındı. Kapatılıyor..."
  screen -S $SCREEN_NAME -X quit
  docker stop $(docker ps -q)
  exit
}
trap trap_ctrl_c SIGINT

start_node() {
  echo "🧹 Eski screen ve containerlar kapatılıyor..."
  screen -S $SCREEN_NAME -X quit 2>/dev/null || true
  docker stop $(docker ps -q) 2>/dev/null || true

  echo "🧪 Yeni screen başlatılıyor: $SCREEN_NAME"
  screen -dmS $SCREEN_NAME bash -c '
    cd ~/rl-swarm || exit 1

    echo "📦 modal-login-1 klasörü user dizinine taşınıyor..."
    rm -rf user/modal-login
    cp -r modal-login-1 user/modal-login
    echo "✅ modal-login güncellendi."

    echo "🐳 RL Swarm başlatılıyor..."
    docker compose run --rm --build -Pit swarm-cpu 2>&1 | tee node_output.log &
    DOCKER_PID=$!

    sleep 5

    echo "✉️ Promptlara otomatik cevap veriliyor..."
    {
      echo "n"   # huggingface'e push yok
      sleep 2
      echo ""    # default model
    } | while read line; do
      echo "$line"
      sleep 1
    done

    for i in {1..6}; do
      sleep 5
      if grep -q "Waiting for API key to be activated..." node_output.log; then
        echo "⌛ API key bekleniyor... ($i)"
      else
        break
      fi
      if [ "$i" -eq 6 ]; then
        echo "⏱️ API key bekleme 30 saniyeyi aştı, yeniden başlatılıyor..."
        docker stop $(docker ps -q)
        screen -S gensyn -X quit
        exec bash "$0"
      fi
    done

    while sleep 5; do
      if grep -q "Resource temporarily unavailable" node_output.log; then
        echo "🚨 Hata tespit edildi: Resource temporarily unavailable"
        docker stop $(docker ps -q)
        screen -S gensyn -X quit
        exec bash "$0"
      fi
    done
  '
}

start_node
