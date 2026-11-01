# UPA50 status

## NEXT ACTIONS

- **Current gate:** Repository cleanup and toolchain-lock workflow; baseline
  Standard build is not started.
- **Build policy:** All toolchain fetches, configuration, builds, validation,
  packaging, and release work run in GitHub Actions only.
- **Last good commit:** `8e3c1a9567b77f0932d91b3304cdcbe38adfb9a8`.
- **Last green/failing CI run:** None; no UPA50 Actions workflow has run.
- **Exact next commands:** After committing and pushing cleanup plus CI files,
  use `gh run list --repo crypto143007-ship-it/Samsung-A50-Ultimate --limit 5`,
  inspect failures with `gh run view <id> --log-failed`, and download the
  generated small lock artifact with `gh run download <id>`.

## Engineering gates

| Gate | Status | Evidence |
|---|---|---|
| Strategy A vs. B baseline decision | Selected, static only | `[VERIFIED-STATIC]` Mint/fork source lineage; no comparative CI build |
| Baseline Standard build | Not started | No Actions run |
| Official KernelSU-Next overlay and Standard purity | Not started | No source overlay or purity result |
| Config optimizations | Not started | No config changes |
| SOVR feature ports | Not started | No imported kernel patches |
| Three profiles | Not started | No profile implementation |
| Package and validated release | Not started | No UPA50 artifact, tag, or release |
| Physical-device verification | Not started | No A50 test results |

No kernel build, artifact, release, or physical-device result is claimed.
