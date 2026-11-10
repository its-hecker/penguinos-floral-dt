#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Qualcomm common reads the platform before BoardConfig is loaded.
TARGET_BOARD_PLATFORM := msmnile

# Use PenguinOS's product configuration with Floral's stock IR provider.
FLORAL_HARDWARE_FACE := true
TARGET_EXCLUDES_APERTURE := true
TARGET_EXCLUDE_GMODULES := true

# Keep mainline modules source-built for the legacy Floral vendor.
PRODUCT_BUILD_IGNORE_APEX_CONTRIBUTION_CONTENTS := true
PRODUCT_MODULE_BUILD_FROM_SOURCE := true

# Only the build tools are used from the PixelOS Lineage vendor tree.
PRODUCT_SOURCE_ROOT_DIRS += -vendor/hecker/floral/kernel-build

# Keep one provider for memtrack, charging control, and telephony.
PRODUCT_SOURCE_ROOT_DIRS += \
    -device/qcom/vendor-common/memtrack/ \
    -vendor/aospa/interfaces/health/ \
    -vendor/codeaurora/telephony/

$(call inherit-product, vendor/aospa/target/product/aospa-target.mk)

#
# All components inherited here go to system image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)

# Enable mainline checking
PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := relaxed

# Google system artifacts shared by the bundled GMS products.
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/apex/com.google.android.extservices.apex \
    system/app/GoogleExtShared/GoogleExtShared.apk \
    system/app/GooglePrintRecommendationService/GooglePrintRecommendationService.apk \
    system/etc/permissions/privapp-permissions-google.xml \
    system/lib/libtensorflowlite_jni.so \
    system/lib64/libtensorflowlite_jni.so \
    system/priv-app/DocumentsUIGoogle/DocumentsUIGoogle.apk \
    system/priv-app/TagGoogle/TagGoogle.apk

#
# All components inherited here go to system_ext image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_system_ext.mk)

#
# All components inherited here go to product image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)

#
# All components inherited here go to vendor image
#
# TODO(b/136525499): move *_vendor.mk into the vendor makefile later
TARGET_SUPPORTS_OMX_SERVICE := false
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_vendor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_vendor.mk)

include device/google/coral/coral/device.mk

# Device identifier. This must come after all inclusions
PRODUCT_BRAND := google
PRODUCT_DEVICE := coral
PRODUCT_MANUFACTURER := Google
PRODUCT_GMS_CLIENTID_BASE := android-google
PRODUCT_MODEL := Pixel 4 XL
PRODUCT_NAME := aospa_coral

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="coral-user 13 TP1A.221005.002.B2 9382335 release-keys" \
    BuildFingerprint=google/coral/coral:13/TP1A.221005.002.B2/9382335:user/release-keys \
    DeviceProduct=coral

$(call inherit-product, vendor/google/coral/coral-vendor.mk)

# Standalone plugins own the enhanced Motion Sense and 3D Face Unlock packages.
# Keep these AFTER every base device/vendor product.
$(call inherit-product, vendor/hecker/floral/motionsense/motionsense.mk)
$(call inherit-product, vendor/hecker/floral/faceid/faceid.mk)

# Use the original signed Camera package tested on Infinity-X Coral.
$(call inherit-product, device/google/coral/camera/camera.mk)

# Preserve bounded startup evidence on userdebug/eng builds.
include device/google/coral/boot_diagnostics/boot_capture.mk
