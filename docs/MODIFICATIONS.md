# UPA50 modifications

## Repository foundation

- [VERIFIED-STATIC] Added the UPA50 project README while retaining Mint's
  contributor acknowledgments.
- [VERIFIED-STATIC] Added project status, decision, source-baseline, and
  attribution ledgers.
- [VERIFIED-STATIC] Added `.gitattributes` to request LF line endings for text
  files and shell scripts.
- [VERIFIED-STATIC] Corrected the project remote and based `upa50/main` on the
  fork's `android-14.0` baseline.

[VERIFIED-STATIC] No kernel-source modifications or performance changes have
been made.

## Release asset validation

- [VERIFIED-STATIC] Added fail-closed validation to the inherited release jobs
  in `.github/workflows/development.yml` and
  `.github/workflows/galaxy-a50.yml`. Before a release can be created, the
  jobs require the expected number of ZIP packages and use
  `tools/make/validate_release.py` to check ZIP CRCs, safe unique entry paths,
  non-empty AnyKernel/kernel/DTB/ramdisk payloads, and that no non-ZIP files
  remain in the release directory.
- [PROPOSED] The validation gates have not run in GitHub Actions. No release
  has been created from this branch.
- [VERIFIED-STATIC] The fork baseline has no
  `.github/workflows/release-kernel.yml`; its release jobs are in the two
  inherited workflows above.

## Physical-device test preparation

- [VERIFIED-STATIC] Added a read-only ADB diagnostic collector and result
  template under `testing/` for the requested A50 functional and benchmark
  areas. The collector does not flash, change settings, or run stress tests.
- [PROPOSED] All device testing is awaiting the owner's physical Galaxy A50;
  no results have been produced.
