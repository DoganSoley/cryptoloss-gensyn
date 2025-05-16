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

#!/bin/bash

echo "🚀 Gensyn Node Kurulumu Başlıyor..."

# 1. Sunucuyu güncelle
sudo apt update -y && sudo apt upgrade -y

# 2. Gerekli paketleri kur
sudo apt install htop ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev tmux iptables curl nvme-cli git wget make jq libleveldb-dev build-essential pkg-config ncdu tar clang bsdmainutils lsb-release libssl-dev libreadline-dev libffi-dev jq gcc screen file unzip lz4 -y

# 3. NVM kur (Node ve npm için)
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

# NVM'i tanıt
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.profile
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.profile
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bash_profile
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bash_profile

# Yeni terminalde geçerli olması için hemen içeri aktar
source ~/.bashrc

# 4. Node.js LTS kur
nvm install --lts

# 5. Python + Yarn kur
sudo apt update && sudo apt install -y python3 python3-venv python3-pip git yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

# 6. RL Swarm repo'yu klonla
git clone https://github.com/gensyn-ai/rl-swarm.git && cd rl-swarm

# 📁 Dosya güncellemeleri
curl -L https://raw.githubusercontent.com/DoganSoley/cryptoloss-gensyn/refs/heads/main/page.tsx -o modal-login/app/page.tsx
curl -L https://raw.githubusercontent.com/DoganSoley/cryptoloss-gensyn/refs/heads/main/grpo_runner.py -o hivemind_exp/runner/grpo_runner.py

# 7. modal-login içinde güncellemeleri yap
cd modal-login
yarn upgrade
yarn add next@latest
yarn add viem@latest
cd ..

# 8. localtunnel kur
npm install -g localtunnel

# 9. Tunnel screen oluştur ve çalıştır
screen -dmS tunnel lt --port 3000

# 10. Gensyn screen oluştur ve çalıştır
screen -dmS gensyn bash -c "python3 -m venv .venv && source .venv/bin/activate && ./run_rl_swarm.sh"

echo "✅ Kurulum tamamlandı."


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
echo -e "${GREEN}Node kuruluma devam etmek için : ${NC}""${YELLOW}screen -r gensyn${NC}"
echo -e "${GREEN}Mail ile kayıt olmak için : ${NC}""${YELLOW}screen -r tunnel${NC}"
