# UPA50 status

## NEXT ACTIONS

- **Current gate:** Rebuild and validate the clean Standard package with its
  required root-state manifest marker.
- **Build policy:** All toolchain fetches, configuration, builds, validation,
  packaging, and release work run in GitHub Actions only.
- **Last good commit:** `1a4408128` (static checks and clean Standard config
  passed).
- **Last passing gates:** Static checks, Standard config, and clean-source
  compilation in [UPA50 CI
  41279169551](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41279169551).
- **Last failing run:** [UPA50 CI 41279169551](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41279169551),
  the clean Standard kernel compiled and ZIP was generated, but validation
  rejected `mint.prop` because it lacked `ro.mint.build.ksu=false`. The
  manifest-only correction is prepared.
- **Exact next commands:** Push the manifest correction; inspect
  `gh run list --repo crypto143007-ship-it/Samsung-A50-Ultimate --workflow upa50-ci.yml --limit 5`
  and review failures with `gh run view <id> --log-failed`.

## Engineering gates

| Gate | Status | Evidence |
|---|---|---|
| Strategy A vs. B baseline decision | Selected, static only | `[VERIFIED-STATIC]` Mint/fork source lineage; no comparative CI build |
| Baseline Standard build | In progress | `[VERIFIED-BUILD]` clean-source Proton Clang 13.0.0 compile and UPA50 ZIP generation in [run 41279169551](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41279169551); validator rejected missing `ro.mint.build.ksu=false`, so no artifact was uploaded |
| Official KernelSU-Next overlay and Standard purity | In progress | `[VERIFIED-STATIC]` legacy integration removal committed as `d6412f1d6` and clean-source scan passed in [run 41279169551](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41279169551); config/binary purity awaits a validated artifact; official overlay not yet integrated |
| Config optimizations | Not started | No config changes |
| SOVR feature ports | Not started | No imported kernel patches |
| Three profiles | Not started | No profile implementation |
| Package and validated release | Not started | No UPA50 artifact, tag, or release |
| Physical-device verification | Not started | No A50 test results |

No validated build artifact, release, or physical-device result is claimed.
