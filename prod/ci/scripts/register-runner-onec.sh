#!/usr/bin/env bash
# Регистрация shell-раннера `onec` на машине с платформой 1С. Запускать от root на VPS.
# register-runner-onec.sh <token>; GITLAB_URL из окружения. Требует установленного gitlab-runner.
set -euo pipefail
command -v gitlab-runner >/dev/null || { echo "gitlab-runner не установлен"; exit 1; }
gitlab-runner register --non-interactive --url "${GITLAB_URL:?}" --token "${1:?токен}" \
 --executor shell --description onec-runner
echo "Тег onec задаётся при создании раннера в GitLab (Admin → CI/CD → Runners)."
