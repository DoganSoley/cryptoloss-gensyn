#!/bin/bash

cd ~/rl-swarm || exit 1

# CTRL+C sinyali gelirse tüm alt süreçleri öldür ve çık
trap_ctrl_c() {
  echo "🛑 CTRL+C alındı. Tüm süreçler sonlandırılıyor..."
  pkill -P $$
  kill 0
  exit
}
trap trap_ctrl_c SIGINT

# LOG dosyasını sıfırla
> node_output.log

# Sanal ortamı aktifleştir
source .venv/bin/activate

# modal-login/temp-data klasörünü başta oluştur
mkdir -p modal-login/temp-data

while true; do
  echo "🔁 Gensyn node başlatılıyor: $(date)"

  (
    # 1. Gensyn giriş bilgileri ver
    printf 'y\na\n0.5\n'
    sleep 90

    # 2. userData.json kopyala
    if cp -f temp-data/userData.json modal-login/temp-data/userData.json; then
      echo "✅ userData.json kopyalandı."
    else
      echo "❌ userData.json kopyalanamadı."
    fi

    # 3 saniye bekle
    sleep 3

    # 3. userApiKey.json kopyala
    if cp -f temp-data/userApiKey.json modal-login/temp-data/userApiKey.json; then
      echo "✅ userApiKey.json kopyalandı."
    else
      echo "❌ userApiKey.json kopyalanamadı."
    fi

    # 4. Gensyn'e devam etmek için N gir
    printf 'N\n'
  ) | ./run_rl_swarm.sh 2>&1 | tee node_output.log &

  NODE_PID=$!

  # API key aktivasyon kontrolü
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
