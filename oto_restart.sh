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

# 🔁 Her başlatmada yarn screen'i kapat ve yeniden başlat
echo "🧹 Eski yarn screen varsa kapatılıyor..."
screen -S yarn -X quit 2>/dev/null

echo "🚀 Yeni yarn screen başlatılıyor..."
screen -dmS yarn bash -c 'cd ~/rl-swarm/modal-login && fuser -k 3000/tcp; PORT=3000 yarn dev'

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

  # 10 saniye bekle ve log'u sıfırla
  echo "🕓 Dosya tanınması için 10 saniye bekleniyor..."
  sleep 10
  > node_output.log

  # API Key bekleme + Killed kontrolü
  while kill -0 $NODE_PID 2>/dev/null; do
    sleep 10

    COUNT_API_WAIT=$(grep -c "Waiting for API key to be activated..." node_output.log)
    COUNT_KILLED=$(grep -c "Killed                  python -m hivemind_exp.gsm8k.train_single_gpu" node_output.log)

    if [ "$COUNT_API_WAIT" -ge 15 ] || [ "$COUNT_KILLED" -ge 1 ]; then
      echo "🚨 Gensyn node kritik durumda. Yeniden başlatılıyor..."

      echo "🕓 5 saniye bekleniyor (manuel durdurma gibi)..."
      sleep 5

      echo "🛑 Süreçler manuel gibi durduruluyor..."
      pkill -9 -f train_single_gpu.py
      pkill -9 -f p2pd
      pkill -P $NODE_PID
      kill -9 $NODE_PID 2>/dev/null

      echo "🔄 5 saniye sonra kendini yeniden başlatıyor..."
      sleep 5
      curl -s https://raw.githubusercontent.com/DoganSoley/cryptoloss-gensyn/refs/heads/main/oto_restart.sh | bash

      exit
    fi
  done

  echo "❌ Node kapandı. 1 saniye sonra yeniden başlatılıyor... $(date)"
  sleep 1
done
