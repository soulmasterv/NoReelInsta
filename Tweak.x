#import <substrate.h>
#import "InstagramHeaders.h"
#import "Utils.h"

// ============================================
// SimpleInsta - Version minimaliste pour supprimer
// 1. L'onglet Reels de la barre de navigation
// 2. Le défilement automatique vers de nouveaux Reels
// ============================================

// --- Préférences (toujours activées, pas de settings) ---
#define ALWAYS_HIDE_REELS_TAB YES
#define ALWAYS_DISABLE_SCROLLING YES

// --- Masquer l'onglet Reels (CLIPS = Reels) ---
BOOL isReelsTabHidden(IGMainAppSurfaceIntent *surface) {
    if ([[surface tabStringFromSurfaceIntent] isEqualToString:@"CLIPS"]) {
        return ALWAYS_HIDE_REELS_TAB;
    }
    return NO;
}

NSArray *filterSurfacesWithoutReels(NSArray *surfaces) {
    NSMutableArray *filtered = [NSMutableArray array];
    for (IGMainAppSurfaceIntent *surface in surfaces) {
        if (![surface isKindOfClass:%c(IGMainAppSurfaceIntent)]) break;
        if (!isReelsTabHidden(surface)) {
            [filtered addObject:surface];
        }
    }
    return filtered;
}

// ============================================
// HOOK 1 & 2: Supprimer l'onglet Reels de la barre
// ============================================

%hook IGTabBarControllerSwipeCoordinator
- (id)initWithSurfaces:(id)surfaces parentViewController:(id)controller enableHaptics:(_Bool)haptics launcherSet:(id)set {
    return %orig(filterSurfacesWithoutReels(surfaces), controller, haptics, set);
}
%end

%hook IGTabBarController
- (void)_layoutTabBar {
    NSArray *_tabBarSurfaces = [SCIUtils getIvarForObj:self name:@"_tabBarSurfaces"];
    [SCIUtils setIvarForObj:self name:@"_tabBarSurfaces" value:filterSurfacesWithoutReels(_tabBarSurfaces)];
    %orig;
}

- (id)_buttonForTabBarSurface:(id)surface {
    if (isReelsTabHidden(surface)) {
        return nil; // Empêche le bouton Reels d'apparaître
    }
    return %orig(surface);
}
%end

// ============================================
// HOOK 3 & 4: Désactiver le scroll des Reels
// ============================================

%hook IGUnifiedVideoCollectionView
- (void)didMoveToWindow {
    %orig;
    if (ALWAYS_DISABLE_SCROLLING) {
        self.scrollEnabled = NO;
    }
}

- (void)setScrollEnabled:(BOOL)arg1 {
    if (ALWAYS_DISABLE_SCROLLING) {
        return %orig(NO);
    }
    return %orig(arg1);
}
%end

%hook _TtC19IGSundialAutoScroll19IGSundialAutoScroll
- (void)setIsEnabled:(BOOL)enabled {
    if (ALWAYS_DISABLE_SCROLLING) {
        %orig(NO);
    } else {
        %orig(enabled);
    }
}
%end
