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

[VERIFIED-BUILD] Standard configuration and binary purity passed in [UPA50 CI
41280660290](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41280660290).
[PROPOSED] The v3.0.0 edition build and configuration checks are pending CI.
No KernelSU-Next build or device functionality is yet verified.
