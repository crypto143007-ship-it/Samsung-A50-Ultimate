# Fork baseline

## Fork identity

- [VERIFIED-STATIC] Repository: `crypto143007-ship-it/Samsung-A50-Ultimate`
- [VERIFIED-STATIC] Default branch: `android-14.0`
- [VERIFIED-STATIC] Baseline commit: `bec0c2aff1ee8a02ac9f582d60fe611f1d2bc939`
- [VERIFIED-STATIC] Baseline subject: `HID: samsung: Bluetooth devices are a-OK too`
- [VERIFIED-STATIC] Commit count reachable from baseline: 10,101

Evidence: [VERIFIED-STATIC] GitHub repository metadata and the fetched fork
history as inspected on 2026-11-01.

## Upstream tag identities

- [VERIFIED-STATIC] Mint tag `xbeta-1413_a50dx` is a lightweight tag at
  `7f72a8b689677562f028d78b2e91bd79277a0aba`.
- [VERIFIED-STATIC] SOVR tag `v4.0` resolves to commit
  `98c776aae7ae2f41153e85d25a0f4336b1631316`.
- [VERIFIED-STATIC] SOVR also publishes a later `v4.1-final` tag, so `v4.0`
  is not its newest visible release. This later tag must be inspected before
  making the base-kernel decision.
- [VERIFIED-STATIC] The GitHub API resolves `ruuiii-tk/SOVR-Kernel-A50` to
  `SOVR-Technologies/SOVR-Kernel-A50`; both URL checks return that canonical
  repository.

## Fork delta from Mint tag

[VERIFIED-STATIC] GitHub's compare API and a direct `git merge-base` check
report that fork HEAD is one commit after `xbeta-1413_a50dx`, with the Mint
tag as the merge base. The exact
one-file delta is:

- `drivers/hid/hid-samsung.c`: allow `BUS_BLUETOOTH` as well as USB in
  `samsung_probe()` (`if (!(hid_is_usb(hdev) || hdev->bus == BUS_BLUETOOTH))`).

No other file changes are reported between the two refs. The fork HEAD commit
is `bec0c2aff1ee8a02ac9f582d60fe611f1d2bc939`; the tag commit is
`7f72a8b689677562f028d78b2e91bd79277a0aba`.

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
| Existing workflows | `development.yml`, `galaxy-a50.yml`, and `kernelsu.yml` exist; the first two have release jobs | `.github/workflows/` |
| Packaging / runtime SELinux | The standalone boot-image path passes a permissive cmdline; the ZIP instead installs `Image`, DTB, and ramdisk through AnyKernel's `split_boot` / `process_ramdisk` / `flash_boot` path and does not add that cmdline. The ZIP runtime mode remains unverified. | `build.sh`, `tools/make/package/anykernel.sh`, `tools/make/package/tools/ak3-core.sh` |

All findings in this table are [VERIFIED-STATIC].

At the fork baseline, the two release jobs do not validate ZIP contents before
publishing. The current UPA50 branch adds fail-closed validation gates; see
`docs/MODIFICATIONS.md`. The requested `release-kernel.yml` does not exist in
the fork baseline.

## Mint tag verification

[VERIFIED-STATIC] A read-only bare mirror of Mint was acquired with
`--filter=tree:0`; it contains 19,847 commits across 17 branches and 134 tags.
The commit graph and all refs are present; trees/blobs are fetched lazily for
the inspected tag. Tag `xbeta-1413_a50dx` resolves to
`7f72a8b689677562f028d78b2e91bd79277a0aba`.

Direct tag inspection confirms:

- The core defconfig has `CONFIG_ZRAM_DEF_COMP="lz4"`,
  `CONFIG_DEFAULT_TCP_CONG="westwood"`, and `CONFIG_DEFAULT_IOSCHED="cfq"`.
  No config overlay overrides `DEFAULT_IOSCHED`.
- `CONFIG_PSI=y`, `CONFIG_LTO_CLANG=y`, `CONFIG_PREEMPT=y`, and `CONFIG_HZ_300=y`;
  `CONFIG_ARM64_CRYPTO` is not set.
- `CONFIG_LRU_GEN` and `lru_gen` are absent from the defconfig and
  `mm/vmscan.c`. `fs/dyn_fsync.c` and `net/sched/sch_cake.c` are absent.
- Mali overlays select `MALI_BIFROST_R26P0_R` for Android 11 and
  `MALI_BIFROST_R38P1` for Android 12.
- The Android 11 and 12 `partial-deknox` overlays enable FIVE and SDP.
  The core defconfig disables UH, SECURITY_DEFEX, and PROCA. This is partial
  de-Knox, not a general removal of all Samsung security components.
- The build script accepts Android version 13 at argument parsing but has no
  Android 13 `mali` or `partial-deknox` fragment; values above 13 are changed
  to 12. Thus 13 is not a usable build variant with these fragments, and 14
  is not supported by this tag's script.
- `build.sh` passes `androidboot.selinux=permissive` to its standalone
  `boot.img` build. The flashable ZIP instead includes `Image`, DTB, and
  ramdisk; `anykernel.sh` calls `split_boot`, `process_ramdisk`, and
  `flash_boot` against the device's existing boot image and does not add that
  SELinux cmdline. The ZIP runtime SELinux mode is therefore not established
  by the standalone `boot.img` argument and remains unverified.
- The package contains third-party prebuilt tools (including `busybox`,
  `magiskboot`, `magiskpolicy`, `lptools_static`, `snapshotupdater_static`,
  `dtc`, `lz4`, `mboot`, and `mkbootimg`); their individual provenance and
  licenses still need review.

## Comparisons not yet complete

- [VERIFIED-STATIC] The fork-vs-tag commit comparison is complete: one commit
  ahead and one changed line in `drivers/hid/hid-samsung.c`. Configuration,
  workflow, and KernelSU inventory are listed above; direct Git object
  comparison confirms the tag is the merge base.
- [VERIFIED-STATIC] The SOVR v4.0 tag, later v4.1-final tag, and the two
  repository aliases were checked. GitHub's compare API reports no merge base
  between SOVR v4.0 and the Mint tag. Partial configuration, KernelSU/SuSFS,
  SELinux, and workflow findings are in `SOVR_BASELINE.md`.
- [PROPOSED] Complete a broad tree/device-support comparison and verify
  boot-critical Exynos/Mali consistency. The SOVR full-history mirror was
  blocked; the available tag snapshots do not establish complete ancestry or
  source-diff evidence.
- [PROPOSED] Verify the contents of the fork's KernelSU gitlink against the
  official KernelSU-Next tag; the current source path is not official
  KernelSU-Next.

The Windows checkout is sparse because Git cannot materialize the three
reserved NTFS `aux` filenames in the source tree. Source inspection is being
performed through the full Git object database and read-only bare reference
clones; builds must run on Linux.
