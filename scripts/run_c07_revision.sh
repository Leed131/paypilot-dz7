#!/usr/bin/env bash
set -euo pipefail
if [ "${1:-}" != "--run" ]; then echo "Платна перевірка C07, 5 clean і 5 lesson-08: bash scripts/run_c07_revision.sh --run"; exit 2; fi
cd "$(dirname "$0")/.."
export STAND_DIR="${STAND_DIR:-$HOME/Downloads/4 AI Quality Engineering/paypilot-stand-l08}"
export EVAL_MODEL="anthropic/claude-haiku-5.5"
test -d "$STAND_DIR/app"
docker info >/dev/null
docker compose -p l08-dz7-review run --rm -T --entrypoint python eval -c 'import stand; assert stand.health().get("status")=="ok"; print("Health OK. Платних запитів ще не було.")'
docker compose -p l08-dz7-review run --rm -T eval --set l05_dialogs --dry-run
mkdir -p reports
mkdir reports/c07-revision.lock 2>/dev/null || { echo "Захист від повтору: цей запуск уже починався. Перевірте результати."; exit 2; }
folder="reports/c07-revision-$(date +%Y%m%d-%H%M%S)"
mkdir "$folder"
git rev-parse HEAD > "$folder/commit.txt"
cp sets/l05_dialogs.jsonl "$folder/set.snapshot.jsonl"
restore() {
  set +e
  docker compose -p l08-dz7-review run --rm -T --entrypoint python eval -c 'import stand; stand.set_profile("clean"); print("clean restored")' > "$folder/restore-clean.log" 2>&1
  printf '%s\n' "$?" > "$folder/restore-clean.exit-status.txt"
}
trap restore EXIT
trap 'exit 130' INT TERM
for profile in clean lesson-08; do
  set +e
  docker compose -p l08-dz7-review run --rm -T eval --set l05_dialogs --only C07-BUDGET --gate all --profile "$profile" --traces 2>&1 | tee "$folder/$profile.log"
  code=${PIPESTATUS[0]}
  set -e
  printf '%s\n' "$code" > "$folder/$profile.exit-status.txt"
done
echo "Перевірка C07 завершила команди. Звіти з новим set_hash у reports/. Для архіву: python3 scripts/pack_results.py"
