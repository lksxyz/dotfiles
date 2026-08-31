#!/usr/bin/env python3
"""Bump pkgs/omp/default.nix to the latest oh-my-pi release.

Called daily from .github/workflows/update-omp.yml. Reads the pinned version,
queries the GitHub latest release, and — if newer — rewrites the derivation's
`version` and `sha256` (via `nix store prefetch-file`). No changes when
already up to date.

Usage:
  python3 scripts/update-omp.py           # edit in place
  python3 scripts/update-omp.py --check   # report only, never edit
"""

import json
import re
import subprocess
import sys
import urllib.request
from pathlib import Path

REPO = "can1357/oh-my-pi"
ASSET = "omp-linux-x64"
ROOT = Path(__file__).resolve().parent.parent
PKG = ROOT / "pkgs" / "omp" / "default.nix"

VERSION_RE = re.compile(r'version = "([^"]+)";')
SHA_RE = re.compile(r'sha256 = "([^"]+)";')


def api(url: str) -> dict:
    req = urllib.request.Request(url, headers={"User-Agent": "omp-update-bot"})
    with urllib.request.urlopen(req, timeout=60) as resp:
        return json.load(resp)


def main() -> int:
    check_only = "--check" in sys.argv

    text = PKG.read_text()
    current = VERSION_RE.search(text)
    if not current:
        print("could not find version line in pkgs/omp/default.nix")
        return 1

    current_version = current.group(1)
    release = api(f"https://api.github.com/repos/{REPO}/releases/latest")
    tag = release["tag_name"].lstrip("v")
    asset = next((a for a in release["assets"] if a["name"] == ASSET), None)
    if asset is None:
        print(f"latest release {tag} has no asset named {ASSET}; skipping")
        return 1

    if tag == current_version:
        print(f"omp is up to date ({current_version})")
        return 0

    print(f"update available: {current_version} -> {tag}")
    if check_only:
        return 0

    url = asset["browser_download_url"]
    prefetch = subprocess.run(
        ["nix", "store", "prefetch-file", "--name", "omp", "--json", url],
        check=True,
        capture_output=True,
        text=True,
    )
    new_sha = json.loads(prefetch.stdout)["hash"]

    new_text = VERSION_RE.sub(f'version = "{tag}";', text, count=1)
    new_text = SHA_RE.sub(f'sha256 = "{new_sha}";', new_text, count=1)
    PKG.write_text(new_text)
    print(f"bumped pkgs/omp/default.nix to {tag} ({new_sha})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
