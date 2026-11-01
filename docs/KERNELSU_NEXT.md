# KernelSU-Next

[VERIFIED-STATIC] The KernelSU-Next edition is pinned to the official
[`KernelSU-Next/KernelSU-Next`](https://github.com/KernelSU-Next/KernelSU-Next)
`v3.4.2` release at commit `4c706b5938665866ebe16944a481a7b91e3396af`.
The tag resolves to that commit; `tiann/KernelSU-Next` is not the correct
repository path.

[VERIFIED-STATIC] At the pinned source, `kernel/Kconfig` requires
`KPROBES && EXT4_FS`. Both A50 defconfigs unset `CONFIG_KPROBES` and enable
`CONFIG_EXT4_FS`. The upstream setup script follows a moving repository, so
CI fetches the locked commit and `.github/scripts/setup-kernelsu-next.sh`
verifies it before applying a temporary driver Kconfig/Makefile overlay.
`build.sh` enables KPROBES only for the KernelSU-Next edition.

[VERIFIED-STATIC] This upstream tag also contains a separate `kernel/susfs/`
module. Its pinned in-tree `kernel/Kbuild` does not reference that module.
CI checks the KSU-edition configuration and compiled artifacts to keep SuSFS
disabled and absent from the kernel image.

[VERIFIED-BUILD] Standard configuration and binary purity passed in [UPA50 CI
41280660290](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41280660290).
[PROPOSED] The separate KernelSU-Next build and configuration checks have not
yet run. SuSFS remains excluded from both editions.
