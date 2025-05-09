
#!/bin/bash

cd ~/rl-swarm || {
  echo "❌ rl-swarm klasörü bulunamadı."; exit 1;
}

# 🟢 Önce modal-login içindeki temp-data'yı geri al
if [ -d "modal-login/temp-data" ]; then
  echo "♻️ Başlangıçta temp-data klasörü geri kopyalanıyor..."
  rm -rf temp-data
  cp -r modal-login/temp-data ./temp-data
  echo "✅ İlk temp-data kopyalama tamamlandı."
else
  echo "⚠️ modal-login/temp-data klasörü bulunamadı, atlanıyor."
fi

# Eğer venv klasörü yoksa oluştur
if [ ! -d ".venv" ]; then
  echo "🚀 Sanal ortam oluşturuluyor (.venv)..."
  python3 -m venv .venv
fi

# venv'i aktive et
source .venv/bin/activate

# 🔁 Sonsuz döngüyle otorestart
while true; do
  echo "🔁 Gensyn node başlatılıyor... Zaman: $(date)"

  (
    # Gerekli cevapları sırayla gönder
    printf 'y\na\n0.5\n'

    # temp-data klasörünü tekrar modal-login'e kopyala
    sleep 30
    echo "📦 temp-data klasörü modal-login içine kopyalanıyor..."
    rm -rf modal-login/temp-data
    cp -r temp-data modal-login/
    echo "✅ Kopyalama tamamlandı."

    # Huggingface sorusuna cevap ver
    sleep 90
    printf 'N\n'
  ) | ./run_rl_swarm.sh

  echo "❌ Node kapandı. 60 saniye sonra yeniden başlatılacak..."
  sleep 60
done
