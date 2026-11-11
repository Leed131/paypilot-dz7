# Карта доказів

| Твердження / назва у звіті | Файл у пакеті |
|---|---|
| Основний звіт | observability-cost-report.md |
| Фінансова модель і припущення | cost-model.md |
| Статус, незакриті обмеження | STATUS.md; status.json |
| Актуальні 11 кейсів | code/l05-eval/sets/l05_dialogs.jsonl |
| Поточні runner/assertions/loader | code/l05-eval/ |
| Зміни стенда | code/stand-patch/patched/app/; stand.patch; README.md |
| Історичні оригінали 4 файлів стенда | code/stand-patch/original/app/ |
| П’ять калібрувальних прогонів на новий бюджет | calibration/budget-five-calibration.json; первинні трейси у l05-full-clean-reason-check-v2.zip |
| Нативні сценарії B1–B4 і ціни | code/l08-eval-reference/ |
| B2 і B3, п’ять baseline + п’ять defect | evidence/raw-archives/B2-five-runs.zip; B3-five-runs.zip |
| Завершений B4 | evidence/results/b4.json; evidence/raw-archives/B4-migration-complete.zip |
| Початкова перервана спроба B4 | evidence/raw-archives/B4-migration-partial.zip; історичний exit-status=1 збережено, це не статус завершеного resume |
| C07: калібрування / defect / незалежний clean | evidence/raw-archives/C07-BUDGET-*.zip |
| Пілот C08–C12 | evidence/results/l05_dialogs-clean-20261111T163724.json |
| Незалежна серія C08–C12, офіційно 1/5 | evidence/results/l05_dialogs-clean-20261111T165617.json; evidence/raw-archives/budget-five-validation-evidence.zip |
| Два RemoteProtocolError | evidence/logs/budget-validation-stand-log.txt |
| Контрольний C08 після виправлення, 1/1 | evidence/results/l05_dialogs-clean-20261111T175922.json |
| Остання повна історична регресія 4/6 | evidence/results/l05_dialogs-clean-20261110T190557.json; evidence/raw-archives/l05-full-clean-reason-check-v2.zip |
| Власний Langfuse Sessions: 7 трейсів, ціна, діалог | evidence/screenshots/langfuse-evidence/ |
| Індивідуальні JSON експорти Langfuse | evidence/langfuse-json/ |
| 8 офлайн-тестів транспорту | code/stand-patch/test_transport.py; evidence/offline/transport-tests.txt |
| Архіви застосованих змін | installers/ — для аудиту; не запускаються при перевірці пакета |

Імена внутрішніх файлів сирих ZIP збережені байт-у-байт. Усередині них шляхи reports/... відповідають оригінальним папкам користувачки на Mac. Старі README й terminal.log є історичними доказами; актуальний статус — у STATUS.md та основному звіті. Вкладені архіви потрібно розпакувати окремо для перегляду сирих спанів; для первинного огляду підсумкові JSON винесені в evidence/results.


## Доповнення за інструкцією лабораторної

| Пункт | Файл |
|---|---|
| Точне зіставлення вимог | LAB_CHECKLIST.md |
| Наданий текст лабораторної | lab-additions/lab-instructions-provided.txt |
| Крива B2 та 70 вихідних вимірювань | lab-additions/b2-first-call-input.png; .svg; -raw.csv; -summary.csv |
| D15: Raw Input першого виклику кроку 6 | lab-additions/screenshots/03-d15-step6-raw-input.jpg |
| B3: Input і Output agent.summarize | lab-additions/screenshots/04-b3-summarize-input-output.jpg |
| Неповне визначення ціни Langfuse | lab-additions/pricing-buckets-calculation.md; .json |

Нові скриншоти знято зі старих власних трейсів; no cost на них не означає безкоштовності, вони записані до визначення моделі. Розгорнуто лише потрібні поля штатного UI; вміст зображень не редагували.

## Уточнення пошуку прогнозу

Джерела, ранній текст та межі висновку: lab-additions/FORECAST_SOURCE_REVIEW.md і lab-additions/lab-instructions-early-20261108.txt.

## Підсумкові три слайди та форма

report-slides/README.md: редаговані презентації, по три PNG звіту і форми, повний текст із примітками. Шість бюджетів: code/l05-eval/sets/l05_dialogs.jsonl.
