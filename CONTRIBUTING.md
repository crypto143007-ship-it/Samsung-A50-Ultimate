# Contributing

Keep changes focused and preserve upstream authorship and license notices.
Kernel builds, toolchain acquisition, and artifact validation must run in
GitHub Actions on `ubuntu-22.04`; do not commit generated build outputs.

Do not change thermal, charging, or battery protections, introduce
unsupported frequencies or voltages, or claim build/device results without
the corresponding evidence. Record imported patches and their exact source
commit in `docs/UPSTREAM_AND_LICENSES.md`.
