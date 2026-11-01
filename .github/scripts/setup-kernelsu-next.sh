#!/usr/bin/env bash
set -euo pipefail

source kernelsu-next.lock
source_dir="${1:?KernelSU-Next source directory is required}"

mkdir -p "$source_dir"
if ! git -C "$source_dir" rev-parse --git-dir >/dev/null 2>&1; then
    git -C "$source_dir" init
    git -C "$source_dir" remote add origin "$repository"
else
    actual_remote="$(git -C "$source_dir" remote get-url origin)"
    if [[ "$actual_remote" != "$repository" ]]; then
        echo "Unexpected KernelSU-Next remote: $actual_remote" >&2
        exit 1
    fi
fi

if ! git -C "$source_dir" rev-parse --verify "$tag^{commit}" >/dev/null 2>&1; then
    git -C "$source_dir" fetch --no-tags --depth=1 --filter=blob:none origin \
        "refs/tags/$tag:refs/tags/$tag"
fi
tag_commit="$(git -C "$source_dir" rev-parse "$tag^{commit}")"
if [[ "$tag_commit" != "$commit" ]]; then
    echo "KernelSU-Next tag mismatch: expected $commit, got $tag_commit" >&2
    exit 1
fi
git -C "$source_dir" checkout --detach "$commit"
actual_commit="$(git -C "$source_dir" rev-parse HEAD)"
if [[ "$actual_commit" != "$commit" ]]; then
    echo "KernelSU-Next commit mismatch: expected $commit, got $actual_commit" >&2
    exit 1
fi
if [[ -f "$source_dir/.git/shallow" ]]; then
    git -C "$source_dir" fetch --unshallow --no-tags --filter=blob:none origin \
        "refs/tags/$tag"
fi

if [[ ! -f "$source_dir/kernel/Kconfig" || ! -f "$source_dir/kernel/Kbuild" ]]; then
    echo "Pinned KernelSU-Next kernel sources are incomplete" >&2
    exit 1
fi
if [[ -e drivers/kernelsu || -L drivers/kernelsu ]]; then
    echo "drivers/kernelsu already exists; refusing to replace it" >&2
    exit 1
fi

ln -s "$(realpath --relative-to="$PWD/drivers" "$source_dir/kernel")" drivers/kernelsu
if ! grep -Fqx 'source "drivers/kernelsu/Kconfig"' drivers/Kconfig; then
    sed -i '/^endmenu$/i source "drivers/kernelsu/Kconfig"' drivers/Kconfig
fi
if ! grep -Fqx 'obj-$(CONFIG_KSU) += kernelsu/' drivers/Makefile; then
    printf '\nobj-$(CONFIG_KSU) += kernelsu/\n' >> drivers/Makefile
fi

{
    printf 'KernelSU-Next tag: %s\n' "$tag"
    printf 'KernelSU-Next commit: %s\n' "$commit"
} >> BUILD_INFO.txt
