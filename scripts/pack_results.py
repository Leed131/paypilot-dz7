"""Лише пакування наявних результатів. Модель не викликається."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
root=Path(__file__).resolve().parents[1]
archive=root/'paypilot-dz7-results.zip'
files=[p for p in (root/'reports').rglob('*') if p.is_file()]
files+=[root/'sets/l05_dialogs.jsonl',root/'HW7_STATUS.md',root/'l08/source-version.json']
with ZipFile(archive,'w',ZIP_DEFLATED) as z:
    for p in sorted(files):
        z.write(p,p.relative_to(root).as_posix())
print('Архів створено:',archive)
print('Це не підтвердження успішності або повноти прогонів. Надішліть архів для перевірки звітів.')
