# Pipeline

Файл-шаблон: `ci/.gitlab-ci.yml`. Запуск: `merge_request_event`, ветки `release/*`, теги `vX.Y.Z`.

| Стадия | Runner | Что делает | Вход → выход | Условие |
| --- | --- | --- | --- | --- |
| lint | docker | sonar-scanner + BSL LS, ждёт quality gate | исходники → отчёт в Sonar, статус в MR | MR, release/* |
| build | onec | сборка `.cf` из EDT | исходники → `build/*.cf` | всегда после lint |
| test | onec | автотесты на тестовой ИБ | `.cf` → `junit.xml` | после build |
| artifact | onec | версионируемый артефакт `onec-config-<версия>.cf` | `.cf` → артефакт GitLab | release/*, теги |
| deploy-test | onec | обновление тестового контура | артефакт → тестовая ИБ | merge в release/* |
| deploy-prod | onec | manual: бэкап → обновление → проверка → откат | артефакт → прод ИБ | тег `v*`, вручную |

## Переменные CI
`SONAR_HOST_URL`, `SONAR_TOKEN` (masked), `TEST_IB_PATH`, `TEST_STAND_IB`, `PROD_IB`, `BACKUP_DIR` (protected), `CONFIRM=yes` для prod.

## Lint: что блокирует merge (проверено на стенде)
Quality gate `onec-gate` (создаётся `ci/scripts/sonar-setup.sh`) падает, если в проекте есть хотя бы один issue серьёзности **Blocker** или **Critical**. Проверено: модуль с `ParseError`, `UsingHardcodeSecretInformation`, `UsingHardcodePath`, `UsingHardcodeNetworkAddress` (все Critical) → gate FAILED, сканер завершается с ошибкой; чистый модуль → PASSED.

Набор правил определяет профиль «BSL Language Server rules» плагина, **не** `ci/.bsl-language-server.json` (отключение диагностики в нём на отчёт Sonar не влияет; файл нужен только для локального BSL LS в IDE). Блокируют все правила, которым плагин ставит Critical/Blocker; Major (например, `UnusedLocalVariable`, `EmptyCodeBlock`) — только в отчёте. Чтобы изменить блокирующий набор, правится профиль качества или серьёзность правил в Sonar.

Обоснование основных блокирующих правил:

| Диагностика | Серьёзность в Sonar | Почему блокирует |
| --- | --- | --- |
| ParseError | Critical | код не разбирается, сборка заведомо сломается |
| UsingHardcodeSecretInformation | Critical | пароли и ключи в исходниках |
| UsingHardcodePath | Critical | привязка к конкретной машине, ломается на другом контуре |
| UsingHardcodeNetworkAddress | Critical | привязка к адресу, ломается на другом контуре |

Остальные правила и их серьёзность — по профилю плагина; полный список после настройки уточняет автор PR S-A.

Ограничение прототипа: стадии build/test/deploy описаны, не запускались без платформы 1С (`license.md`).
