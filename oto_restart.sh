#!/bin/bash

cd ~/rl-swarm || exit 1

while true; do
  echo "🔁 Gensyn node başlatılıyor... Zaman: $(date)"
  
  # Ortamı hazırla
  python3 -m venv .venv
  source .venv/bin/activate

  (
    # Başlangıç sorularına otomatik yanıt ver
    printf 'y\na\n0.5\n'

    # 30 saniye sonra temp-data klasörünü kopyala
    sleep 30
    echo "📦 temp-data klasörü kopyalanıyor..."
    rm -rf modal-login/temp-data
    cp -r temp-data modal-login/
    echo "✅ Kopyalama tamamlandı."

    # Ardından 90 saniye bekle, HuggingFace sorusuna 'N' de
    sleep 90
    printf 'N\n'
  ) | ./run_rl_swarm.sh

  echo "❌ Node kapandı. 60 saniye sonra yeniden başlatılacak..."
  sleep 60
done
