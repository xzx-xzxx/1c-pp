#!/usr/bin/env bash
# Готовит ветку и коммит для твоего PR. Использование: bash pr.sh <PR> <номер issue> <путь к клону репо>
# Пример: bash pr.sh E-A 12 ~/onec-ci-platform
# Скрипт НЕ делает push: сначала положи доказательства в docs/evidence/ (см. ПАМЯТКА), потом push.
set -euo pipefail
PR="${1:?PR, например E-A}"; ISSUE="${2:?номер issue}"; REPO="${3:?путь к клону}"
HERE="$(cd "$(dirname "$0")" && pwd)"
case "$PR" in
  E-A) BRANCH="infra/compose-stand"; TITLE="стенд в docker compose + quick start";;
  E-B) BRANCH="infra/backup-restore"; TITLE="бэкап и восстановление gitlab и sonar";;
  E-C) BRANCH="docs/architecture"; TITLE="архитектура: схема и компоненты";;
  *) echo "Нет такого PR у тебя. Доступны: E-A, E-B, E-C"; exit 1;;
esac
[ -d "$HERE/$PR/files" ] || { echo "Нет $HERE/$PR/files"; exit 1; }
cd "$REPO"
git switch main && git pull --ff-only
git switch -c "$BRANCH"
cp -r "$HERE/$PR/files/." .
git add -A
git commit -m "#$ISSUE: $TITLE"
echo
echo "Готово: ветка $BRANCH, коммит создан (файлы из $PR/files)."
echo "Дальше:"
echo "  1) выполни проверку из $PR/pr-description.md, положи скрины/логи в docs/evidence/"
echo "  2) git add -A && git commit -m \"#$ISSUE: доказательства\" && git push -u origin $BRANCH"
echo "  3) открой PR на GitHub, вставь текст из $PR/pr-description.md"
