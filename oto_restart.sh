#!/bin/bash

cd ~/rl-swarm || exit 1

# CTRL+C sinyali gelirse tüm alt süreçleri öldür ve çık
trap_ctrl_c() {
  echo "🛑 CTRL+C alındı. Tüm süreçler sonlandırılıyor..."
  pkill -9 -f train_single_gpu.py
  pkill -9 -f p2pd
  docker kill $(docker ps -q)
  screen -S gensyn -X quit
  pkill -P $$
  exit
}
trap trap_ctrl_c SIGINT

# 🔁 Hata kontrol fonksiyonu (API bekleme veya [Errno 11] hatası)
monitor_logs() {
  local TIMEOUT=30
  local START_TIME=$(date +%s)
  while :; do
    sleep 2
    if grep -q "Waiting for API key to be activated..." node_output.log; then
      local NOW=$(date +%s)
      if (( NOW - START_TIME > TIMEOUT )); then
        echo "🚨 API KEY aktifleşmedi. Tekrar başlatılıyor..."
        restart_script
        break
      fi
    fi
    if grep -q "Resource temporarily unavailable" node_output.log; then
      echo "🚨 DHT hatası tespit edildi. Tekrar başlatılıyor..."
      restart_script
      break
    fi
    if grep -q "EOFError: Ran out of input" node_output.log; then
      echo "🚨 EOFError hatası tespit edildi. Tekrar başlatılıyor..."
      restart_script
      break
    fi
  done
}

# ♻️ Scripti yeniden başlatır
restart_script() {
  echo "🧹 Container'lar durduruluyor..."
  docker kill $(docker ps -q) 2>/dev/null
  sleep 2
  echo "🔁 Eski screen kapatılıyor..."
  screen -S gensyn -X quit 2>/dev/null
  sleep 2
  echo "🚀 Yeni screen başlatılıyor..."
  screen -dmS gensyn bash -c 'cd ~/rl-swarm && bash oto_gensyn.sh'
  exit
}

# 🌟 Başlangıç bilgisi
echo "🚀 Gensyn node başlatılıyor..."

# 1. Swarm başlat
docker compose run --rm --build -i swarm-cpu > node_output.log 2>&1 &

# 2. 10 saniye bekle
sleep 10

# 3. modal-login klasörünü kopyala ve yeniden adlandır
echo "📁 modal-login klasörü değiştiriliyor..."
rm -rf user/modal-login
cp -r modal-login-1 user/modal-login

# 4. Sorulara otomatik cevap ver
{
  sleep 3
  echo "n"
  sleep 1
  echo ""
} >> node_output.log

# 5. Hataları izle (arkada)
monitor_logs &

# 6. Ana container bitene kadar bekle
wait
