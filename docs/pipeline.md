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
`SONAR_HOST_URL`, `SONAR_TOKEN` (masked), `LINT_IMAGE`, `TEST_IB_PATH`, `TEST_STAND_IB`, `PROD_IB`, `BACKUP_DIR` (protected), `CONFIRM=yes` для prod.

## Lint: блокирующие диагностики и quality gate
Quality gate `onec-gate` (настраивается в Sonar): 0 новых Blocker/Critical, покрытие не проверяется на прототипе. Обоснование каждой блокирующей диагностики — в таблице ниже.

| Диагностика BSL LS | Почему блокирует |
| --- | --- |
| ParseError | код не разбирается — сборка заведомо сломается |
| UsingHardcodeSecretInformation | пароли и ключи в исходниках |
| UsingHardcodePath / UsingHardcodeNetworkAddress | код привязан к конкретной машине, ломается на другом контуре |
| CommitTransactionOutsideTryCatch | риск зависшей транзакции и потери данных |
| DeletingCollectionItem | ошибка выполнения при обходе коллекции |
| ExecuteExternalCodeInCommonModule | выполнение произвольного кода — угроза безопасности |
| UsingFindElementByString | неоднозначный поиск, ошибки в проде |
| UnusedLocalVariable | предупреждение, не блокирует; в конфиге включено для отчёта |

> Список — стартовый; уточняется командой после первого прогона на демо-конфигурации. Фактическая серьёзность в Sonar берётся из плагина — проверить на стенде.

Ограничение прототипа: стадии build/test/deploy описаны, не запускались без платформы 1С (`license.md`).
