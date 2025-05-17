#!/bin/bash

cd ~/rl-swarm || exit 1

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

    # Klasörü kontrol et (yoksa oluştur)
    mkdir -p modal-login/temp-data

    # userData.json kopyala
    if cp -f temp-data/userData.json modal-login/temp-data/userData.json; then
      echo "✅ userData.json kopyalandı."
    else
      echo "❌ userData.json kopyalanamadı."
    fi

    # 3 saniye bekle
    sleep 3

    # userApiKey.json kopyala
    if cp -f temp-data/userApiKey.json modal-login/temp-data/userApiKey.json; then
      echo "✅ userApiKey.json kopyalandı."
    else
      echo "❌ userApiKey.json kopyalanamadı."
    fi

    # Bitirme için input gönder
    printf 'N\n'
  ) | ./run_rl_swarm.sh 2>&1 | tee node_output.log &

  NODE_PID=$!

  # API Key bekleme kontrolü
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

  echo "❌ Node kapandı. Bekleniyor... $(date)"
  sleep 5
done
