# KernelSU-Next

[VERIFIED-STATIC] The KernelSU-Next edition is pinned to the official
[`KernelSU-Next/KernelSU-Next`](https://github.com/KernelSU-Next/KernelSU-Next)
`v3.0.0` release at commit `be141d05d03f37f67ae1505dbbe56cadbfcad130`.
The tag resolves to that commit; `tiann/KernelSU-Next` is not the correct
repository path.

[VERIFIED-BUILD] The initial v3.4.2 CI build failed because that release
expects `syscall_fn_t` and a regs-based ARM64 syscall-table ABI absent from the
4.14.194 baseline. A typedef-only workaround would compile against an
incompatible calling convention, so it was rejected.

[VERIFIED-STATIC] v3.0.0 uses syscall tracepoints; ARM64 selects
`HAVE_SYSCALL_TRACEPOINTS`, and both A50 defconfigs enable it. Its Kconfig
requires KPROBES, which `build.sh` enables only for this edition. The v3.0.0
tree has no SuSFS paths. CI fetches the locked tag and
`.github/scripts/setup-kernelsu-next.sh` verifies the commit before applying
the temporary driver Kconfig/Makefile overlay.

[VERIFIED-BUILD] The Standard build passed in [UPA50 CI
41286220636](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41286220636).
The KernelSU-Next v3.0.0 build reached `drivers/kernelsu/allowlist.c` but failed
on the newer `TWA_RESUME` argument and missing `put_task_struct` declaration,
which are not present in the Linux 4.14.194 APIs as used by this source.

[VERIFIED-BUILD] In the rebuild [UPA50 CI
41287769468](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41287769468),
the task-work patch compiled, and the build advanced to
`drivers/kernelsu/app_profile.c`. It then failed because the 4.14 seccomp
structure has no `filter_count` member.

[VERIFIED-BUILD] In [UPA50 CI
41288696197](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41288696197),
the seccomp compatibility change compiled and the build advanced to
`drivers/kernelsu/sucompat.c`. It then failed because Linux 4.14 has no
`linux/pgtable.h`.

[VERIFIED-BUILD] In [UPA50 CI
41289938397](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41289938397),
the build passed the missing-include failure and then stopped because
`strncpy_from_user_nofault` is not available in Linux 4.14.

[VERIFIED-BUILD] In [UPA50 CI
41291229799](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41291229799),
the no-fault compatibility code compiled in `sucompat.c`; compilation then
failed in `syscall_hook_manager.c` on the same no-fault helper and
`untagged_addr` declaration.

[VERIFIED-BUILD] The shared-helper follow-up in [UPA50 CI
41293315969](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41293315969)
failed because the patch's `util.h` hunk omitted the helper's closing brace.

[VERIFIED-BUILD] In [UPA50 CI
41294391104](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41294391104),
the corrected helper passed compilation, then the build failed in
`pkg_observer.c` because Linux 4.14 has the older fsnotify callback and inode
mark APIs.

[PROPOSED] The overlay removes the unused `linux/pgtable.h` include (the file
uses no page-table identifiers and `linux/mm.h` includes `asm/pgtable.h`). It
places the no-fault user-copy wrapper in shared `util.h`, using 4.14's
`pagefault_disable()` / `pagefault_enable()` around `strncpy_from_user()`, and
exposes ARM64's `untagged_addr` via `linux/uaccess.h`. The hunk count is
corrected. The observer overlay now adapts its callback signature, filename
handling and inode-mark call to the 4.14 interfaces. These changes remain
pending CI. No KernelSU-Next build or device functionality is verified.
