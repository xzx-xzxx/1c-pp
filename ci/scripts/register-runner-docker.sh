#!/usr/bin/env bash
# register-runner-docker.sh <registration-token>; GITLAB_URL из окружения
set -euo pipefail
cd "$(dirname "$0")/../../docker"
docker compose exec -T gitlab-runner gitlab-runner register --non-interactive \
 --url "${GITLAB_URL:?}" --token "${1:?токен раннера}" --executor docker \
 --docker-image alpine:3.20 --description docker-runner --docker-volumes /var/run/docker.sock:/var/run/docker.sock
