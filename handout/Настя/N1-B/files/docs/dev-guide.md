# Руководство разработчика

> Черновик. Автор PR N1-B обязан пройти шаги руками и исправить всё, что не сработало.

1. **Клон:** `git clone <url GitLab>/onec-config.git && cd onec-config`.
2. **Ветка:** `git switch -c feature/<кратко> origin/main`.
3. **EDT:** File → Import → Existing Projects, указать каталог клона; рабочая область — вне клона. Правки только в EDT.
4. **Коммит:** `git add -A && git commit -m "#123: что сделано"`.
5. **Push:** `git push -u origin feature/<кратко>`.
6. **MR:** в GitLab открыть MR в `main`, назначить ревьюера. Pipeline стартует сам.
7. **Если pipeline красный:** открыть job `lint`, исправить замечания Sonar/BSL, сделать новый коммит — pipeline перезапустится.
8. **Merge:** после зелёного pipeline и resolved threads merge делает Maintainer (squash).

Проверено на практике: [впиши, кто и когда проходил, что поправлено].
