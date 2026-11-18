#!/usr/bin/env bash
# Первый коммит в НОВЫЙ пустой репо: кладёт базу (BASE/). Использование: bash push-base.sh <путь к клону нового репо>
# Выполнять ДО включения защиты main.
set -euo pipefail
REPO="${1:?путь к клону нового пустого репо}"; HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO"; git switch -C main 2>/dev/null || true
cp -r "$HERE/BASE/." .
git add -A && git commit -m "Базовый каркас платформы" && git push -u origin main
echo "База загружена. Теперь включи защиту main (Settings → Rules) и сообщи команде."
