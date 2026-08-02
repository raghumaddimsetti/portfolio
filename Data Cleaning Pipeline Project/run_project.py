import os
import csv
from pathlib import Path

base = Path(__file__).resolve().parent
files = [
    'README.md',
    'schema_mysql.sql',
    'schema_sqlserver.sql',
    'pipeline_mysql.sql',
    'pipeline_sqlserver.sql',
    'sample_data.csv'
]

print('Project files found:')
for f in files:
    p = base / f
    status = 'exists' if p.exists() else 'missing'
    print(f'- {f}: {status}')

print('\nSample rows from CSV:')
with open(base / 'sample_data.csv', newline='', encoding='utf-8') as fh:
    reader = csv.reader(fh)
    for i, row in enumerate(reader):
        if i == 0:
            continue
        print(row)
        if i >= 4:
            break
