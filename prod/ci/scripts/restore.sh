#!/usr/bin/env bash
# Восстановление: restore.sh <метка>   (метка из backup.sh). Останавливает записывающие сервисы, восстанавливает, перезапускает.
set -euo pipefail
TS="${1:?Использование: restore.sh <метка YYYYMMDD-HHMMSS>}"
cd "$(dirname "$0")/../../docker"
DEST="${BACKUP_DIR:-../backups}"
read -r -p "Восстановить GitLab и Sonar из метки $TS? Текущие данные будут перезаписаны [yes/N] " a; [ "$a" = yes ] || exit 1
docker compose exec -T gitlab gitlab-ctl stop puma
docker compose exec -T gitlab gitlab-ctl stop sidekiq
docker compose exec -T gitlab gitlab-backup restore BACKUP="$TS" force=yes
docker compose cp "$DEST/gitlab/gitlab-secrets-$TS.json" gitlab:/etc/gitlab/gitlab-secrets.json
docker compose restart gitlab
docker compose stop sonarqube
docker compose exec -T sonar-db psql -U sonar -d postgres -c "DROP DATABASE IF EXISTS sonar" -c "CREATE DATABASE sonar OWNER sonar"
gunzip -c "$DEST/sonar/sonar-$TS.sql.gz" | docker compose exec -T sonar-db psql -U sonar -d sonar
docker compose start sonarqube
echo "Готово. Проверьте: GitLab открывается, проекты на месте; Sonar показывает проект onec-config."
