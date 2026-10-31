# UPA50 engineering decisions

## Repository correction and branch strategy

- **Decision:** Use `crypto143007-ship-it/Samsung-A50-Ultimate` as the sole project repository and preserve its existing `android-14.0` branch as the fork baseline. Perform UPA50 work on `upa50/main`.
- **Evidence:** [VERIFIED-STATIC] The initial worktree pointed at `crypto143007-ship-it/Ultimate-Performance-A50`, an empty unrelated repository with one local scaffold commit, no kernel tree, and no default branch. The specified fork reports default branch `android-14.0`, HEAD `bec0c2aff1ee8a02ac9f582d60fe611f1d2bc939`, and 10,101 commits. The corrected `origin` points at the specified fork; `upa50/main` is based on the fetched fork branch.
- **Fork ancestry:** [VERIFIED-STATIC] GitHub API identifies `FreshROMs/android_kernel_samsung_exynos9610_mint` as both the fork's parent and source repository.
- **Rejected alternative:** Continue development on the empty repository. This would create a second project and discard the kernel source/history required by the specification.
- **History safety:** [VERIFIED-STATIC] No force-push or rewrite was made to the existing `android-14.0` branch.

## Windows checkout limitation

- **Decision:** Do not build on native Windows. Use GitHub Actions on Ubuntu 22.04 unless WSL2 becomes available.
- **Evidence:** [VERIFIED-STATIC] `wsl -l -v` reported `WSL_E_WSL_OPTIONAL_COMPONENT_REQUIRED`. The Windows worktree cannot materialize the full source because Git rejects reserved Windows filenames present upstream (`drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c`, `aux.h`, and `include/soc/arc/aux.h`). Git's object database contains the source; the sparse checkout is limited to documentation/workflow paths.
- **Rejected alternative:** Attempt a native Windows kernel build or alter source paths to work around NTFS. Neither is supported or justified.

## Base-kernel decision remains open

- **Decision:** Do not select Mint or SOVR as the UPA50 base yet.
- **Evidence:** [VERIFIED-STATIC] The actual fork baseline Makefile declares Linux 4.14.194, `Petit Gorille`. This confirms one Mint baseline claim, but it does not establish comparative configuration, buildability, or source compatibility with SOVR v4.0. Full-history upstream clones and a comparative build matrix are still in progress; WSL2 is unavailable.
- **Required comparison:** Strategy A (Mint plus reviewed backports) and Strategy B (SOVR v4.0 plus selected Mint-side changes) must be assessed against source diffs, configuration, toolchain build evidence, and boot-critical Exynos consistency before selection.
- **Withdrawn earlier note:** A prior bootstrap commit in the wrong empty repository favored SOVR without build evidence. That preference is explicitly withdrawn and is not part of this project decision.

## Edition and optional component policy

- **Decision:** SuSFS is not included by default. Standard must eventually exclude KSU/KernelSU-Next/SuSFS code and configuration; a separate KernelSU-Next edition must use the official upstream component.
- **Status:** [PROPOSED] No source changes have implemented this policy yet. Exact KSU integration, version, commit, and hooks remain to be verified against upstream source.

## Read-only upstream repository identity checks

- **SOVR canonical name:** [VERIFIED-STATIC] GitHub resolves `ruuiii-tk/SOVR-Kernel-A50` to `SOVR-Technologies/SOVR-Kernel-A50`. The latter reports `main` as its default branch and is not itself a fork.
- **Official KernelSU-Next tags:** [VERIFIED-STATIC] The GitHub tags endpoint currently lists `v3.4.2` as the newest release tag; its commit is `4c706b5938665866ebe16944a481a7b91e3396af`. The full-history clone is still required to check tag contents and vendor-copy equivalence.
