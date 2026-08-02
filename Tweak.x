#import <substrate.h>
#import "InstagramHeaders.h"
#import "Utils.h"

// ============================================
// NoReelInsta - Ultra-minimal Instagram tweak
// Removes Reels tab and disables auto-scrolling
// ============================================

// Preferences (always enabled, no settings)
#define ALWAYS_HIDE_REELS_TAB YES
#define ALWAYS_DISABLE_SCROLLING YES

// Check if Reels tab should be hidden
BOOL isReelsTabHidden(IGMainAppSurfaceIntent *surface) {
    if ([[surface tabStringFromSurfaceIntent] isEqualToString:@"CLIPS"]) {
        return ALWAYS_HIDE_REELS_TAB;
    }
    return NO;
}

// Filter out Reels from surfaces
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
// HOOKS 1-2: Remove Reels tab from navigation bar
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
        return nil; // Prevent Reels tab button from appearing
    }
    return %orig(surface);
}
%end

// ============================================
// HOOKS 3-4: Disable Reels auto-scrolling
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

// ============================================
// HOOKS 5-14: Block TestFlight / Integrity Nag Messages
// ============================================

// 1. Block at presentation level - Check all presented view controllers
%hook IGRootViewController
- (void)_superPresentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(id)completion {
    NSString *className = NSStringFromClass([viewController class]);
    // Check if this is a TestFlight/Integrity nag controller
    if ([className containsString:@"TestFlight"] || [className containsString:@"Nag"] || [className containsString:@"Integrity"]) {
        return; // Block presentation
    }
    %orig(viewController, animated, completion);
}
%end

// 2. Block UIViewController presentViewController as fallback
%hook UIViewController
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(id)completion {
    NSString *className = NSStringFromClass([viewControllerToPresent class]);
    // Block TestFlight/Integrity nags
    if ([className containsString:@"TestFlight"] || [className containsString:@"Nag"] || [className containsString:@"Integrity"] || [className containsString:@"UpdateNudge"]) {
        return; // Block presentation
    }
    %orig(viewControllerToPresent, flag, completion);
}
%end

// 3. Block UIApplication openURL for TestFlight links
%hook UIApplication
- (BOOL)openURL:(NSURL *)url {
    NSString *urlString = [url absoluteString];
    // Block TestFlight app store and beta links
    if ([urlString containsString:@"testflight"] || [urlString containsString:@"itms-beta://"] || [urlString containsString:@"apps.apple.com/us/app/testflight"]) {
        return NO; // Block TestFlight URL opening
    }
    return %orig(url);
}
%end

// 4. Block IGCoreRootTestFlightNagPlugin (BLOCK AT SOURCE)
%hook IGCoreRootTestFlightNagPlugin
- (void)showTestFlightNagIfNeeded {
    return;
}
- (void)checkForTestFlightNag {
    return;
}
- (void)presentTestFlightUpdateNag {
    return;
}
- (void)presentTestFlightUpdateNagWithTitle:(NSString *)title message:(NSString *)message {
    return;
}
%end

// 5. Block Swift nested class: IGCoreRootTestFlightNagPlugin_TestFlightUpdateNudgeViewController
%hook IGCoreRootTestFlightNagPlugin_TestFlightUpdateNudgeViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return nil; // Prevent creation
}
- (void)viewDidLoad {
    %orig;
    [self dismissViewControllerAnimated:NO completion:^{}];
}
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    [self dismissViewControllerAnimated:NO completion:^{}];
}
%end

// 6. Block alternative name (Swift mangled without parent)
%hook TestFlightUpdateNudgeViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return nil; // Prevent creation
}
- (void)viewDidLoad {
    %orig;
    [self dismissViewControllerAnimated:NO completion:^{}];
}
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    [self dismissViewControllerAnimated:NO completion:^{}];
}
%end

// 7. Block IGTestFlightNagController
%hook IGTestFlightNagController
- (void)presentUpdateNag {
    return;
}
- (void)presentNagWithTitle:(NSString *)title message:(NSString *)message {
    return;
}
%end

// 8. Block IGTestFlightUpdateNagController
%hook IGTestFlightUpdateNagController
- (void)presentNag {
    return;
}
- (void)showUpdateNag {
    return;
}
%end

// 9. Block Integrity Decision Dialog
%hook _InReviewIntegrityDecisionDialogController
- (void)viewDidLoad {
    %orig;
    [self dismissViewControllerAnimated:NO completion:^{}];
}
%end

// 10. Block Browser Integrity Controller
%hook _browserIntegrityController
- (void)showIntegrityWarning {
    return;
}
%end
