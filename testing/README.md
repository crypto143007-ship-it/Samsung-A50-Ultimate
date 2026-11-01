# Galaxy A50 test preparation

**Status: awaiting physical-device testing.** These materials are procedures
and templates only; no Galaxy A50 test has been run and no result is implied.

`run_a50_checks.ps1` collects read-only Android diagnostic output through ADB.
It writes logs on the host (by default under `%TEMP%`) and does not flash the
device, change settings, or run benchmarks. The root check invokes `su -c id`
and may display a superuser authorization prompt.

Requirements: Windows PowerShell, Android Platform Tools (`adb`), an
authorized USB-debugging connection, and a booted Galaxy A50. Run:

```powershell
.\testing\run_a50_checks.ps1
```

Use `-Serial <adb-serial>` when more than one device is connected, or
`-OutputDirectory <path>` to choose where host logs are saved. A failed or
unsupported diagnostic command is recorded in the log with its exit code;
review those entries rather than treating missing output as a pass.

The script only collects state. Boot, root, battery, thermal, Wi-Fi,
Bluetooth, GPS, camera, audio, charging, and benchmark checks still require
the manual procedure and result record in `RESULT_TEMPLATE.md`. Keep all
thermal, charging, and battery protections enabled. Do not use unsupported
frequencies or voltages. Stop a test if the device reports a thermal warning
or behaves abnormally.
