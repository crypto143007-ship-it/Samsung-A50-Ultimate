#!/usr/bin/env bash
set -euo pipefail

readonly PROTON_REPOSITORY="https://gitlab.com/TenSeventy7/exynos9610_toolchains_fresh.git"
readonly AOSP_REPOSITORY="https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86.git"
readonly PROTON_COMMIT="32074ae4fc8e2269569fdff26a22da037388c3e3"
readonly AOSP_COMMIT="425c8149f17c8d9914bf690b4d5abe45a13fb993"

fail() {
    printf 'prepare_toolchain: %s\n' "$*" >&2
    exit 1
}

if [[ "${GITHUB_ACTIONS:-}" != "true" || "${RUNNER_OS:-}" != "Linux" ]]; then
    fail "toolchains may only be prepared on a Linux GitHub Actions runner"
fi
if [[ "$(lsb_release -rs)" != "22.04" ]]; then
    fail "Ubuntu 22.04 is required"
fi

mode="${1:-}"
kind="${2:-}"
[[ "$mode" == "record" || "$mode" == "verify" ]] || fail "usage: $0 record|verify proton|aosp"
[[ "$kind" == "proton" || "$kind" == "aosp" ]] || fail "usage: $0 record|verify proton|aosp"
[[ -f toolchain.lock ]] || fail "toolchain.lock is missing"

if [[ "$kind" == "proton" ]]; then
    repository="$PROTON_REPOSITORY"
    branch="proton"
    commit="$PROTON_COMMIT"
    sparse_path=""
else
    repository="$AOSP_REPOSITORY"
    branch="android14-release"
    commit="$AOSP_COMMIT"
    sparse_path="clang-r487747c"
fi

lock_value() {
    local key="$1"
    local value
    value="$(awk -F= -v key="$key" '$1 == key { sub(/^[^=]*=/, ""); print; found=1 } END { if (!found) exit 1 }' toolchain.lock)" ||
        fail "missing $key in toolchain.lock"
    printf '%s' "$value"
}

locked_commit="$(lock_value "$kind.commit")"
[[ "$locked_commit" == "$commit" ]] || fail "$kind commit in toolchain.lock differs from the pinned commit"

remote_commit="$(git ls-remote "$repository" "refs/heads/$branch" | awk 'NR == 1 { print $1 }')"
[[ "$remote_commit" == "$commit" ]] ||
    fail "$kind branch $branch resolves to ${remote_commit:-no commit}, expected $commit"

source_root="${RUNNER_TEMP:?RUNNER_TEMP must be set}/upa50-toolchain-sources"
repo_dir="$source_root/$kind"
toolchains_root="${RUNNER_TEMP}/upa50-toolchains"
toolchain_root="$toolchains_root/$kind"
mkdir -p "$source_root" "$toolchains_root"

if ! git -C "$repo_dir" rev-parse --git-dir >/dev/null 2>&1; then
    mkdir -p "$repo_dir"
    git -C "$repo_dir" init
    git -C "$repo_dir" remote add origin "$repository"
fi

[[ "$(git -C "$repo_dir" remote get-url origin)" == "$repository" ]] ||
    fail "cached $kind repository has an unexpected origin"

if [[ -n "$sparse_path" ]]; then
    git -C "$repo_dir" sparse-checkout init --cone
    git -C "$repo_dir" sparse-checkout set "$sparse_path"
fi

git -C "$repo_dir" fetch --filter=blob:none --depth=1 origin "$commit"
git -C "$repo_dir" checkout --detach "$commit"
actual_commit="$(git -C "$repo_dir" rev-parse HEAD)"
[[ "$actual_commit" == "$commit" ]] || fail "$kind checkout resolved to $actual_commit, expected $commit"

rm -rf "$toolchain_root"
mkdir -p "$toolchain_root"
if [[ -n "$sparse_path" ]]; then
    git -C "$repo_dir" archive "$commit" "$sparse_path" | tar -x -C "$toolchain_root"
    toolchain_dir="$toolchain_root/$sparse_path"
else
    git -C "$repo_dir" archive "$commit" | tar -x -C "$toolchain_root"
    toolchain_dir="$toolchain_root"
fi

[[ -x "$toolchain_dir/bin/clang" ]] || fail "$kind clang binary is missing"
[[ -x "$toolchain_dir/bin/ld.lld" ]] || fail "$kind ld.lld binary is missing"

manifest_sha256="$(
    cd "$toolchain_dir"
    find . -type f -print0 |
        sort -z |
        xargs -0 sha256sum |
        sha256sum |
        awk '{ print $1 }'
)"
clang_version="$("$toolchain_dir/bin/clang" --version | head -n 1)"
ld_lld_version="$("$toolchain_dir/bin/ld.lld" --version | head -n 1)"

if [[ "$mode" == "verify" ]]; then
    for key in manifest_sha256 clang_version ld_lld_version; do
        expected="$(lock_value "$kind.$key")"
        [[ "$expected" != "RECORD_IN_CI" ]] || fail "$kind.$key has not been recorded from CI"
        actual="${!key}"
        [[ "$actual" == "$expected" ]] ||
            fail "$kind $key mismatch: lock has '$expected', runner has '$actual'"
    done
else
    [[ -n "${GITHUB_WORKSPACE:-}" ]] || fail "GITHUB_WORKSPACE must be set in record mode"
    generated_lock="$GITHUB_WORKSPACE/toolchain.lock.generated"
    [[ -f "$generated_lock" ]] || fail "create toolchain.lock.generated before recording"
    {
        printf '%s.commit=%s\n' "$kind" "$actual_commit"
        printf '%s.manifest_sha256=%s\n' "$kind" "$manifest_sha256"
        printf '%s.clang_version=%s\n' "$kind" "$clang_version"
        printf '%s.ld_lld_version=%s\n' "$kind" "$ld_lld_version"
    } >> "$generated_lock"
fi

{
    printf 'Toolchain: %s\n' "$kind"
    printf 'Repository: %s\n' "$repository"
    printf 'Branch: %s\n' "$branch"
    printf 'Commit: %s\n' "$actual_commit"
    printf 'Manifest SHA256: %s\n' "$manifest_sha256"
    printf 'clang: %s\n' "$clang_version"
    printf 'ld.lld: %s\n\n' "$ld_lld_version"
} >> "${UPA50_BUILD_INFO:-BUILD_INFO.txt}"

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    printf 'toolchain_dir=%s\n' "$toolchain_dir" >> "$GITHUB_OUTPUT"
    printf 'toolchain_kind=%s\n' "$kind" >> "$GITHUB_OUTPUT"
fi
