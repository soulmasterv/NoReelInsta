#import <Foundation/Foundation.h>
#include <objc/NSObject.h>
#import <UIKit/UIKit.h>

// Root view controller for presenting nag messages
@interface IGRootViewController : UIViewController
- (void)_superPresentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(id)completion;
@end

// Classes for Reels tab removal
@interface IGMainAppSurfaceIntent : NSObject
- (NSString *)tabStringFromSurfaceIntent;
@end

@interface IGTabBarController : UIViewController
@end

@interface IGTabBarControllerSwipeCoordinator : NSObject
- (id)initWithSurfaces:(id)surfaces parentViewController:(id)controller enableHaptics:(BOOL)haptics launcherSet:(id)set;
@end

// Classes for Reels scrolling
@interface IGUnifiedVideoCollectionView : UIScrollView
@end

@interface IGSundialAutoScroll : NSObject
- (void)setIsEnabled:(BOOL)enabled;
@end

// Classes for blocking TestFlight/Integrity nag messages
// Swift nested class: IGCoreRootTestFlightNagPlugin.TestFlightUpdateNudgeViewController
@interface IGCoreRootTestFlightNagPlugin_TestFlightUpdateNudgeViewController : UIViewController
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
@end

// Alternative Swift mangled names (suffixes can change between app versions)
@interface TestFlightUpdateNudgeViewController : UIViewController
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
@end

@interface IGTestFlightNagController : NSObject
- (void)presentUpdateNag;
- (void)presentNagWithTitle:(NSString *)title message:(NSString *)message;
@end

@interface IGCoreRootTestFlightNagPlugin : NSObject
- (void)showTestFlightNagIfNeeded;
- (void)checkForTestFlightNag;
- (void)presentTestFlightUpdateNag;
- (void)presentTestFlightUpdateNagWithTitle:(NSString *)title message:(NSString *)message;
@end

@interface IGTestFlightUpdateNagController : NSObject
- (void)presentNag;
- (void)showUpdateNag;
@end

@interface _InReviewIntegrityDecisionDialogController : UIViewController
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
@end

@interface _browserIntegrityController : NSObject
- (void)showIntegrityWarning;
@end
