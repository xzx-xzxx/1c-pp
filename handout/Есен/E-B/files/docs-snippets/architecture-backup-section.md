
## Бэкап и восстановление
`ci/scripts/backup.sh` — `gitlab-backup` + секреты + `pg_dump` Sonar. `ci/scripts/restore.sh <метка>` — обратная операция. Проверка восстановления выполняется людьми, доказательство — в `docs/evidence/`.
