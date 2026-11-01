# UPA50 physical-device test record

**Status: awaiting physical-device testing.** Do not fill in expected results
as observed results. Attach raw logs and record failures as well as passes.

## Test identity

| Field | Value |
|---|---|
| Test date/time and time zone | Awaiting test |
| Tester | Awaiting test |
| Device model / variant | Awaiting test |
| ROM and Android version | Awaiting test |
| UPA50 edition / commit / artifact SHA-256 | Awaiting a validated build |
| Profile selected | Awaiting test |
| Ambient conditions and battery level | Awaiting test |
| ADB diagnostic log path | Awaiting test |

## Results

For each item, record **PASS**, **FAIL**, or **NOT RUN**, plus the test
conditions and supporting evidence. `NOT RUN` is the current state for every
item.

| Area | Result | Procedure / evidence |
|---|---|---|
| Boot and recovery | NOT RUN | Confirm normal boot, repeated cold/warm boots, recovery access, and ability to restore the known-good boot image. Record boot time and logs. |
| Root behavior | NOT RUN | For the Standard edition, verify root is absent. For the KernelSU-Next edition, verify the expected manager and authorized `su` behavior without granting unrelated apps. |
| Battery | NOT RUN | Record idle and screen-on drain over a documented interval with brightness, network, apps, and starting/ending charge level controlled. |
| Thermal | NOT RUN | Observe thermal status and temperatures during idle and ordinary use. Keep all thermal protections enabled; stop on warnings or abnormal heat. |
| Wi-Fi | NOT RUN | Test scan, connect, disconnect/reconnect, throughput under a stated network, and sleep/wake recovery. |
| Bluetooth | NOT RUN | Test pairing, reconnect, audio/data use as applicable, and behavior after sleep/wake. |
| GPS | NOT RUN | Record time-to-fix, satellite/location stability, and conditions (indoors/outdoors, app, network assistance). |
| Camera | NOT RUN | Test preview, photo, video, focus, flash, front/rear sensors, and any ROM-specific camera paths. |
| Audio | NOT RUN | Test speaker, earpiece, microphone, wired/USB audio as applicable, calls, and recording/playback. |
| Charging | NOT RUN | Test supported chargers/cables and charge-state reporting. Do not override charging limits or protections. |
| Benchmarks | NOT RUN | Record tool/version, settings, repetitions, starting temperature, and results. Run only with protections intact; stop on thermal warnings. |

## Incidents and recovery

- Unexpected behavior / logs: Awaiting test
- Thermal or battery warnings: Awaiting test
- Recovery procedure used: Awaiting test
- Known-good image restored and verified: Awaiting test
- Overall assessment: Awaiting physical-device testing
