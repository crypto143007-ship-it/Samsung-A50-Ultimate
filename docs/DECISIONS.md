# UPA50 decisions

- **Repository and branch:** Work in `crypto143007-ship-it/Samsung-A50-Ultimate`
  on `upa50/main`; preserve the existing `android-14.0` history. No force-push
  or history rewrite is permitted on that branch.
- **Base kernel:** Select Strategy A, the fork's Mint-derived Linux 4.14.194
  source, as the conservative integration baseline. The fork baseline
  `bec0c2aff1ee8a02ac9f582d60fe611f1d2bc939` is one commit after Mint tag
  `xbeta-1413_a50dx` (`7f72a8b689677562f028d78b2e91bd79277a0aba`); its delta is
  the A50 Bluetooth HID change. SOVR v4.0 (`98c776aae7ae2f41153e85d25a0f4336b1631316`)
  is a separate 4.14.357 history. This source-lineage decision is
  `[VERIFIED-STATIC]`, not a build or device-compatibility result. Revisit only
  if measured CI or compatibility evidence warrants it.
- **Build host:** Use GitHub Actions on `ubuntu-22.04` only. This Windows host
  has no usable WSL2; do not download toolchains or build kernels locally.
- **Boot command line:** The inherited packaging script forced
  `androidboot.selinux=permissive` for every build. UPA50's default package
  command line is changed to `enforcing`; only the script's explicit
  permissive option changes this, and UPA50 workflows must not use it.
- **Toolchain integrity:** Toolchains are fetched in CI from the exact commits
  in `toolchain.lock`. The content manifest is first computed in CI from each
  pinned source commit (trust-on-first-use anchored to that Git commit); the
  resulting hashes and version strings must be committed before verify-mode
  builds can pass.
- **Compiler refs:** `[VERIFIED-STATIC]` `git ls-remote` confirmed Proton
  `proton` at `32074ae4fc8e2269569fdff26a22da037388c3e3` and AOSP
  `android14-release` at `425c8149f17c8d9914bf690b4d5abe45a13fb993`.
  Their content manifests and compiler version strings are awaiting the first
  Ubuntu 22.04 Actions record run.
- **First CI failure:** `[VERIFIED-STATIC]` The toolchain-lock run
  [41274212163](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41274212163)
  failed before fetching either toolchain because `prepare_toolchain.sh` was
  not executable in Git. The script mode is corrected; no compiler hash or
  build result was produced.
- **Toolchain record:** `[VERIFIED-STATIC]` CI run
  [41274569055](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41274569055)
  fetched both exact commits, generated directory manifests, and recorded
  Proton Clang 13.0.0 and AOSP Clang 17.0.2. The hashes and first-line version
  strings are stored in `toolchain.lock`; this verifies provenance, not kernel
  build compatibility.
- **Toolchain verification:** `[VERIFIED-STATIC]` CI run
  [41275135426](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41275135426)
  re-fetched both pinned refs and matched the committed manifests and version
  strings. This is not a kernel build result.
- **First baseline CI attempt:** `[VERIFIED-BUILD]` In [run
  41276281224](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41276281224),
  the Standard config generated successfully and the kernel `Image` and ZIP
  were produced with Proton Clang 13.0.0. The package step failed because the
  workflow omitted `UPA50_EDITION` and `UPA50_VERSION`, so `build.sh` emitted
  a legacy MintBeta filename and the expected UPA50 package could not be
  validated; no artifact was uploaded. The follow-up sets those environment
  values.
- **Standard config dependency:** `[VERIFIED-STATIC]` In [run
  41278030173](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41278030173),
  config generation failed with `drivers/Kconfig: can't open file
  "drivers/kernelsu/Kconfig"` after submodule checkout was disabled. That run
  confirmed the inherited reference must be removed, not worked around by
  restoring the legacy module.
- **Legacy KernelSU removal:** `[VERIFIED-STATIC]` The source audit found the
  rsuntk submodule at `KernelSU` (commit
  `32548de0179fb1b075c87f5ff19751ea6db12f25`), the `drivers/kernelsu` symlink,
  Kconfig/Makefile integration, five manual hooks in `fs/exec.c`,
  `fs/open.c`, `fs/read_write.c`, `fs/stat.c` and `drivers/input/input.c`,
  and root/permissive config fragments. These legacy hooks and fragments are
  being removed from the Standard base. The official KernelSU-Next overlay is
  a separate not-yet-integrated edition.
- **Legacy line endings:** `[VERIFIED-STATIC]` The first full-tree CI scan
  found CRLF in 56 pre-existing C/header/Makefile files. No kernel source
  content was changed. The required global auto-text LF rule and explicit
  shell-script LF rule remain. Static CI checks every tracked shell/config
  input and every changed source file rather than rewriting untouched
  upstream blobs.
- **Scoped line-ending check:** `[VERIFIED-STATIC]` The initial scoped retry
  included removed documentation paths and failed with `FileNotFoundError`.
  The diff now excludes deleted paths and the scan skips paths absent from the
  checkout.
- **Diff-format check:** `[VERIFIED-STATIC]` Explicit source-extension LF
  attributes caused Git to report virtual line-ending changes and historical
  trailing whitespace. Those extra patterns were removed; only the required
  global and shell rules remain, avoiding a mass kernel-source diff.
- **Editions and safety:** Standard excludes KernelSU/KernelSU-Next/SuSFS;
  KernelSU-Next is limited to the separate edition and pinned to official
  `v3.4.2` commit `4c706b5938665866ebe16944a481a7b91e3396af`. SuSFS is excluded.
  Exactly three profiles are planned; thermal, charging, and battery
  protections remain untouched.
- **Inherited workflows:** The former development, Galaxy A50, and KernelSU
  workflows were reduced to manual informational stubs in commit
  `8e3c1a9567b77f0932d91b3304cdcbe38adfb9a8`; they will be removed as the
  replacement workflows are introduced. They did not run UPA50 builds.

No toolchain manifest has yet been recorded, no kernel CI build has run, and
no physical-device test has been performed.
