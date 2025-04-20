#!/bin/bash

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 8. CRYPTOLOSS
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

echo "📦 Sunucu güncelleniyor..."
sudo apt update && sudo apt install -y sudo

echo "🔧 Gerekli paketler kuruluyor..."
sudo apt update && sudo apt install -y \
  python3 python3-venv python3-pip curl wget screen git lsof
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

echo "🚀 Gensyn script başlatılıyor..."
curl -sSL https://raw.githubusercontent.com/zunxbt/installation/main/node.sh | bash

echo "📁 Repo klonlanıyor..."
cd $HOME
[ -d rl-swarm ] && rm -rf rl-swarm
git clone https://github.com/zunxbt/rl-swarm.git
cd rl-swarm

echo "🛠️ Orijinal hivemind_exp klasörü güncelleniyor..."
rm -rf hivemind_exp
git clone --depth 1 https://github.com/gensyn-ai/rl-swarm.git temp-gensyn
cp -r temp-gensyn/hivemind_exp .
rm -rf temp-gensyn

echo "📦 Yarn güncelleniyor..."
cd modal-login
yarn install
yarn upgrade
yarn add next@latest
yarn add viem@latest

echo "🚀 Node kuruluyor..."
cd $HOME/rl-swarm
screen -dmS gensyn bash -c "python3 -m venv .venv && . .venv/bin/activate && ./run_rl_swarm.sh"

echo -e "${GREEN}CC : ZUNXBT ${NC}"

echo "İşlem tamamlandı."

# 8. CRYPTOLOSS
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
echo -e "${GREEN}#### Twitter : @Cryptoloss1 #####${NC}"
echo " "
echo -e "${GREEN}Gensyn Node kurulumu tamamlandı.${NC}"
echo " "
echo -e "${GREEN}Sorularınız için ${NC}""${YELLOW}t.me/CryptolossChat${NC}""${GREEN} telegram kanalına gelebilirsiniz.${NC}"
echo " "
echo -e "${GREEN}Node çalıştırmak için : ${NC}""${YELLOW}screen -r gensyn${NC}"
