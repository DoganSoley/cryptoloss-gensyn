#!/bin/bash

rm -f ~/rl-swarm/node_output.log

cd ~/rl-swarm || exit 1

# CTRL+C yakala ve tüm child process'leri öldür
trap_ctrl_c() {
  echo "🛑 CTRL+C alındı. Tüm süreçler sonlandırılıyor..."
  pkill -P $$
  kill 0
  exit
}
trap trap_ctrl_c SIGINT

source .venv/bin/activate
mkdir -p modal-login/temp-data

while true; do
  echo "🔁 Gensyn node başlatılıyor: $(date)"
  > node_output.log

  # Başlat ve logu ayrı bir thread’de takip et
  {
    ./run_rl_swarm.sh 2>&1 | tee node_output.log
  } &
  NODE_PID=$!

  (
    echo "y"
    sleep 1
    echo "a"
    sleep 1
    echo "0.5"
  ) | tee >(cat >&1) > >(cat > input_pipe.txt) > /proc/$NODE_PID/fd/0 &

  # userData.json mesajı bekleniyor
  echo "⌛ Logta modal userData.json mesajı bekleniyor..."
  while ! grep -q "Waiting for modal userData.json to be created..." node_output.log; do
    sleep 1
  done

  echo "✅ Mesaj bulundu, 2 saniye bekleniyor..."
  sleep 2

  # Dosyalar gerçekten var mı kontrol et → sonra sırayla kopyala
  for FILE in userData.json userApiKey.json; do
    while [ ! -f "temp-data/$FILE" ]; do
      echo "⏳ temp-data/$FILE henüz yok, bekleniyor..."
      sleep 1
    done

    cp -f "temp-data/$FILE" "modal-login/temp-data/$FILE" && echo "✅ $FILE kopyalandı." || echo "❌ $FILE kopyalanamadı."
    sleep 1
  done

  # Son olarak N gönder
  echo "N" > /proc/$NODE_PID/fd/0

  # API key bekleme sayaçlı kontrol (yalnızca yeni satırlar için)
  ACTIVATION_COUNT=0
  tail -n 0 -F node_output.log | while read -r line; do
    if echo "$line" | grep -q "Waiting for API key to be activated..."; then
      ACTIVATION_COUNT=$((ACTIVATION_COUNT + 1))
      echo "🔄 API aktivasyon sayısı: $ACTIVATION_COUNT"
    fi

    if [ "$ACTIVATION_COUNT" -ge 15 ]; then
      echo "🚨 15+ kez denendi. Node restart ediliyor..."
      kill $NODE_PID
      break
    fi

    if ! kill -0 $NODE_PID 2>/dev/null; then
      break
    fi
  done

  echo "❌ Node kapandı. 5 saniye sonra yeniden başlatılıyor... $(date)"
  sleep 5
done
