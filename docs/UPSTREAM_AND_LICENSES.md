# Upstream sources and licenses

## Kernel sources

| Source | Reference | Evidence |
|---|---|---|
| Fork baseline | `android-14.0`, `bec0c2aff1ee8a02ac9f582d60fe611f1d2bc939` | `[VERIFIED-STATIC]` |
| FreshROMs Mint | `xbeta-1413_a50dx`, `7f72a8b689677562f028d78b2e91bd79277a0aba` | `[VERIFIED-STATIC]` |
| SOVR | `v4.0`, `98c776aae7ae2f41153e85d25a0f4336b1631316` | `[VERIFIED-STATIC]` |
| KernelSU-Next | `v3.4.2`, `4c706b5938665866ebe16944a481a7b91e3396af` | Tag resolves to stated commit; not integrated |

The fork is Mint-derived Linux 4.14.194; SOVR v4.0 is a separate Linux
4.14.357 history. No kernel patches have been imported for UPA50. Any future
import must preserve original authorship and record its source repository,
commit, subject, and license here.

## Licenses and packaged components

Kernel-source licensing and notices are retained in the tree; see `COPYING`
and source headers. `build.sh` has its own GPL-3.0-or-later notice and must
retain it. No UPA50 binary has been distributed. AnyKernel or other
third-party package components have not yet been audited; record each
component's source, version, license, and checksum before distribution.
