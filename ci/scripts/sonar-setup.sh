#!/usr/bin/env bash
# Создаёт quality gate onec-gate (блокирует при любых Critical/Blocker) и назначает его по умолчанию.
# sonar-setup.sh ; переменные: SONAR_URL (по умолч. http://localhost:9000), SONAR_ADMIN_USER/SONAR_ADMIN_PASSWORD
set -euo pipefail
URL="${SONAR_URL:-http://localhost:9000}"; A=(-sS -u "${SONAR_ADMIN_USER:-admin}:${SONAR_ADMIN_PASSWORD:?}")
curl "${A[@]}" -X POST "$URL/api/qualitygates/create?name=onec-gate" >/dev/null || true
for m in blocker_violations critical_violations; do
  curl "${A[@]}" -X POST "$URL/api/qualitygates/create_condition?gateName=onec-gate&metric=$m&op=GT&error=0" >/dev/null || true
done
# убрать унаследованные условия "по новому коду" (покрытия у нас нет), оставить только Blocker/Critical
curl "${A[@]}" "$URL/api/qualitygates/show?name=onec-gate" | python3 -c "
import sys,json
for c in json.load(sys.stdin)['conditions']:
    if c['metric'] not in ('blocker_violations','critical_violations'): print(c['id'])" |
while read -r id; do curl "${A[@]}" -X POST "$URL/api/qualitygates/delete_condition?id=$id" >/dev/null; done
curl "${A[@]}" -X POST "$URL/api/qualitygates/set_as_default?name=onec-gate"
echo "onec-gate создан и назначен по умолчанию"
