# shellcheck shell=sh
# Sourced by the KernelSU / Magisk module installer.

# With this setting, apps can only draw if the GPU has a Vulkan driver,
# so the module is only installed on devices that have one.
has_vulkan() {
  # Booted system: ask the package manager
  pm list features 2>/dev/null | grep -q '^feature:android.hardware.vulkan.level' && return 0
  # No package manager (e.g. recovery): look for the driver itself
  [ -n "$(getprop ro.vulkan.apex 2>/dev/null)" ] && return 0
  for dir in /vendor/lib64/hw /vendor/lib/hw /odm/lib64/hw /odm/lib/hw; do
    ls "$dir"/vulkan.*.so >/dev/null 2>&1 && return 0
  done
  return 1
}

has_vulkan || abort "! No Vulkan driver found. Not installing: apps could not draw without one."

ui_print "- Vulkan driver found"
ui_print "- After the reboot, the UI is drawn with Vulkan (skiavk)"
