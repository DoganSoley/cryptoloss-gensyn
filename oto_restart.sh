#!/bin/bash

cd ~/rl-swarm || exit 1

# Süreç kontrolü: CTRL+C ile durdurunca her şeyi kapat
trap_ctrl_c() {
  echo "🛑 CTRL+C alındı. Çıkılıyor..."
  docker ps -q | xargs -r docker stop
  screen -S gensyn -X quit
  pkill -9 -f docker
  exit 0
}
trap trap_ctrl_c SIGINT

# 🔄 10 saniye sonra modal-login-1 klasörünü modal-login olarak taşı
replace_modal_login() {
  sleep 10
  echo "♻️ modal-login-1 -> user/modal-login kopyalanıyor..."
  rm -rf ~/rl-swarm/user/modal-login
  cp -r ~/rl-swarm/modal-login-1 ~/rl-swarm/user/modal-login
  echo "✅ modal-login klasörü güncellendi."
}

# 💣 Hata tespiti: API key beklemesi ya da [Errno 11] varsa yeniden başlat
monitor_errors() {
  local seconds_waited=0
  while [ $seconds_waited -lt 300 ]; do
    if grep -q "Waiting for API key to be activated" node_output.log; then
      ((seconds_waited+=10))
      sleep 10
    else
      break
    fi
  done

  if [ $seconds_waited -ge 30 ] || grep -q "Resource temporarily unavailable" node_output.log; then
    echo "🚨 Hata tespit edildi. Node yeniden başlatılıyor..."
    docker ps -q | xargs -r docker stop
    screen -S gensyn -X quit
    pkill -9 -f docker
    sleep 5
    screen -dmS gensyn bash -c "cd ~/rl-swarm && ./gensyn_start.sh"
    exit 0
  fi
}

# Ana işlem
echo "🚀 Gensyn node başlatılıyor..."
replace_modal_login &

# Scripti başlatıp cevapları otomatik ver
(
  echo "n"
  sleep 1
  echo ""
) | docker compose run --rm --build -Pit swarm-cpu 2>&1 | tee node_output.log &

# Log dosyasını takip ederek hata kontrolü yap
monitor_errors
