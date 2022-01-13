INSTALL_TARGET_PROCESSES = FlashBack

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = FlashBack

FlashBack_CODESIGN_FLAGS = -Sentitlements.plist

include $(THEOS_MAKE_PATH)/xcodeproj.mk

after-stage::
	@sudo chmod 6755 $(THEOS_STAGING_DIR)/usr/bin/fbmobileldrestart
