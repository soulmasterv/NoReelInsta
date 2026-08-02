TARGET := iphone:clang:16.2
INSTALL_TARGET_PROCESSES = Instagram
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SimpleInsta

# Fichiers source
$(TWEAK_NAME)_FILES = Tweak.x Utils.m

# Désactiver ARC pour Utils.m (nécessaire pour object_getInstanceVariable)
Utils.m_CFLAGS = -fno-objc-arc

# Frameworks nécessaires
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation CoreGraphics

# Options de compilation
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
