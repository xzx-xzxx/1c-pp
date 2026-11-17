#!/usr/bin/env bash
# Обновление тестового контура после merge в release/*. Не запускалось.
set -euo pipefail
IB="${TEST_STAND_IB:?путь или строка тестового контура}"
CF=$(ls build/*.cf | head -1)
vrunner load --src "$CF" --ibconnection "/F$IB"
vrunner updatedb --ibconnection "/F$IB"
echo "Тестовый контур обновлён: $CF"
