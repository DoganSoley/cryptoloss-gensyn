#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo " "
echo " "
echo " "
echo -e "${BLUE} ######  ########  ##    ## ########  ########  #######  ##        #######   ######   ######${NC}"
echo -e "${BLUE}##    ## ##     ##  ##  ##  ##     ##    ##    ##     ## ##       ##     ## ##    ## ##    ##${NC}"
echo -e "${BLUE}##       ##     ##   ####   ##     ##    ##    ##     ## ##       ##     ## ##       ##${NC}"
echo -e "${BLUE}##       ########     ##    ########     ##    ##     ## ##       ##     ##  ######   ######${NC}"
echo -e "${BLUE}##       ##   ##      ##    ##           ##    ##     ## ##       ##     ##       ##       ##${NC}"
echo -e "${BLUE}##    ## ##    ##     ##    ##           ##    ##     ## ##       ##     ## ##    ## ##    ##${NC}"
echo -e "${BLUE} ######  ##     ##    ##    ##           ##     #######  ########  #######   ######   ######${NC}"
echo " "
echo " "
echo " "
echo " "

#!/bin/bash

echo "🚀 Gensyn Node Güncelleniyor.."

# 🛑 Önce varsa çalışan "gensyn" screen oturumunu kapat
echo "🛑 Var olan 'gensyn' screen oturumu kapatılıyor (eğer varsa)..."
screen -S gensyn -X quit 2>/dev/null

# 🔁 rl-swarm klasörüne gir
if [ ! -d "rl-swarm" ]; then
  echo "❌ 'rl-swarm' klasörü bulunamadı. Bu script rl-swarm üst klasöründen çalıştırılmalı."
  exit 1
fi

echo "📁 rl-swarm klasörüne giriliyor..."
cd rl-swarm || exit 1

# 💣 Yerel değişiklikleri sil ve temizle
echo "⚠️ Tüm yerel değişiklikler siliniyor..."
git reset --hard HEAD

echo "🧹 Takip edilmeyen dosya ve klasörler temizleniyor..."
git clean -fd

# ⬇️ En güncel kodu çek
echo "⬇️ En güncel kod çekiliyor..."
git pull

cd ..
screen -dmS gensyn bash -c 'cd rl-swarm && exec bash'
echo " "
echo "✅ Güncelleme tamamlandı!"
echo " "
echo "✅ screen -r gensyn ile screen'e girip nodeyi tekrar çalıştırın."
echo " "
echo -e "${GREEN}Sorularınız için ${NC}""${YELLOW}t.me/CryptolossChat${NC}""${GREEN} telegram kanalına gelebilirsiniz.${NC}"
echo " "
