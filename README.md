# PenguinOS Android 17 for coral

This device tree is based on the PixelOS Floral tree and keeps the same
device-specific vendor, boot layout, and 4.14 KernelSU Next source.

Use the [PenguinOS Floral local manifest](https://github.com/its-hecker/Penguinos-floral-localmanifest/tree/main)
and run its preparation script before building `aospa_coral-cp2a-userdebug`.
The manifest selects the standalone Motion Sense and 3D Face ID plugins,
Lunaris Dolby, and the PixelOS-compatible legacy HALs.

See [UPSTREAM.json](UPSTREAM.json) for the original device-tree provenance.
