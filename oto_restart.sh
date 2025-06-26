#!/bin/bash

cd ~/rl-swarm || exit 1

# CTRL+C sinyali gelirse tüm süreçleri öldür
trap_ctrl_c() {
  echo "🛑 CTRL+C alındı. Tüm süreçler sonlandırılıyor..."
  screen -S gensyn -X quit 2>/dev/null
  docker kill $(docker ps -q) 2>/dev/null
  pkill -P $$
  kill 0
  exit
}
trap trap_ctrl_c SIGINT

# 🔁 Eski gensyn screen'i kapat
echo "🧹 Eski gensyn screen varsa kapatılıyor..."
screen -S gensyn -X quit 2>/dev/null

# 🧠 modal-login-1 klasörünü user altına kopyala (isim değiştirerek)
echo "📁 modal-login klasörü yenileniyor..."
rm -rf user/modal-login
cp -r modal-login-1 user/modal-login

# 🚀 Yeni gensyn screen başlatılıyor...
screen -dmS gensyn bash -c '
cd ~/rl-swarm || exit 1
source .venv/bin/activate

touch node_output.log  # Dosya yok hatasını engeller

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

  stuck_check=0
  while kill -0 $NODE_PID 2>/dev/null; do
    sleep 5

    if [[ -f node_output.log ]] && grep -q "Waiting for API key to be activated..." node_output.log; then
      stuck_check=$((stuck_check + 1))
    else
      stuck_check=0
    fi

    if [ "$stuck_check" -ge 6 ]; then
      echo "⚠️ API key aktivasyonu tıkandı. Yeniden başlatılıyor..."
      docker kill $(docker ps -q) 2>/dev/null
      kill -9 $NODE_PID
      break
    fi
  done

  echo "🔁 Node durdu. 2 saniye sonra yeniden başlatılıyor..."
  sleep 2
done
'
