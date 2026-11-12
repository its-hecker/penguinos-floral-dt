# Temporary PenguinOS USB ADB for bootloop diagnosis

The Pixel 4 XL (`coral`) and Pixel 4 (`flame`) development builds can
start USB debugging without waiting for Android's Settings app, SystemUI, or
home screen to load. This mirrors the temporary HeckerOS diagnostic mode.

`aospa_coral.mk` and `aospa_flame.mk` include
`device/google/coral/debugging/development_adb.mk` after the other device
product definitions. The fragment is **enabled by default only for
`userdebug` and `eng`** and emits these product properties:

- `ro.penguinos.dev_usb_adb=1`
- `ro.adb.secure=0`
- `persist.sys.usb.config=adb`

This mode **trusts every physically connected USB computer** without an RSA
authorization prompt. It is intended **only for private, physically controlled
test devices**. Do not distribute a build with this mode enabled.

It does not modify SELinux, give `adb root` by default, open TCP/wireless
ADB, or guarantee access when a crash happens before USB/adbd startup.
On a dirty flash, a saved USB-debugging-off choice may override the USB
default; restoring the USB debugging toggle in Settings may be necessary.

## Build a debug image

```bash
bash .repo/local_manifests/build.sh coral -g
```

## Safe builds for users / final releases

**Always** disable temporary PC auto-trust when building a release:

```bash
PENGUIN_DEV_USB_ADB=false bash .repo/local_manifests/build.sh coral -g
```

This restores `ro.adb.secure=1`, sets
`ro.penguinos.dev_usb_adb=0`, and leaves the platform's normal USB default
unchanged. `user` builds default to this mode and reject
`PENGUIN_DEV_USB_ADB=true`.

## Capture logs during a boot-logo hang

Connect the Pixel to a development PC, then run:

```bash
adb devices
adb wait-for-device
adb shell getprop ro.penguinos.dev_usb_adb
adb shell getprop ro.adb.secure
adb logcat -b all -v threadtime > penguinos-bootloop.log
```

In the temporary mode the two getprops should read `1` and `0` and
`adb devices` should say `device` once adbd has started. Stop logcat using
Ctrl+C after collecting evidence. If the device is unavailable, use the
existing `boot_diagnostics` output or recovery-side logs; this setting
cannot help with first-stage boot failures.
