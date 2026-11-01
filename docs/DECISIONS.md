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

## Base-kernel decision

- **Decision:** [VERIFIED-STATIC] Select **Strategy A: FreshROMs Mint 4.14.194, using the fork's exact `android-14.0` HEAD as the working baseline, with only individually reviewed and tested backports**. Do not merge SOVR wholesale. This is a conservative source/compatibility decision, not a claim that Strategy A has compiled or is device-validated.
- **Evidence:** [VERIFIED-STATIC] The fork's `android-14.0` HEAD is one commit after Mint tag `xbeta-1413_a50dx`, and direct `git merge-base` confirms that tag as its base. The sole delta is the A50 HID Bluetooth support change in `drivers/hid/hid-samsung.c`. SOVR v4.0 is a separate history with no merge base reported by GitHub compare, despite targeting the A50 and retaining Linux 4.14; its v4.0 and v4.1 tags use 4.14.357. These identity and configuration findings are documented in `docs/upstream-analysis/FORK_BASELINE.md` and `docs/upstream-analysis/SOVR_BASELINE.md`.
- **Rationale:** [VERIFIED-STATIC] Mint/fork has the strongest demonstrated lineage and exact-device baseline continuity. SOVR has useful static features (MGLRU, ZSTD zram, BBR default, and CAKE), but adopting its separately evolved tree would require broad boot-critical driver, DTS, Mali, security, and integration reconciliation. The Windows host cannot build locally and no comparative CI build evidence exists yet. Therefore, retain Mint as the integration base and assess any SOVR-origin capability as a discrete backport rather than taking the SOVR tree.
- **Not yet verified:** [PROPOSED] Neither Strategy A nor Strategy B has been configured and compiled using pinned Proton Clang 13 and AOSP Clang 17 toolchains on the actual tree. Comparative effort is not measured, boot/runtime compatibility is not device-tested, and the SOVR all-ref/full-history mirror could not be completed. Build and compatibility evidence may require revisiting this choice before kernel changes are accepted.
- **Withdrawn earlier note:** A prior bootstrap commit in the wrong empty repository favored SOVR without build evidence. That preference is explicitly withdrawn and is not part of this project decision.

## Edition and optional component policy

- **Decision:** SuSFS is not included by default. Standard must eventually exclude KSU/KernelSU-Next/SuSFS code and configuration; a separate KernelSU-Next edition must use the official upstream component.
- **Status:** [PROPOSED] No source changes have implemented this policy yet. Exact KSU integration, version, commit, and hooks remain to be verified against upstream source.

## Read-only upstream repository identity checks

- **SOVR canonical name:** [VERIFIED-STATIC] GitHub resolves `ruuiii-tk/SOVR-Kernel-A50` to `SOVR-Technologies/SOVR-Kernel-A50`. The latter reports `main` as its default branch and is not itself a fork.
- **SOVR release scope:** [VERIFIED-STATIC] Nine tags are visible; `v4.0` resolves to `98c776aae7ae2f41153e85d25a0f4336b1631316`, and the later `v4.1-final` tag resolves to `195b69f9b4e71f7e9ce409feb47aca253021a68e`. Both remain on Linux 4.14.357. Static findings and the incomplete history acquisition are recorded in `docs/upstream-analysis/SOVR_BASELINE.md`.
- **Mint release scope:** [VERIFIED-STATIC] `xbeta-1413_a50dx` is a lightweight tag at `7f72a8b689677562f028d78b2e91bd79277a0aba`.
- **Official KernelSU-Next tags:** [VERIFIED-STATIC] The full mirror contains 8,985 commits and all visible refs. `v3.4.2` is the newest release tag and resolves to `4c706b5938665866ebe16944a481a7b91e3396af`; its Kconfig was inspected. SOVR v4.0's in-tree integration and updater script were inspected, but equivalence of its vendored code to an exact official commit remains unverified.

## KernelSU-Next hook compatibility is unresolved

- **Evidence:** [VERIFIED-STATIC] Official tag `v3.4.2` has `CONFIG_KSU` depend on `KPROBES && EXT4_FS`, with `default y`; its Kconfig and hook sources use kprobes. The Mint A50 core defconfig explicitly disables `CONFIG_KPROBES`. The inspected official tag does not define `CONFIG_KSU_MANUAL_HOOK`.
- **Decision:** [PROPOSED] Do not enable or integrate KernelSU-Next until its exact non-GKI Linux 4.14 support, hook requirements, and impact of enabling KPROBES are reviewed against the A50 tree and a real build.
- **Rejected shortcut:** Copying SOVR's reported manual-hook configuration into official v3.4.2 without verifying that the symbol and implementation exist in that official tag.

## Master prompt and continuation scope

- [VERIFIED-STATIC] The owner attached and supplied the full 441-line master
  specification in this continuation. It is the governing project
  specification; use Section 19 for the final blocked/completion report and
  Section 18 for acceptance criteria.
- [VERIFIED-STATIC] This work remains in the specified existing fork as
  explicitly directed by the continuation, rather than creating a second
  repository. No permission or branch-protection bypass is attempted.
