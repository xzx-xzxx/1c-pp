#!/usr/bin/env bash
# Готовит ветку и коммит для твоего PR. Использование: bash pr.sh <PR> <номер issue> <путь к клону репо>
# Пример: bash pr.sh N1-A 12 ~/onec-ci-platform
# Скрипт НЕ делает push: сначала положи доказательства в docs/evidence/ (см. ПАМЯТКА), потом push.
set -euo pipefail
PR="${1:?PR, например N1-A}"; ISSUE="${2:?номер issue}"; REPO="${3:?путь к клону}"
HERE="$(cd "$(dirname "$0")" && pwd)"
case "$PR" in
  N1-A) BRANCH="onec/demo-config-edt"; TITLE="демо-конфигурация в формате edt";;
  N1-B) BRANCH="onec/dev-guide"; TITLE="руководство разработчика (проверено руками)";;
  N1-C) BRANCH="docs/competitors"; TITLE="конкурентный анализ";;
  *) echo "Нет такого PR у тебя. Доступны: N1-A, N1-B, N1-C"; exit 1;;
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
