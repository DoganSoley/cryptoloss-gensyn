#!/bin/bash

cd ~/rl-swarm || exit 1

# CTRL+C sinyali gelirse her şeyi öldür
trap_ctrl_c() {
  echo "🛑 CTRL+C alındı. Tüm süreçler sonlandırılıyor..."
  screen -S gensyn -X quit 2>/dev/null
  docker ps -q | xargs -r docker stop
  pkill -P $$
  kill 0
  exit
}
trap trap_ctrl_c SIGINT

while true; do
  echo "🧹 Eski 'gensyn' screen varsa kapatılıyor..."
  screen -S gensyn -X quit 2>/dev/null

  echo "🚀 Yeni 'gensyn' screen başlatılıyor..."
  screen -dmS gensyn bash -c '
    cd ~/rl-swarm

    # RL Swarm başlatılıyor
    docker compose run --build -Pit swarm-cpu 2>&1 | tee node_output.log &
    DOCKER_PID=$!

    # Log dosyasının oluşmasını bekle (maks. 10 saniye)
    for i in {1..10}; do
      if [ -f node_output.log ]; then
        echo "📄 node_output.log bulundu."
        break
      fi
      echo "⌛ Log dosyası bekleniyor... ($i saniye)"
      sleep 1
    done

    # 10 saniye sonra modal-login klasörünü kopyala
    sleep 10
    rm -rf ~/rl-swarm/user/modal-login
    cp -r ~/rl-swarm/modal-login-1 ~/rl-swarm/user/modal-login
    echo "✅ modal-login klasörü başarıyla değiştirildi."

    # Otomatik cevaplar: n, Enter
    {
      sleep 1
      echo "n"
      sleep 1
      echo ""
    } | tee -a node_output.log

    # Aktivasyon kontrolü (maksimum 30 saniye bekle)
    echo "🔍 API anahtar aktivasyonu bekleniyor..."
    for i in {1..30}; do
      if grep -q "Waiting for API key to be activated..." node_output.log; then
        sleep 1
      else
        echo "✅ Aktivasyon kontrolü tamamlandı."
        exit 0
      fi
    done

    echo "🚨 API anahtarı aktifleşmedi. Her şey yeniden başlatılıyor..."

    # Tüm süreçleri kapat
    docker ps -q | xargs -r docker stop
    screen -S gensyn -X quit 2>/dev/null
    sleep 2

    # Scripti yeniden başlat
    bash ~/rl-swarm/gensyn_launcher.sh
  '

  # Ana döngü: eğer screen kapanırsa, tekrar başlatılır
  echo "🔁 Screen döngüsü tamamlandı. 3 saniye sonra yeniden denenecek..."
  sleep 3
done
