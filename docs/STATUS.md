# UPA50 status

## NEXT ACTIONS

- **Current gate:** Rerun the baseline Standard build/package validation with
  the verified Proton toolchain.
- **Build policy:** All toolchain fetches, configuration, builds, validation,
  packaging, and release work run in GitHub Actions only.
- **Last good commit:** `8abb1be55` (static checks and Standard config passed).
- **Last passing gates:** Static checks and Standard config in [UPA50 CI
  41276281224](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41276281224).
  Compilation produced an Image and ZIP, but package-name validation failed
  because the build job did not set the UPA50 edition/version environment.
- **Last failing run:** [UPA50 CI 41276281224](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41276281224),
  `UPA50-*.zip` was absent; build.sh emitted the legacy MintBeta filename.
  Corrected the missing edition/version environment and prevented the
  Standard job from fetching the legacy KernelSU submodule.
- **Exact next commands:** Push the package-environment and Standard
  submodule-isolation fix; inspect
  `gh run list --repo crypto143007-ship-it/Samsung-A50-Ultimate --workflow upa50-ci.yml --limit 5`
  and review failures with `gh run view <id> --log-failed`.

## Engineering gates

| Gate | Status | Evidence |
|---|---|---|
| Strategy A vs. B baseline decision | Selected, static only | `[VERIFIED-STATIC]` Mint/fork source lineage; no comparative CI build |
| Baseline Standard build | In progress | `[VERIFIED-BUILD]` compile completed in [run 41276281224](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41276281224), but package validation failed; no artifact was uploaded |
| Official KernelSU-Next overlay and Standard purity | Not started | No source overlay or purity result |
| Config optimizations | Not started | No config changes |
| SOVR feature ports | Not started | No imported kernel patches |
| Three profiles | Not started | No profile implementation |
| Package and validated release | Not started | No UPA50 artifact, tag, or release |
| Physical-device verification | Not started | No A50 test results |

No validated build artifact, release, or physical-device result is claimed.
