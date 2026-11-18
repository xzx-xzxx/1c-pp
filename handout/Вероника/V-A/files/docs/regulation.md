# Регламент разработки и выпуска

## Ветки
`main` — стабильная, push запрещён; `release/X.Y` — релизная; `feature/<кратко>`, `hotfix/<кратко>`; теги `vX.Y.Z`.

## Коммиты
Формат `#123: что сделано` (номер задачи). Маленькие коммиты.

## Цикл MR
1. Ветка от `main` (или `release/X.Y` для hotfix).
2. Коммит → push → MR. Pipeline стартует сам.
3. Ревью: назначить ревьюера в MR; все threads resolved; pipeline зелёный.
4. Squash merge, ветка удаляется. Merge в `main` и `release/*` — только Maintainer.

## Редакция GitLab
Free: нет обязательных approvals и CODEOWNERS, поэтому ревью закреплено регламентом, а merge ограничен ролью Maintainer. *Редакцию проверить в Admin и записать здесь:* [впиши].

## Выпуск релиза
`release/X.Y` от `main` → фиксы только через MR → тег `vX.Y.Z` Maintainer'ом → `artifact` → `deploy-test` → проверка → manual `deploy-prod` (`prod-scenario.md`).

## Hotfix
`hotfix/*` от релизной ветки, MR в `release/X.Y`, затем перенос в `main`, новый патч-тег.

## Версионирование
SemVer `X.Y.Z`: X — несовместимые изменения, Y — функции, Z — исправления.

## Настройки MR
Pipeline must succeed; skipped pipelines не считаются успешными; threads resolved; squash по умолчанию; удалять ветку после merge.
