# SPDX-License-Identifier: Apache-2.0
# Temporary bootloop diagnostics only. Set PENGUIN_DEV_USB_ADB=false for
# anything distributed to other users.
#
# This mirrors the native HeckerOS userdebug ADB behavior, not a framework
# authorization bypass. It applies to USB adbd only, not TCP or ADB root.
PENGUIN_DEV_USB_ADB ?= $(if $(filter userdebug eng,$(TARGET_BUILD_VARIANT)),true,false)

# Keep a single product-partition assignment for each property. Product
# properties are loaded after system/vendor default properties.
PRODUCT_PRODUCT_PROPERTIES := $(filter-out \
    ro.adb.secure=% ro.adb.secure?=% \
    ro.penguinos.dev_usb_adb=% ro.penguinos.dev_usb_adb?=%, \
    $(PRODUCT_PRODUCT_PROPERTIES))

ifeq ($(strip $(PENGUIN_DEV_USB_ADB)),true)
ifeq ($(filter userdebug eng,$(TARGET_BUILD_VARIANT)),)
$(error PENGUIN_DEV_USB_ADB=true requires a userdebug or eng build)
endif
PRODUCT_PRODUCT_PROPERTIES := $(filter-out \
    persist.sys.usb.config=% persist.sys.usb.config?=%, \
    $(PRODUCT_PRODUCT_PROPERTIES))
PRODUCT_PRODUCT_PROPERTIES += \
    ro.penguinos.dev_usb_adb=1 \
    ro.adb.secure=0 \
    persist.sys.usb.config=adb
else ifeq ($(strip $(PENGUIN_DEV_USB_ADB)),false)
# Safe opt-out for public releases. Never force USB ADB on in this mode.
PRODUCT_PRODUCT_PROPERTIES += \
    ro.penguinos.dev_usb_adb=0 \
    ro.adb.secure=1
else
$(error PENGUIN_DEV_USB_ADB must be true or false)
endif
