> Редакція після зауважень ментора, 2026-11-12. Ресурсні пороги перераховано від останніх clean-медіан. Офлайн всі 6 ресурсних кейсів проходять 5/5 clean. Незалежний живий C07 підтверджено: clean PASS 5/5, lesson-08 FAIL (4/5 перевищили бюджет). Деталі: [звіт](l08/observability-cost-report.md).

# ДЗ_7: підготовлена копія PayPilot

Статус: підготовлено на базі чистого офіційного кіта L03 (коміт 7d0f5e7), накладено власні кейси й адаптований ранер. Chain-ready прогін обох профілів завершено, формальні FAIL збережено. Стенд окремий і не входить до репозиторію. Попередні репозиторії ДЗ не змінено. Джерело: l08/source-version.json.

## Останні повні прогони

За наданими результатами виконано обидва профілі `--gate all`: **lesson-08 5/12 PASS**, **clean 8/12 PASS**. Завершено 112 діалогів, є 794 кореневі трейси. Стенд повернуто на clean. Це виконаний chain-ready прогін із явними FAIL, не зелений release. Аналіз: [l08/full-validation-review.md](l08/full-validation-review.md).

## L08 · Observability & Cost Report

Заповнений звіт: l08/observability-cost-report.md. Точна порожня форма: l08/observability-cost-report.template.md. B4: l08/b4.json. Калібрування: l08/calibration.json і останній блок звіту.

### Запуск

Команди нижче платні. Виконувати з кореня окремої копії на Mac, із запущеним stand. Не запускати паралельно. `--repeat 1` не додається: runs у кейсах збережено. lesson-08 може дати очікувані FAIL, але прогін має завершитися і записати звіт.

```bash
STAND_DIR="../paypilot-stand-l08" EVAL_STAND_URL="http://host.docker.internal:8000" docker compose run --rm -T eval --set l05_dialogs --gate all --profile lesson-08 --traces
```

Після завершення повернути стенд і отримати звіт clean навіть за наявності очікуваних FAIL попереднього запуску:

```bash
STAND_DIR="../paypilot-stand-l08" EVAL_STAND_URL="http://host.docker.internal:8000" docker compose run --rm -T eval --set l05_dialogs --gate all --profile clean --traces
```

Шлях STAND_DIR передбачає сусідню папку stand. За іншим розташуванням вказати її фактичний шлях. Не запускати з архівного каталогу випадково.

### Бюджетні кейси (sets/l05_dialogs.jsonl)

Пороги: медіани останнього clean плюс запас. [Розрахунок](l08/calibration.json), [офлайн-перевірка](reports/budget-reassessment-20261112.json).

| id | identical_tool_calls_max | tokens_total | latency_ms | gate / runs |
|---|---:|---:|---:|---|
| C07-BUDGET | — | 80000 | 28000 | release / 5 |
| C08-BUDGET | — | 59000 | 32000 | release / 5 |
| C09-BUDGET | — | 39000 | 25000 | release / 5 |
| C10-BUDGET | — | 91000 | 41000 | release / 5 |
| C11-BUDGET | — | 70000 | 24000 | release / 5 |
| C12-BUDGET | — | 50000 | 19000 | release / 5 |
| C13-D14-BUDGET | 1 | — | — | daily / 1 |

### Прогони

| Що | Профіль / модель | Звіт |
|---|---|---|
| C07, історична калібрувальна серія | clean / Haiku | reports/l05_dialogs-clean-20261110T181629.json |
| C07, історична дефектна серія | lesson-08 / Haiku | reports/l05_dialogs-lesson-08-20261110T182145.json |
| C07, незалежний clean | clean / Haiku | reports/l05_dialogs-clean-20261110T183514.json |
| B4, 40 діалогів | Haiku + Gemini | l08/b4.json |
| Поточний повний набір 12 кейсів | lesson-08 / Haiku | reports/l05_dialogs-lesson-08-20261111T213817.json, 5/12 |
| Поточний повний набір 12 кейсів | clean / Haiku | reports/l05_dialogs-clean-20261111T220253.json, 8/12 |

Старі звіти мають інші set_hash і не підтверджують новий набір. Історичні 1/5 бюджетів, контрольний C08 1/1, регресія 4/6 залишаються у l08/evidence/results/. Повного зеленого набору не заявлено.

### Офлайн-перевірка без моделі

```bash
python3 -m unittest discover -s tests -v
python3 cli.py --set l05_dialogs --dry-run
```

Для повного --gate all очікується 56 діалогів на профіль: 11 release ×5 і один daily ×1. Разом два профілі: 112, якщо всі спроби завершаться. Це не 12 платних діалогів. Фактичні витрати наперед не гарантовані.


### Повний запуск на Mac одним блоком

```bash
bash scripts/run_full_profiles.sh --run
```

Скрипт перевіряє стенд без платного запиту, фіксує Haiku у заголовку X-Stand-Settings, виконує lesson-08 і clean послідовно, зберігає окремі журнали та exit-коди. Автоматичних повторів немає. Після завершення або переривання пробує повернути clean. Каталог reports/full-profiles.lock захищає від випадкового повторного платного запуску. Не видаляти його без перевірки збережених результатів.

Для обміну результатами: scripts/pack_results.py створює paypilot-dz7-results.zip зі звітами та трейсами. Цей скрипт не запускає модель.

Повні прогони вже виконано. Команди запуску вище наведено для відтворення, повторювати їх зараз не потрібно. Історичні 1/5 і контрольний 1/1 стосуються старих серій, остання незалежна clean-серія C08–C12 має 5/5 кейсів PASS.

### Контроль після правок ментора

C07, новий set_hash 97e70ace4035: [clean PASS 5/5](reports/l05_dialogs-clean-20261112T153113.json), [lesson-08 FAIL](reports/l05_dialogs-lesson-08-20261112T153324.json). 10 завершених діалогів, clean відновлено. Перевірка й межі: [l08/c07-revision-validation.json](l08/c07-revision-validation.json). Нову повну регресію всього набору після зміни бюджетів не запускали.
