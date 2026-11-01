# UPA50 status

## NEXT ACTIONS

- **Current gate:** Build and validate the official KernelSU-Next v3.0.0
  candidate after v3.4.2 proved incompatible with the baseline syscall ABI.
  Keep Standard and both compiled images free of SuSFS.
- **Build policy:** All toolchain fetches, configuration, builds, validation,
  packaging, and release work run in GitHub Actions only.
- **Last good Standard commit:** `0930746de053632fd2f1c2c664bdb39e3adb61f1`.
- **Last Standard-passing run:** [UPA50 CI 41284747123](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41284747123)
  passed static checks, both edition configs, Standard Proton Clang 13.0.0
  compilation/package validation, and Standard purity. The KSU v3.4.2 build in
  that run failed at `syscall_fn_t` in `drivers/kernelsu/core/init.c`.
- **Last artifact:** `standard-oneui-android-12` (58,777,341-byte Actions
  artifact bundle; uploaded bundle digest
  `066db25cd3ebda32d473e3088d9b9d49793ed9d6b992ca275ef3895a0df21eb3`).
  The included ZIP's individual size and checksum were not printed in this run.
- **Exact next commands:** Commit and push the v3.0.0 compatibility pin, then inspect
  `gh run list --repo crypto143007-ship-it/Samsung-A50-Ultimate --workflow upa50-ci.yml --limit 5`
  and review any failure with `gh run view <id> --log-failed`.

## Engineering gates

| Gate | Status | Evidence |
|---|---|---|
| Strategy A vs. B baseline decision | Selected, static only | `[VERIFIED-STATIC]` Mint/fork source lineage; no comparative CI build |
| Baseline Standard build | Done | `[VERIFIED-BUILD]` Proton Clang 13.0.0 compiled the clean source and the validator accepted `UPA50-standard-oneui-A12-v0.0.0.zip` in [run 41280660290](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41280660290). Artifact bundle: `standard-oneui-android-12`, 58,777,341 bytes; bundle digest `066db25cd3ebda32d473e3088d9b9d49793ed9d6b992ca275ef3895a0df21eb3`. The ZIP's individual checksum is included in the artifact's `SHA256SUMS.txt` but has not been retrieved locally. |
| Official KernelSU-Next overlay and Standard purity | In progress | `[VERIFIED-BUILD]` Standard config and binary purity passed in [run 41284747123](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41284747123). The v3.4.2 KSU build failed because its syscall ABI is incompatible with 4.14; the official v3.0.0 tracepoint-based pin is queued for CI validation. |
| Config optimizations | Not started | No config changes |
| SOVR feature ports | Not started | No imported kernel patches |
| Three profiles | Not started | No profile implementation |
| Package and validated release | Not started | No UPA50 artifact, tag, or release |
| Physical-device verification | Not started | No A50 test results |

No release or physical-device result is claimed. No build has been tested on a physical Galaxy A50.
