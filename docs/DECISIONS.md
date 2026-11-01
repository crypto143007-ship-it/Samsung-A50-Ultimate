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
  and root/permissive config fragments. Commit `d6412f1d6` removes these
  legacy hooks and fragments from the Standard base. The official
  KernelSU-Next overlay remains a separate, not-yet-integrated edition.
- **Clean-source Standard build:** `[VERIFIED-BUILD]` [Run
  41279169551](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41279169551)
  passed static checks and Standard config generation, compiled the clean
  base with Proton Clang 13.0.0, and produced
  `UPA50-standard-oneui-A12-v0.0.0.zip`. Validation correctly rejected the
  package because `mint.prop` omitted the required
  `ro.mint.build.ksu=false` marker; no artifact was uploaded. Keep this
  manifest metadata for Standard without restoring any KSU code or config.
- **KernelSU-Next integration audit:** `[VERIFIED-STATIC]` The selected source
  is from `https://github.com/KernelSU-Next/KernelSU-Next` at `v3.0.0`,
  `be141d05d03f37f67ae1505dbbe56cadbfcad130`; the tag resolves to that commit.
  The earlier v3.4.2 pin was rejected after its build exposed an incompatible
  syscall-table ABI. At v3.0.0, `kernel/Kconfig` requires
  `KPROBES && EXT4_FS`; both A50 defconfigs have `CONFIG_KPROBES` unset and
  `CONFIG_EXT4_FS=y`. The CI-only overlay verifies the exact commit and
  enables KPROBES only for the KernelSU-Next edition.
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
  KernelSU-Next is limited to the separate edition and currently pinned to
  official `v3.0.0` commit `be141d05d03f37f67ae1505dbbe56cadbfcad130`.
  SuSFS is excluded. Exactly three profiles are planned; thermal, charging,
  and battery protections remain untouched.
- **Inherited workflows:** The former development, Galaxy A50, and KernelSU
  workflows were reduced to manual informational stubs in commit
  `8e3c1a9567b77f0932d91b3304cdcbe38adfb9a8`; they will be removed as the
  replacement workflows are introduced. They did not run UPA50 builds.

[VERIFIED-BUILD] Baseline Standard config, Proton Clang 13.0.0 compilation,
package validation, artifact upload, and config/binary purity passed in [UPA50
CI 41280660290](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41280660290).
The uploaded `standard-oneui-android-12` artifact bundle is 58,777,341 bytes
with upload digest
`066db25cd3ebda32d473e3088d9b9d49793ed9d6b992ca275ef3895a0df21eb3`. That is
the Actions artifact archive digest, not the kernel ZIP checksum; the ZIP's
individual checksum is present in `SHA256SUMS.txt` inside the artifact and has
not been retrieved locally.

[VERIFIED-STATIC] The pinned KernelSU-Next overlay is implemented in
`.github/scripts/setup-kernelsu-next.sh` with source identity recorded in
`kernelsu-next.lock`. It intentionally avoids the upstream `kernel/setup.sh`,
which fetches a moving branch.

- **KernelSU-Next compatibility decision:** `[VERIFIED-BUILD]` The initial
  v3.4.2 integration in [run
  41284747123](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41284747123)
  failed while compiling `drivers/kernelsu/core/init.c`: the pinned source
  references `syscall_fn_t`, which the Linux 4.14.194 ARM64 headers do not
  define. Static inspection also confirms that v3.4.2 expects the newer
  regs-based syscall-table ABI (`kernel/hook/syscall_hook.h` and
  `kernel/include/arch.h`), while this kernel's syscall table contains direct
  syscall entries (`arch/arm64/kernel/sys.c`). A type-only shim would leave an
  incompatible call convention, so it was not applied.
- **Replacement pin:** `[VERIFIED-STATIC]` Use official KernelSU-Next v3.0.0
  (`be141d05d03f37f67ae1505dbbe56cadbfcad130`) as the candidate: its
  `kernel/syscall_hook_manager.c` registers `sys_enter` tracepoints, the A50
  defconfigs enable `CONFIG_HAVE_SYSCALL_TRACEPOINTS`, and its Kconfig requires
  KPROBES. Its release tree contains no `susfs` paths. The actual 4.14 build
  is pending; this static compatibility evidence is not runtime/device
  validation.
