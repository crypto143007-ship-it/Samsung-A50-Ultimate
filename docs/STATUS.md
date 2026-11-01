# UPA50 status

## NEXT ACTIONS

- **Current gate:** Baseline Standard config/build with the verified Proton
  toolchain; no kernel build has passed.
- **Build policy:** All toolchain fetches, configuration, builds, validation,
  packaging, and release work run in GitHub Actions only.
- **Last good commit:** `619317b61` (toolchain-lock verification passed).
- **Last green run:** None.
- **Last failing run:** [Toolchain lock 41274212163](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41274212163),
  `Record pinned compiler manifests`: `Permission denied` because the new
  shell script was committed without its executable bit. Corrected locally;
  no toolchain fetch or build ran.
- **Last green run:** [Toolchain lock verification 41275135426](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41275135426);
  both pinned manifests and version strings matched; no kernel compilation.
- **Exact next commands:** Push the UPA50 CI workflow and packaging changes,
  inspect `gh run list --repo crypto143007-ship-it/Samsung-A50-Ultimate --workflow upa50-ci.yml --limit 5`,
  then review failures with `gh run view <id> --log-failed`.

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
