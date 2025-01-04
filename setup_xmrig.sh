#!/bin/bash

echo "Обновление системы..."
sudo apt update && sudo apt upgrade -y

echo "Установка необходимых библиотек..."
sudo apt install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y

echo "Настройка Huge Pages..."
grep Huge /proc/meminfo
echo 128 | sudo tee /proc/sys/vm/nr_hugepages
sudo bash -c 'echo "vm.nr_hugepages=128" >> /etc/sysctl.conf'
sudo sysctl -p

echo "Оптимизация CPU..."
sudo apt install cpufrequtils -y
sudo cpufreq-set -g performance

echo "Установка screen..."
sudo apt install screen -y

echo "Создание сеанса screen..."
screen -dmS miner

echo "Клонирование репозитория XMRig..."
git clone https://github.com/xmrig/xmrig.git
cd xmrig

echo "Сборка XMRig..."
mkdir build && cd build
cmake ..
make -j$(nproc)

echo "Проверка версии XMRig..."
./xmrig --version

echo "Обновление ядра..."
sudo apt install --install-recommends linux-generic -y

echo "Перезагрузка сервера для завершения обновлений..."
sudo reboot
