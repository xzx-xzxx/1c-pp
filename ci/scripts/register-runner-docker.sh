#!/usr/bin/env bash
# Регистрация docker-раннера (тег docker, создаётся в GitLab: Admin → CI/CD → Runners → New instance runner).
# register-runner-docker.sh <runner-token glrt-...>
# Раннер ходит в GitLab по имени сервиса compose, job-контейнеры — в той же сети (видят gitlab и sonarqube).
set -euo pipefail
cd "$(dirname "$0")/../../docker"
NET="$(basename "$PWD")_default"
docker compose exec -T gitlab-runner gitlab-runner register --non-interactive \
 --url "${GITLAB_INTERNAL_URL:-http://gitlab}" --clone-url "${GITLAB_INTERNAL_URL:-http://gitlab}" \
 --token "${1:?токен раннера}" --executor docker --docker-image alpine:3.20 \
 --docker-network-mode "$NET" --docker-pull-policy if-not-present
