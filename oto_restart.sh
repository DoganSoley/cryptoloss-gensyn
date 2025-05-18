#!/bin/bash

cd ~/rl-swarm || exit 1

# CTRL+C sinyali gelirse tüm alt süreçleri öldür ve çık
trap_ctrl_c() {
  echo "🛑 CTRL+C alındı. Tüm süreçler sonlandırılıyor..."
  pkill -9 -f train_single_gpu.py
  pkill -9 -f p2pd
  pkill -P $$
  sleep 2
  kill 0
  exit
}
trap trap_ctrl_c SIGINT

# modal-login/temp-data klasörü yoksa oluştur
mkdir -p modal-login/temp-data

# LOG dosyasını sıfırla
> node_output.log

# Sanal ortamı aktifleştir
source .venv/bin/activate

while true; do
  echo "🔁 Gensyn node başlatılıyor: $(date)"

  # run_rl_swarm.sh çalıştırılır, çıktılar log dosyasına aktarılır
  (
    printf 'y\na\n0.5\n'
    sleep 90
    printf 'N\n'
  ) | ./run_rl_swarm.sh 2>&1 | tee node_output.log &

  NODE_PID=$!

  # 15 saniye bekle, sonra userData.json kopyala
  sleep 15
  if cp -f temp-data/userData.json modal-login/temp-data/userData.json; then
    echo "✅ userData.json kopyalandı."
  else
    echo "❌ userData.json kopyalanamadı."
  fi

  # 20 saniye daha bekle, sonra userApiKey.json kopyala
  sleep 20
  if cp -f temp-data/userApiKey.json modal-login/temp-data/userApiKey.json; then
    echo "✅ userApiKey.json kopyalandı."
  else
    echo "❌ userApiKey.json kopyalanamadı."
  fi

  # API Key bekleme kontrolü
  while kill -0 $NODE_PID 2>/dev/null; do
    sleep 10

    COUNT=$(grep -c "Waiting for API key to be activated..." node_output.log)

    if [ "$COUNT" -ge 15 ]; then
      echo "🚨 API key aktivasyonu 15+ kez denendi."

      # Tüm süreçleri anında öldür
      pkill -9 -f train_single_gpu.py
      pkill -9 -f p2pd
      pkill -P $NODE_PID
      kill -9 $NODE_PID 2>/dev/null

      # 1 saniye sonra kendini yeniden başlat
      echo "🔄 Node kendini yeniden başlatıyor..."
      (sleep 1 && curl -s https://raw.githubusercontent.com/DoganSoley/cryptoloss-gensyn/refs/heads/main/oto_restart.sh | bash) &

      exit
    fi
  done

  echo "❌ Node kapandı. 1 saniye sonra yeniden başlatılıyor... $(date)"
  sleep 1
done
