# UPA50 status

## NEXT ACTIONS

- **Current gate:** Validate the clean Standard source/config/build after
  removing inherited rsuntk KernelSU integration.
- **Build policy:** All toolchain fetches, configuration, builds, validation,
  packaging, and release work run in GitHub Actions only.
- **Last good commit:** `aeed3eb83` (static and Standard config passed before
  the legacy integration was removed).
- **Last passing gates:** Static checks and config generation in [UPA50 CI
  41278547881](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41278547881);
  its build was running against the pre-decoupling source at last check.
- **Last failing run:** [UPA50 CI 41278030173](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41278030173),
  config generation failed because the old `drivers/Kconfig` source reference
  remained after disabling the submodule. The source reference and hooks are
  now being removed instead of restoring the old module.
- **Exact next commands:** Inspect
  `gh run list --repo crypto143007-ship-it/Samsung-A50-Ultimate --workflow upa50-ci.yml --limit 5`
  and review failures with `gh run view <id> --log-failed`.

## Engineering gates

| Gate | Status | Evidence |
|---|---|---|
| Strategy A vs. B baseline decision | Selected, static only | `[VERIFIED-STATIC]` Mint/fork source lineage; no comparative CI build |
| Baseline Standard build | In progress | `[VERIFIED-BUILD]` run [41276281224](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41276281224) compiled an Image but failed package-name validation; clean-source rebuild pending |
| Official KernelSU-Next overlay and Standard purity | In progress | `[VERIFIED-STATIC]` legacy integration removal committed as `d6412f1d6`; CI purity pending and official overlay not yet integrated |
| Config optimizations | Not started | No config changes |
| SOVR feature ports | Not started | No imported kernel patches |
| Three profiles | Not started | No profile implementation |
| Package and validated release | Not started | No UPA50 artifact, tag, or release |
| Physical-device verification | Not started | No A50 test results |

No validated build artifact, release, or physical-device result is claimed.
