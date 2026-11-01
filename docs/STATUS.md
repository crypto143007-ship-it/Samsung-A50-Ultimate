# UPA50 status

## NEXT ACTIONS

- **Current gate:** Run CI for the pinned KernelSU-Next edition overlay and its
  configuration/build validation; Standard must remain free of KSU/SuSFS.
- **Build policy:** All toolchain fetches, configuration, builds, validation,
  packaging, and release work run in GitHub Actions only.
- **Last good commit:** `d47589bbf2dc298257e3335b170604417ad33ce5`.
- **Last passing run:** [UPA50 CI 41280660290](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41280660290)
  passed static checks, Standard config generation, Proton Clang 13.0.0
  compilation, package validation, and Standard configuration/binary purity.
- **Last artifact:** `standard-oneui-android-12` (58,777,341-byte Actions
  artifact bundle; uploaded bundle digest
  `066db25cd3ebda32d473e3088d9b9d49793ed9d6b992ca275ef3895a0df21eb3`).
  The included ZIP's individual size and checksum were not printed in this run.
- **Exact next commands:** Commit and push the pinned KernelSU-Next overlay,
  then inspect
  `gh run list --repo crypto143007-ship-it/Samsung-A50-Ultimate --workflow upa50-ci.yml --limit 5`
  and review any failure with `gh run view <id> --log-failed`.

## Engineering gates

| Gate | Status | Evidence |
|---|---|---|
| Strategy A vs. B baseline decision | Selected, static only | `[VERIFIED-STATIC]` Mint/fork source lineage; no comparative CI build |
| Baseline Standard build | Done | `[VERIFIED-BUILD]` Proton Clang 13.0.0 compiled the clean source and the validator accepted `UPA50-standard-oneui-A12-v0.0.0.zip` in [run 41280660290](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41280660290). Artifact bundle: `standard-oneui-android-12`, 58,777,341 bytes; bundle digest `066db25cd3ebda32d473e3088d9b9d49793ed9d6b992ca275ef3895a0df21eb3`. The ZIP's individual checksum is included in the artifact's `SHA256SUMS.txt` but has not been retrieved locally. |
| Official KernelSU-Next overlay and Standard purity | In progress | `[VERIFIED-BUILD]` Standard config and binary purity passed in [run 41280660290](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41280660290). Pinned overlay code and edition-specific KPROBES config are prepared; KSU-Next build validation is pending CI. |
| Config optimizations | Not started | No config changes |
| SOVR feature ports | Not started | No imported kernel patches |
| Three profiles | Not started | No profile implementation |
| Package and validated release | Not started | No UPA50 artifact, tag, or release |
| Physical-device verification | Not started | No A50 test results |

No release or physical-device result is claimed. No build has been tested on a physical Galaxy A50.
