#!/usr/bin/env bash
# Прод: manual job. Бэкап ИБ → обновление → проверка → при сбое откат. Не запускалось.
# Переменные CI (protected): PROD_IB, BACKUP_DIR, CONFIRM_TOKEN. Защита от случайного запуска: нужно CONFIRM=yes.
set -euo pipefail
: "${PROD_IB:?}"; : "${BACKUP_DIR:?}"
[ "${CONFIRM:-}" = "yes" ] || { echo "Задайте CONFIRM=yes в запуске manual job"; exit 1; }
CF=$(ls build/*.cf | head -1); TS=$(date +%Y%m%d-%H%M%S)
mkdir -p "$BACKUP_DIR"; BK="$BACKUP_DIR/prod-$TS.dt"
vrunner dump --dt "$BK" --ibconnection "/F$PROD_IB"
[ -s "$BK" ] || { echo "Бэкап пуст, прерываем"; exit 1; }
echo "$BK" > "$BACKUP_DIR/last-backup.txt"
if ! { vrunner load --src "$CF" --ibconnection "/F$PROD_IB" && vrunner updatedb --ibconnection "/F$PROD_IB"; }; then
  echo "Сбой обновления, откат"; "$(dirname "$0")/rollback.sh"; exit 1
fi
# TODO(проверка): смоук-тест после обновления (vrunner xunit по набору tests/smoke) — не реализовано
echo "Прод обновлён, бэкап: $BK"
