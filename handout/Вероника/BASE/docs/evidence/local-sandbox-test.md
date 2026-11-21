# Локальный тест стенда (песочница Claude Code, не VPS)

Дата: 2026-11-17. Это **не доказательство для приёмки на VPS**: стенд был поднят в одноразовой песочнице, чтобы проверить код. На VPS всё нужно повторить и снять свои скрины.

Проверено реальными запусками:
- GitLab CE 17.5.2, SonarQube 10.6 + плагин sonar-bsl 1.15.0, Postgres 15, GitLab Runner 17.5.2 — подняты через `docker/docker-compose.yml` (с локальным override только для лимитов песочницы).
- `ci/scripts/sonar-setup.sh` создал quality gate `onec-gate` (Blocker/Critical).
- Проект `onec-config`, MR из `feature/good-change` и `feature/bad-change`: pipeline стартовали сами.
  - good: pipeline `success`, статус MR `mergeable`.
  - bad: `lint` → `QUALITY GATE STATUS: FAILED`, pipeline `failed`, статус MR `ci_must_pass`, `PUT .../merge` → `405 Method Not Allowed`.
- `ci/scripts/backup.sh` создал бэкап GitLab (tar) и дамп Sonar. После бэкапа создан лишний проект `tmp-after-backup`; `ci/scripts/restore.sh <метка>` отработал до конца, проект исчез, `root/onec-config` и проект в Sonar на месте. В выводе restore 4 строки `must be owner of extension pg_trgm/btree_gist` (известное безвредное сообщение при восстановлении GitLab).

Не проверялось: стадии build/test/deploy (нужна платформа 1С), HTTPS и 2FA, скрипты для 1С (`vrunner`/`ring`), EDT.

Дополнительно проверено (песочница): защита `main`, `release/*` и тегов `v*` через API (push никому, merge Maintainers, force push выключен); прямой push в `main` отклонён: `pre-receive hook declined`. Команды — в `РУКАМИ.md` Вероники.
