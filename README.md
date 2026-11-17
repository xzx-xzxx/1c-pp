# onec-ci-platform — CI/CD-среда для конфигураций 1С

Проект УрФУ: GitLab + Runner + SonarQube (BSL) + 1C:EDT. Автоматические проверки на каждый merge request, сборка `.cf`, тесты на отдельной ИБ, версионируемые артефакты, обновление тестового контура, сценарий для прода.

Этот репозиторий — платформа (инфраструктура, шаблон pipeline, скрипты, документация). Код конфигурации 1С живёт в локальном GitLab на VPS (`onec-config`).

## Схема
См. [docs/architecture.md](docs/architecture.md), [docs/pipeline.md](docs/pipeline.md).

## Quick start
<!-- QUICKSTART -->
1. Требования: Docker с Compose v2, 4 vCPU / 16 ГБ RAM, Ubuntu 22.04/24.04.
2. `cp docker/.env.example docker/.env`, задайте пароли и домен. Для `https` нужен публичный домен (Let's Encrypt) или свои сертификаты.
3. `ci/scripts/fetch-bsl-plugin.sh` — скачать плагин sonar-bsl.
4. `cd docker && docker compose up -d`; ждать `healthy` в `docker compose ps` (GitLab стартует несколько минут).
5. SonarQube: `http://<хост>:9000`, admin/admin → сменить пароль; затем `SONAR_ADMIN_PASSWORD=... ci/scripts/sonar-setup.sh` (quality gate `onec-gate`). Создайте токен для CI.
6. GitLab: пароль root из `GITLAB_ROOT_PASSWORD`. Admin → CI/CD → Runners → New instance runner (тег `docker`), затем `ci/scripts/register-runner-docker.sh <glrt-токен>`.
7. Проект `onec-config`: в корень положите `ci/.gitlab-ci.yml` (как `.gitlab-ci.yml`) и `ci/sonar-project.properties`; в CI variables: `SONAR_HOST_URL=http://sonarqube:9000`, `SONAR_TOKEN` (masked). Стадии 1С включаются `ONEC_ENABLED=true` после установки платформы и раннера `onec` (`ci/scripts/register-runner-onec.sh`).

Статус: пройдено в песочнице Claude Code (см. `docs/evidence/local-sandbox-test.md`); на чистом VPS командой — ещё не проверено.
<!-- /QUICKSTART -->

## Доска задач
<!-- BOARD -->
_Ссылка на публичную доску появится в PR `docs/roadmap-and-board`._
<!-- /BOARD -->

## Статус требований
Честная таблица 15 требований: [docs/requirements-status.md](docs/requirements-status.md). Что не запускалось, так и помечено.

## Документы
`docs/`: architecture, pipeline, regulation, roles, dev-guide, prod-scenario, sppr-integration, migration-tz, license, roadmap, competitors, ai-usage.

## Правила
Секреты, дистрибутивы и лицензии 1С в репозиторий не попадают. Работа через issue и PR: [CONTRIBUTING.md](CONTRIBUTING.md).

Часть материалов подготовлена с помощью Claude Code, см. [docs/ai-usage.md](docs/ai-usage.md).
