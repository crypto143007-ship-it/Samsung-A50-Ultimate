# Fork baseline

## Fork identity

- Repository: `crypto143007-ship-it/Samsung-A50-Ultimate`
- Default branch: `android-14.0`
- Baseline commit: `bec0c2aff1ee8a02ac9f582d60fe611f1d2bc939`
- Baseline subject: `HID: samsung: Bluetooth devices are a-OK too`
- Commit count reachable from baseline: 10,101

Evidence: [VERIFIED-STATIC] GitHub repository metadata and the fetched fork
history as inspected on 2026-11-01.

## Findings confirmed directly from the fork HEAD

| Area | Finding | Source evidence |
|---|---|---|
| Kernel release | Linux 4.14.194, `Petit Gorille` | `Makefile` (`VERSION = 4`, `PATCHLEVEL = 14`, `SUBLEVEL = 194`, `NAME = Petit Gorille`) |
| Device build data | `a50`, board `SRPRL05B007KU`, base `0x10000000`, page size 2048, header version 1 | `Documentation/device-db/a50.sh` |
| KernelSU source | `.gitmodules` declares `KernelSU` from `https://github.com/rsuntk/KernelSU.git`; pinned gitlink is `32548de0179fb1b075c87f5ff19751ea6db12f25` | `.gitmodules`, git tree entry `KernelSU` |
| KernelSU driver path | `drivers/kernelsu` is a symlink (mode `120000`) | Git tree entry; target text still to be recorded |
| KSU core hooks | `CONFIG_KSU` guards appear in `fs/exec.c`, `fs/open.c`, `fs/read_write.c`, `fs/stat.c`, `drivers/input/input.c`; KSU build entry appears in `drivers/Makefile` | `git grep CONFIG_KSU` at baseline |
| Core defconfig | default I/O scheduler `cfq`, TCP congestion `westwood`, zram default `lz4`, ARM64 crypto disabled, KPROBES disabled | `arch/arm64/configs/exynos9610-a50_core_defconfig` |
| MGLRU | No `CONFIG_LRU_GEN` in the core defconfig; no `lru_gen` matches in `mm/vmscan.c` | Core defconfig and `mm/vmscan.c` |
| Android config fragments | A50 fragments found for Mali and partial-deknox Android 11 and 12; no corresponding 13/14 fragments found in `kernel/configs/` | `kernel/configs/mint_mali-11.config`, `mint_mali-12.config`, `mint_partial-deknox-11.config`, `mint_partial-deknox-12.config` |
| SELinux / cmdline | `CONFIG_SECURITY_SELINUX_DEVELOP=y`; embedded `CONFIG_CMDLINE` contains `rcu_nocbs=0-3 noirqdebug nosoftlockup mce=ignore_ce cgroup_disable=pressure`; `build.sh` passes `androidboot.selinux=permissive` to `mkbootimg` | Core defconfig and `build.sh` |
| Toolchain | Defaults to `proton`; existing toolchain directory is updated with `git pull`; missing toolchain is cloned from a moving branch | `build.sh` |
| Submodule build dependency | `build.sh` runs `git submodule update --init "$TOP/KernelSU"`; driver Kconfig directly sources the symlinked path | `build.sh`, `drivers/Kconfig`, `drivers/kernelsu` |
| Existing workflows | `development.yml`, `galaxy-a50.yml`, and `kernelsu.yml` exist | `.github/workflows/` |
| Packaging / runtime SELinux | The build script's boot-image path explicitly sets a permissive SELinux cmdline. Whether that value reaches the shipped AnyKernel package at runtime is not established yet. | `build.sh`; inspect package repacking path before runtime claims |

All findings in this table are [VERIFIED-STATIC].

## Comparisons not yet complete

- [PROPOSED] Compare this fork HEAD with Mint tag `xbeta-1413_a50dx`, including
  Android 13/14 subconfigs, workflow changes, and KernelSU pin/wiring.
- [PROPOSED] Compare Mint and SOVR v4.0 histories, exact tag commits, tree
  diffs, device support, selected Mali drivers, security settings, and runtime
  SELinux behavior.
- [PROPOSED] Verify whether SOVR v4.0 has shared ancestry with Mint and whether
  the two SOVR repository names refer to mirrors or independent histories.
- [PROPOSED] Verify the contents of the fork's KernelSU gitlink against the
  official KernelSU-Next tag; the current source path is not official
  KernelSU-Next.

The Windows checkout is sparse because Git cannot materialize the three
reserved NTFS `aux` filenames in the source tree. Source inspection is being
performed through the full Git object database and read-only bare reference
clones; builds must run on Linux.
