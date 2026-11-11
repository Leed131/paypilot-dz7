#!/usr/bin/env bash
set -euo pipefail
if [ "${1:-}" != "--run" ]; then
  echo "Для платного запуску двох профілів: bash scripts/run_full_profiles.sh --run"
  exit 2
fi
repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_dir"
export STAND_DIR="${STAND_DIR:-$HOME/Downloads/4 AI Quality Engineering/paypilot-stand-l08}"
export EVAL_STAND_URL="${EVAL_STAND_URL:-http://host.docker.internal:8000}"
export EVAL_MODEL="anthropic/claude-haiku-5.5"
test -d "$STAND_DIR/app" || { echo "Не знайдено app стенда: $STAND_DIR/app"; exit 2; }
docker info >/dev/null
docker compose -p l08-dz7 config --quiet
docker compose -p l08-dz7 run --rm -T --entrypoint python eval -c 'import stand; h=stand.health(); assert h.get("status")=="ok", "stand health failed"; assert h.get("provider")=="openrouter", "Expected OpenRouter"; assert not h.get("locked"), "Stand is locked"; print("Стенд готовий. Модель цього запуску: anthropic/claude-haiku-5.5. Платних запитів перевірка не робить.")'
docker compose -p l08-dz7 run --rm -T eval --set l05_dialogs --dry-run
docker compose -p l08-dz7 run --rm -T --entrypoint python eval -m unittest discover -s tests -v
mkdir -p reports
mkdir reports/full-profiles.lock 2>/dev/null || { echo "Захист від повтору: reports/full-profiles.lock вже існує. Перевірте збережені результати, не запускайте повторно автоматично."; exit 2; }
run_folder="reports/full-profiles-$(date +%Y%m%d-%H%M%S)"
mkdir "$run_folder"
printf '%s\n' "$run_folder" > reports/full-profiles.lock/output-folder.txt
git rev-parse HEAD > "$run_folder/commit.txt"
cp sets/l05_dialogs.jsonl "$run_folder/l05_dialogs.snapshot.jsonl"
restore_clean() {
  set +e
  docker compose -p l08-dz7 run --rm -T --entrypoint python eval -c 'import stand; result=stand.set_profile("clean"); print("Повернення стенда:", result.get("profile", "clean"))' > "$run_folder/restore-clean.log" 2>&1
  restore_code=$?
  printf '%s\n' "$restore_code" > "$run_folder/restore-clean.exit-status.txt"
  if [ "$restore_code" -ne 0 ]; then echo "Повернення clean не підтверджене. Дивіться restore-clean.log."; fi
}
trap restore_clean EXIT
trap 'exit 130' INT TERM
echo "Починаємо два профілі. До 56 діалогів на профіль. Не запускайте інші тести. Автоматичних повторів немає."
for profile_name in lesson-08 clean; do
  set +e
  docker compose -p l08-dz7 run --rm -T eval --set l05_dialogs --gate all --profile "$profile_name" --traces 2>&1 | tee "$run_folder/$profile_name.log"
  profile_code=${PIPESTATUS[0]}
  set -e
  printf '%s\n' "$profile_code" > "$run_folder/$profile_name.exit-status.txt"
  echo "Профіль $profile_name завершив команду з кодом $profile_code. FAIL не перетворюємо на PASS."
done
echo "Команди обох профілів завершені. Перевірте reports/ та журнали: $run_folder"
echo "Для архіву результатів: python3 scripts/pack_results.py"
