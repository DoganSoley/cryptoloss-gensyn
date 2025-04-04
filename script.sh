#!/bin/bash

# Gensyn Node Kurulum Scripti
# Hazırlayan: Cryptoloss

echo "📦 Sunucu güncelleniyor..."
sudo apt update && sudo apt install -y sudo

echo "🔧 Gerekli paketler kuruluyor..."
sudo apt update && sudo apt install -y \
  python3 python3-venv python3-pip curl wget screen git lsof

echo "📦 Yarn kuruluyor..."
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

echo "📦 Modal-login bağımlılıkları yükleniyor..."
cd modal-login
yarn install
yarn upgrade
yarn add next@latest
yarn add viem@latest

echo "🚀 Python sanal ortamı başlatılıyor ve node ayağa kaldırılıyor..."
cd $HOME/rl-swarm
screen -dmS gensyn bash -c "python3 -m venv .venv && . .venv/bin/activate && ./run_rl_swarm.sh"

echo "✅ Gensyn node kurulumu tamamlandı!"
echo "⛓ Screen oturumuna bağlanmak için: screen -r gensyn"
