# Building UPA50

[PROPOSED] All toolchain fetches, configuration, compilation, validation, and
packaging run in GitHub Actions on `ubuntu-22.04`; native Windows builds are
not supported. [VERIFIED-STATIC] The CI workflow is being brought up and no
successful UPA50 build is available yet.

After the workflow is available, use the Actions tab to run or inspect
`upa50-ci.yml`. Builds verify the compiler commit, content manifest, and
compiler version against `toolchain.lock`. Do not use an unpinned compiler or
treat a failed or missing run as a build result.
