#!/bin/bash

cd ~/rl-swarm || exit 1

# 🐳 Node'u çalıştır
docker compose run --rm --build -Pit swarm-cpu &

# 10 saniye bekle
sleep 10

# 🔁 modal-login-1 → user/modal-login olarak kopyala
rm -rf user/modal-login
cp -r modal-login-1 user/modal-login

echo "✅ modal-login başarıyla değiştirildi."
