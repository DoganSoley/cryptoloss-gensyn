#!/bin/bash

cd ~/rl-swarm || exit 1

trap_ctrl_c() {
  echo "🛑 CTRL+C alındı. Tüm süreçler sonlandırılıyor..."
  pkill -P $$
  kill 0
  exit
}
trap trap_ctrl_c SIGINT

> node_output.log
source .venv/bin/activate

mkdir -p modal-login/temp-data

while true; do
  echo "🔁 Gensyn node başlatılıyor: $(date)"

  (
    # 1. Giriş adımları
    printf 'y\na\n0.5\n'

    # 2. Logta userData mesajını bekle
    echo "⌛ userData.json oluşturulması bekleniyor..."

    while ! grep -q "Waiting for modal userData.json to be created..." node_output.log; do
      sleep 1
    done

    echo "✅ userData logu bulundu, dosya kopyalamaya geçiliyor..."

    # 3. Dosyaları sırayla kopyala
    if cp -f temp-data/userData.json modal-login/temp-data/userData.json; then
      echo "✅ userData.json kopyalandı."
    else
      echo "❌ userData.json kopyalanamadı."
    fi

    sleep 2

    if cp -f temp-data/userApiKey.json modal-login/temp-data/userApiKey.json; then
      echo "✅ userApiKey.json kopyalandı."
    else
      echo "❌ userApiKey.json kopyalanamadı."
    fi

    sleep 1
    printf 'N\n'

  ) | ./run_rl_swarm.sh 2>&1 | tee node_output.log &

  NODE_PID=$!

  while kill -0 $NODE_PID 2>/dev/null; do
    sleep 10
    COUNT=$(grep -c "Waiting for API key to be activated..." node_output.log)

    if [ "$COUNT" -ge 15 ]; then
      echo "🚨 API key aktivasyonu 15+ kez denendi. Node yeniden başlatılıyor..."
      kill $NODE_PID
      wait $NODE_PID 2>/dev/null
      break
    fi
  done

  echo "❌ Node kapandı. 5 saniye sonra yeniden başlatılıyor... $(date)"
  sleep 5
done
