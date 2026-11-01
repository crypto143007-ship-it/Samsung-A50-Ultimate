# UPA50 status

## NEXT ACTIONS

- **Current gate:** Rerun the Standard configuration and build with the
  required Kconfig submodule present.
- **Build policy:** All toolchain fetches, configuration, builds, validation,
  packaging, and release work run in GitHub Actions only.
- **Last good commit:** `cd87d0086` (static checks passed).
- **Last passing gate:** Static checks in [UPA50 CI
  41278030173](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41278030173).
- **Last failing run:** [UPA50 CI 41278030173](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41278030173),
  config generation failed because `drivers/Kconfig` requires
  `drivers/kernelsu/Kconfig`. Standard must keep that source available to
  Kconfig while its generated config and binaries remain free of enabled KSU
  symbols; the submodule checkout has been restored.
- **Exact next commands:** Push the Kconfig-submodule correction; inspect
  `gh run list --repo crypto143007-ship-it/Samsung-A50-Ultimate --workflow upa50-ci.yml --limit 5`
  and review failures with `gh run view <id> --log-failed`.

## Engineering gates

| Gate | Status | Evidence |
|---|---|---|
| Strategy A vs. B baseline decision | Selected, static only | `[VERIFIED-STATIC]` Mint/fork source lineage; no comparative CI build |
| Baseline Standard build | In progress | `[VERIFIED-BUILD]` run [41276281224](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41276281224) compiled the image but failed package-name validation; run [41278030173](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41278030173) confirmed the Kconfig submodule is required |
| Official KernelSU-Next overlay and Standard purity | Not started | No source overlay or purity result |
| Config optimizations | Not started | No config changes |
| SOVR feature ports | Not started | No imported kernel patches |
| Three profiles | Not started | No profile implementation |
| Package and validated release | Not started | No UPA50 artifact, tag, or release |
| Physical-device verification | Not started | No A50 test results |

No validated build artifact, release, or physical-device result is claimed.
