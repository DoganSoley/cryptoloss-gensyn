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

# Sanal ortamı aktifleştir
source .venv/bin/activate

# modal-login/temp-data klasörünü başta oluştur
mkdir -p modal-login/temp-data

while true; do
  echo "🔁 Gensyn node başlatılıyor: $(date)"

  # Her başlatmada log dosyasını temizle
  > node_output.log

  (
    # 1. Giriş adımları gönder
    printf 'y\na\n0.5\n'

    # 2. userData.json logunu bekle
    echo "⌛ userData.json oluşturulması bekleniyor..."
    while ! grep -q "Waiting for modal userData.json to be created..." node_output.log; do
      sleep 1
    done

    echo "✅ userData logu bulundu, 2 saniye bekleniyor..."
    sleep 2

    # 3. userData.json kopyala
    if cp -f temp-data/userData.json modal-login/temp-data/userData.json; then
      echo "✅ userData.json kopyalandı."
    else
      echo "❌ userData.json kopyalanamadı."
    fi

    # 4. userApiKey.json kopyala (2 saniye sonra)
    sleep 2
    if cp -f temp-data/userApiKey.json modal-login/temp-data/userApiKey.json; then
      echo "✅ userApiKey.json kopyalandı."
    else
      echo "❌ userApiKey.json kopyalanamadı."
    fi

    # 5. Eğitim başlasın
    sleep 1
    printf 'N\n'

  ) | ./run_rl_swarm.sh 2>&1 | tee node_output.log &

  NODE_PID=$!

  # API Key aktivasyonu 15 kez denendi mi kontrol et
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
