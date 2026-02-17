# scripts/open_hugo_url.py
import json
import subprocess
import sys
from pathlib import Path

SOURCE = Path(sys.argv[1]).resolve()

with open("public/source-map.json") as f:
    data = json.load(f)

for url, meta in data.items():
    if Path(meta["absolute_source"]).resolve() == SOURCE:
        subprocess.run(["x-www-browser", f"http://localhost:1313{url}"])  # macOS
        print(url)
        break
else:
    print("Source not found")