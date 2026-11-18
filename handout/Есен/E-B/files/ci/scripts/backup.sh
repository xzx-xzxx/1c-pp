#!/usr/bin/env bash
# Бэкап GitLab (встроенная утилита) и SonarQube (дамп Postgres + extensions).
# Запуск из каталога docker/: ../ci/scripts/backup.sh
set -euo pipefail
cd "$(dirname "$0")/../../docker"
DEST="${BACKUP_DIR:-../backups}"; TS=$(date +%Y%m%d-%H%M%S)
mkdir -p "$DEST/gitlab" "$DEST/sonar"
docker compose exec -T gitlab gitlab-backup create STRATEGY=copy BACKUP="$TS"
docker compose cp gitlab:/etc/gitlab/gitlab-secrets.json "$DEST/gitlab/gitlab-secrets-$TS.json"
docker compose cp gitlab:/etc/gitlab/gitlab.rb "$DEST/gitlab/gitlab-$TS.rb"
docker compose exec -T sonar-db pg_dump -U sonar sonar | gzip > "$DEST/sonar/sonar-$TS.sql.gz"
echo "Бэкап готов: $DEST (метка $TS)"
