# UPA50 status

## NEXT ACTIONS

- **Current gate:** Rebuild the official KernelSU-Next v3.0.0 edition with the
  Linux 4.14 API compatibility overlay. Keep Standard and both compiled
  images free of SuSFS.
- **Build policy:** All toolchain fetches, configuration, builds, validation,
  packaging, and release work run in GitHub Actions only.
- **Last attempted commit:** `01a1265da`.
- **Last CI run:** [UPA50 CI 41288696197](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41288696197)
  passed static checks, both configs, and the Standard build. The KSU-Next
  v3.0.0 build compiled past the task-work and seccomp API incompatibilities,
  then failed in `drivers/kernelsu/sucompat.c` because Linux 4.14 does not
  provide `linux/pgtable.h`. That file does not use page-table identifiers;
  its `linux/mm.h` include provides `asm/pgtable.h`. The compatibility overlay
  now removes only the unused include; CI must verify it. The successful
  Standard package was
  `UPA50-standard-oneui-A12-v0.0.0.zip` (20,924,452 bytes,
  SHA-256 `de55b7af7f99ff911b39de8467526e3cd3c2c23bf26f10de1ea4544de1f55eec`);
  artifact bundle `standard-oneui-android-12`, 58,775,929 bytes.
- **Exact next commands:** `git diff --check`; commit the page-table include
  compatibility update and evidence with the required co-author trailer; push
  `upa50/main`; inspect
  `gh run list --repo crypto143007-ship-it/Samsung-A50-Ultimate --workflow upa50-ci.yml --limit 5`;
  review any failure with `gh run view <id> --log-failed`.

## Engineering gates

| Gate | Status | Evidence |
|---|---|---|
| Strategy A vs. B baseline decision | Selected, static only | `[VERIFIED-STATIC]` Mint/fork source lineage; no comparative CI build |
| Baseline Standard build | Done | `[VERIFIED-BUILD]` Proton Clang 13.0.0 compiled the clean source and the validator accepted `UPA50-standard-oneui-A12-v0.0.0.zip` in [run 41280660290](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41280660290). Artifact bundle: `standard-oneui-android-12`, 58,777,341 bytes; bundle digest `066db25cd3ebda32d473e3088d9b9d49793ed9d6b992ca275ef3895a0df21eb3`. The ZIP's individual checksum is included in the artifact's `SHA256SUMS.txt` but has not been retrieved locally. |
| Official KernelSU-Next overlay and Standard purity | In progress | `[VERIFIED-BUILD]` Standard built in [run 41286220636](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate/actions/runs/41286220636); v3.0.0 KSU compilation failed in `allowlist.c` on 4.14 task-work APIs. A focused compatibility patch is pending CI. |
| Config optimizations | Not started | No config changes |
| SOVR feature ports | Not started | No imported kernel patches |
| Three profiles | Not started | No profile implementation |
| Package and validated release | Not started | No UPA50 artifact, tag, or release |
| Physical-device verification | Not started | No A50 test results |

No release or physical-device result is claimed. No build has been tested on a physical Galaxy A50.
