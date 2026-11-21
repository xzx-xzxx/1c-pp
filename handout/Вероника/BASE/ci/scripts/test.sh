#!/usr/bin/env bash
# Автотесты на отдельной файловой тестовой ИБ (vanessa-runner/xunit). Не запускалось.
set -euo pipefail
TESTIB="${TEST_IB_PATH:-/var/onec/testib}"
rm -rf "$TESTIB" && mkdir -p "$TESTIB"
vrunner init-dev --ibconnection "/F$TESTIB"
vrunner update-dev --src build --ibconnection "/F$TESTIB" || vrunner load --src "build/onec-config-${APP_VERSION}.cf" --ibconnection "/F$TESTIB"
xvfb-run -a vrunner xunit tests/xunit --ibconnection "/F$TESTIB" --reportsxunit "ГенерацияОтчетаJUnitXML{build/junit.xml}"
