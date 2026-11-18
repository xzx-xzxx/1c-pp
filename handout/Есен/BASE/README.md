# onec-ci-platform — CI/CD-среда для конфигураций 1С

Проект УрФУ: GitLab + Runner + SonarQube (BSL) + 1C:EDT. Автоматические проверки на каждый merge request, сборка `.cf`, тесты на отдельной ИБ, версионируемые артефакты, обновление тестового контура, сценарий для прода.

Этот репозиторий — платформа (инфраструктура, шаблон pipeline, скрипты, документация). Код конфигурации 1С живёт в локальном GitLab на VPS (`onec-config`).

## Схема
См. [docs/architecture.md](docs/architecture.md), [docs/pipeline.md](docs/pipeline.md).

## Quick start
<!-- QUICKSTART -->
_Раздел будет добавлен в PR `infra/compose-stand`._
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
