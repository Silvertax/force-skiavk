# Force skiavk

KernelSU / Magisk module that makes Android draw its user interface with **Vulkan** instead of OpenGL ES. It sets `debug.hwui.renderer=skiavk` at boot, so all apps, System UI included, render through Skia's Vulkan backend.

## Can fix graphics glitches

If parts of the interface render wrong on your ROM, such as garbled animations, flickering or artifacts, a bug in the GPU's OpenGL ES driver can be the cause. With this module the interface no longer goes through that driver, so glitches like these can disappear.

**Example:** on a Galaxy S20 FE with LineageOS 24.0, the animation of the in-display fingerprint sensor was garbled. With this module it is drawn correctly.

This is a workaround, not a guaranteed fix: whether it helps depends on the device, the ROM and the GPU driver.

## Tested on

- Galaxy S20 FE Snapdragon (SM-G780G, r8q), unofficial LineageOS 24.0 (r8q Cloud), KernelSU
- Magisk: the zip contains the Magisk installer files, but it hasn't been tried on a phone with Magisk yet

## Requirements

- A Vulkan driver for the GPU. The installer checks for one and cancels if there is none, because apps couldn't draw at all without it.
- Root with KernelSU (or a fork such as KernelSU Next) or Magisk

## Installation

1. Download `force-skiavk-v1.0.zip` from [Releases](https://github.com/Silvertax/force-skiavk/releases/latest).
2. KernelSU / Magisk → Modules → Install → select the zip → reboot.

Later versions can be installed from the module list in KernelSU / Magisk: the module carries an update link (`updateJson`), so the manager offers an update when a new release is out. This works from the first version after v1.0.

## Checking that it's active

With `adb shell` or in a root shell:

```sh
getprop debug.hwui.renderer                            # skiavk
dumpsys gfxinfo com.android.systemui | grep Pipeline   # Pipeline=Skia (Vulkan)
```

## Undoing it

Remove the module in KernelSU / Magisk and reboot; the ROM's default renderer is back. Do the same if something looks worse or apps crash after installing it, because Vulkan drivers can have bugs of their own.

If the phone doesn't finish booting:

- **KernelSU:** right after the first boot screen, press volume down at least three times (press and release, don't hold). KernelSU then starts in safe mode with all modules disabled. Remove the module there and reboot.
- **Magisk:** after two failed boots in a row, Magisk starts in safe mode with all modules disabled. With USB debugging on, `magisk --remove-modules` in `adb shell` removes all modules.

## How it works

Android draws app and system interfaces with its renderer HWUI, which uses Skia on top of OpenGL ES (`skiagl`) or Vulkan (`skiavk`). The ROM picks the default (`ro.hwui.use_vulkan`), and the property `debug.hwui.renderer` overrides it. The module only sets this property, through its `system.prop`, which KernelSU / Magisk apply early in boot, before any app starts. Setting it by hand with `setprop` only lasts until the next reboot and only affects apps started afterwards. If your ROM already uses Vulkan, the module changes nothing.

Only the regular interface drawing changes. Games and apps that use OpenGL ES or Vulkan directly, and the screen composition by SurfaceFlinger, stay as they are.

## Building

`./build.sh` packs `module/` and the license into `dist/force-skiavk-<version>.zip`.

**Releases:** set `version` and `versionCode` in `module/module.prop`, add the changes to `CHANGELOG.md`, merge, then publish a GitHub release whose tag equals `version`. The workflow in `.github/workflows/build.yml` builds the zip, attaches it to the release and updates `update.json`.

## License

MIT, see [LICENSE](LICENSE).
