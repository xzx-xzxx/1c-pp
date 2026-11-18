#!/usr/bin/env bash
# Сборка .cf из исходников EDT. Требует платформу 1С и 1cedtcli/ring на раннере onec. Не запускалось.
set -euo pipefail
: "${APP_VERSION:?}"; mkdir -p build
WS=$(mktemp -d)
ring edt workspace import --project "$PWD/src/.." --workspace-location "$WS" || true
ring edt workspace export --project "$PWD" --workspace-location "$WS" --configuration-files "$WS/xml"
"${ONEC_BIN:-/opt/1cv8/x86_64/current}/1cv8" DESIGNER /DisableStartupDialogs /F "$WS/ib" \
  /LoadConfigFromFiles "$WS/xml" /DumpCfg "build/onec-config-${APP_VERSION}.cf"
ls -l build/
