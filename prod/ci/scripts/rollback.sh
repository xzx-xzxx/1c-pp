#!/usr/bin/env bash
# Откат прод-ИБ из последнего бэкапа. rollback.sh [путь_к_.dt]. Не запускалось.
set -euo pipefail
: "${PROD_IB:?}"; : "${BACKUP_DIR:?}"
BK="${1:-$(cat "$BACKUP_DIR/last-backup.txt")}"
[ -s "$BK" ] || { echo "Нет бэкапа $BK"; exit 1; }
vrunner restore --dt "$BK" --ibconnection "/F$PROD_IB"
echo "Откат выполнен из $BK"
