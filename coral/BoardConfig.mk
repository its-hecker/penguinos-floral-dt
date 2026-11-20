#
# SPDX-FileCopyrightText: 2018 The Android Open Source Project
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := coral

# Display
TARGET_SCREEN_DENSITY := 560

# Recovery
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 165

# PRIVATE CORAL-ONLY BRING-UP EXPERIMENT: isolate SELinux policy failures.
# Keep data FBE and all other boot/partition settings unchanged.
# Remove this override before building any production/release image.
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

# Includes
include device/google/coral/BoardConfig-common.mk
include vendor/google/coral/BoardConfigVendor.mk
