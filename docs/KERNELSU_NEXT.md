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

[PROPOSED] The next compatibility patch releases the current task's filter
reference with the baseline `put_seccomp_filter()` helper before clearing the
filter pointer, and removes only the unsupported counter reset. It is not
build-verified yet. No KernelSU-Next build or device functionality is verified.
