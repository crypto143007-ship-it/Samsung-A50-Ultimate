# KernelSU-Next

[PROPOSED] The KernelSU-Next edition will use the official
[`KernelSU-Next/KernelSU-Next`](https://github.com/KernelSU-Next/KernelSU-Next)
`v3.4.2` release at commit `4c706b5938665866ebe16944a481a7b91e3396af`.
[VERIFIED-STATIC] The tag resolves directly to that commit. The path
`tiann/KernelSU-Next` does not resolve.

[VERIFIED-STATIC] At the pinned source, `kernel/Kconfig` requires
`KPROBES && EXT4_FS`. Both A50 defconfigs unset `CONFIG_KPROBES` and enable
`CONFIG_EXT4_FS`. The upstream setup script follows a moving repository, so
UPA50 will use a separate CI overlay at the exact pinned commit and enable
KPROBES only in the KernelSU-Next edition.

[PROPOSED] The Standard edition must contain no KernelSU, KernelSU-Next, or
SuSFS code or configuration. That purity requirement is not yet implemented
or verified.
