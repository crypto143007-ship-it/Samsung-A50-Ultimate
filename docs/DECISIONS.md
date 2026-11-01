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