- **Linux 4.14 allowlist compatibility:** `[VERIFIED-BUILD]` The v3.0.0 build
  in [run
  41286220636](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41286220636)
  reached `drivers/kernelsu/allowlist.c` and failed because the source passes
  the newer `TWA_RESUME` enum to `task_work_add` and lacks the header declaring
  `put_task_struct`. In the fork's 4.14 headers,
  `task_work_add(..., bool notify)` explicitly maps `true` to
  `set_notify_resume(task)`, and `put_task_struct` is declared in
  `include/linux/sched/task.h` (`origin/android-14.0`). The focused patch maps
  the notification to `true` and adds that include. `[VERIFIED-BUILD]` The
  follow-up [run
  41287769468](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41287769468)
  compiled past `allowlist.c` and failed later in `app_profile.c`.
- **Linux 4.14 seccomp compatibility:** `[VERIFIED-STATIC]` The follow-up
  build failed at `current->seccomp.filter_count`, which is absent from the
  fork's `include/linux/seccomp.h`; its `struct seccomp` has only `mode` and
  `filter`. The 4.14 API declares `put_seccomp_filter()` (with a no-op stub
  when seccomp filtering is disabled), and `kernel/seccomp.c` uses it to
  release the task's filter reference before replacing the filter pointer.
  The new compatibility patch calls this helper before clearing that pointer
  and removes the unsupported `filter_count` reset. `[VERIFIED-BUILD]` In [run
  41288696197](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41288696197),
  compilation advanced past `app_profile.c`, confirming the compatibility
  change compiles; the build later failed in `sucompat.c`.
- **Linux 4.14 page-table include compatibility:** `[VERIFIED-STATIC]` The
  v3.0.0 `kernel/sucompat.c` compile failed because it includes
  `linux/pgtable.h`, which does not exist in this 4.14 tree. Source inspection
  found no page-table identifiers used in that file beyond the include, and
  `include/linux/mm.h` already includes `asm/pgtable.h`. The compatibility
  patch removes only the unused include. `[VERIFIED-BUILD]` The next [run
  41289938397](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41289938397)
  compiled past the include and then failed on the next 4.14 mismatch.
- **Linux 4.14 no-fault user-string compatibility:** `[VERIFIED-STATIC]` The
  next failure was three references to `strncpy_from_user_nofault`, absent
  from this baseline. In 4.14, `strncpy_from_user()` is implemented through
  exception-table user access, and `pagefault_disable()` / `pagefault_enable()`
  are available. A shared compatibility helper brackets the copy with those
  calls to preserve no-fault behavior in the syscall hooks. `[VERIFIED-BUILD]`
  In [run
  41291229799](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41291229799),
  the helper compiled in `sucompat.c`; compilation then found equivalent
  references in `syscall_hook_manager.c`.
- **Linux 4.14 syscall-hook uaccess includes:** `[VERIFIED-STATIC]` The
  follow-up build reports implicit declarations of `untagged_addr` and
  `strncpy_from_user_nofault` in `syscall_hook_manager.c`. ARM64 4.14 defines
  `untagged_addr` in `asm/uaccess.h`, exposed via `linux/uaccess.h`; the
  no-fault function is provided by the shared compatibility helper. The patch
  updates both call sites and adds `linux/uaccess.h` through `util.h`; this
  awaits CI.
- **Shared no-fault helper patch correction:** `[VERIFIED-BUILD]` The
  follow-up [run
  41293315969](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41293315969)
  failed while compiling `sucompat.c`: the `util.h` patch hunk count omitted
  the helper's final closing brace. The helper is complete in the patch
  source; its hunk count was corrected. `[VERIFIED-BUILD]` The following [run
  41294391104](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41294391104)
  compiled past the shared helper and failed later in `pkg_observer.c`.
- **Linux 4.14 fsnotify compatibility:** `[VERIFIED-STATIC]` KernelSU-Next
  v3.0.0 uses `fsnotify_ops.handle_inode_event`, `fsnotify_add_inode_mark`,
  and a `qstr` filename argument. Linux 4.14 instead provides the
  `handle_event` callback with a filename byte string and
  `fsnotify_add_mark(mark, inode, mount, allow_dups)`. The compatibility
  overlay adapts the callback signature and safe exact filename comparison,
  and calls `fsnotify_add_mark(m, inode, NULL, 0)`, matching the baseline API.
  This awaits CI.

No physical-device test has been performed.
