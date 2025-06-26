#!/bin/bash

cd ~/rl-swarm || exit 1

# HATA & CTRL+C yakalama
trap_ctrl_c() {
  echo "🛑 CTRL+C alındı. Tüm süreçler sonlandırılıyor..."
  docker kill $(docker ps -q)
  screen -S gensyn -X quit
  pkill -P $$
  exit
}
trap trap_ctrl_c SIGINT

# yeniden başlatıcı
restart_script() {
  echo "🔁 Node yeniden başlatılıyor..."
  docker kill $(docker ps -q)
  screen -S gensyn -X quit
  sleep 3
  screen -dmS gensyn bash -c 'cd ~/rl-swarm && bash oto_gensyn.sh'
  exit
}

# temiz başlat
echo "🚀 Docker başlatılıyor..."
docker compose run --rm --build swarm-cpu > node_output.log 2>&1 &

NODE_PID=$!

# modal-login klasörü değiştir
sleep 10
echo "📁 modal-login klasörü güncelleniyor..."
rm -rf user/modal-login
cp -r modal-login-1 user/modal-login

# 10 saniye daha bekle, sonra input simülasyonu
sleep 10
echo "n" > /tmp/gensyn_input.txt
echo "" >> /tmp/gensyn_input.txt

# input’u pipe’la gönder
cat /tmp/gensyn_input.txt | docker attach $(docker ps -q --filter "ancestor=swarm-cpu") &

# Log dosyasını izle
echo "📜 Log takip başlıyor..."
SECONDS_WAITED=0
while kill -0 $NODE_PID 2>/dev/null; do
  sleep 5
  ((SECONDS_WAITED+=5))

  if grep -q "Waiting for API key to be activated..." node_output.log && [ $SECONDS_WAITED -ge 30 ]; then
    echo "🚨 API key 30 saniyedir aktifleşmedi."
    restart_script
  fi

  if grep -q "Resource temporarily unavailable" node_output.log || grep -q "EOFError" node_output.log; then
    echo "🚨 Hata logda tespit edildi."
    restart_script
  fi
done

echo "❌ Node durdu. Script yeniden başlatılıyor..."
restart_script
