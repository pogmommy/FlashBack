include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = FlashBack

FlashBack_CODESIGN_FLAGS = -Sentitlements.plist

include $(THEOS_MAKE_PATH)/xcodeproj.mk