#!/usr/bin/env python3

import argparse
import stat
import zipfile
from pathlib import Path


REQUIRED_FILES = (
    "anykernel.sh",
    "tools/ak3-core.sh",
    "Image",
    "dtb.img",
    "mint.prop",
)


def validate_package(package: Path, expected_edition: str | None) -> None:
    with zipfile.ZipFile(package) as archive:
        corrupt_entry = archive.testzip()
        if corrupt_entry is not None:
            raise SystemExit(f"{package} failed ZIP CRC validation at {corrupt_entry}")

        entries = {}
        for info in archive.infolist():
            name = info.filename.replace("\\", "/").removeprefix("./")
            if name in entries:
                raise SystemExit(f"{package} contains duplicate entry: {name}")
            if (
                name.startswith("/")
                or (len(name) > 1 and name[1] == ":")
                or ".." in name.split("/")
            ):
                raise SystemExit(f"{package} contains unsafe path: {name}")
            if stat.S_ISLNK(info.external_attr >> 16):
                raise SystemExit(f"{package} contains a symbolic link: {name}")
            entries[name] = info

        for name in REQUIRED_FILES:
            if name not in entries or entries[name].file_size == 0:
                raise SystemExit(f"{package} is missing or has an empty {name}")

        if not any(
            name.startswith("ramdisk") and "/" not in name and info.file_size > 0
            for name, info in entries.items()
        ):
            raise SystemExit(f"{package} is missing a non-empty ramdisk")

        if expected_edition is not None:
            if not package.name.startswith(f"UPA50-{expected_edition}-"):
                raise SystemExit(
                    f"{package} filename does not match edition {expected_edition}"
                )
            manifest = archive.read("mint.prop").decode("utf-8")
            expected_ksu = "true" if expected_edition == "kernelsu-next" else "false"
            if f"ro.mint.build.ksu={expected_ksu}" not in manifest.splitlines():
                raise SystemExit(
                    f"{package} manifest does not match edition {expected_edition}"
                )


def main() -> None:
    parser = argparse.ArgumentParser(description="Validate kernel release packages.")
    parser.add_argument("--release-dir", type=Path, required=True)
    parser.add_argument("--expected-packages", type=int, required=True)
    parser.add_argument("--expected-name")
    parser.add_argument(
        "--expected-edition", choices=("standard", "kernelsu-next")
    )
    args = parser.parse_args()

    if not args.release_dir.is_dir():
        raise SystemExit(f"Release directory does not exist: {args.release_dir}")

    assets = list(args.release_dir.iterdir())
    if any(not asset.is_file() or asset.suffix != ".zip" for asset in assets):
        raise SystemExit("Release directory contains a non-ZIP file or directory")

    packages = sorted(args.release_dir.glob("*.zip"))
    if len(packages) != args.expected_packages:
        raise SystemExit(
            f"Expected {args.expected_packages} kernel packages, found {len(packages)}"
        )

    if args.expected_name and (
        len(packages) != 1 or packages[0].name != args.expected_name
    ):
        raise SystemExit(
            f"Expected package {args.expected_name}, found "
            f"{', '.join(package.name for package in packages)}"
        )

    for package in packages:
        validate_package(package, args.expected_edition)

    print(f"Validated {len(packages)} kernel release packages")


if __name__ == "__main__":
    main()
