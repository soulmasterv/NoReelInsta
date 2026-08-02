#import <Foundation/Foundation.h>
#include <objc/NSObject.h>
#import <UIKit/UIKit.h>

// Classes nécessaires pour SimpleInsta

// Pour la barre de navigation (onglet Reels)
@interface IGMainAppSurfaceIntent : NSObject
- (NSString *)tabStringFromSurfaceIntent;
@end

// Pour supprimer l'onglet Reels
@interface IGTabBarController : UIViewController
@end

// Pour le défilement des Reels
@interface IGUnifiedVideoCollectionView : UIScrollView
@end

// Pour désactiver l'auto-scroll des Reels
@interface IGSundialAutoScroll : NSObject
- (void)setIsEnabled:(BOOL)enabled;
@end

// Pour la coordination des onglets
@interface IGTabBarControllerSwipeCoordinator : NSObject
- (id)initWithSurfaces:(id)surfaces parentViewController:(id)controller enableHaptics:(BOOL)haptics launcherSet:(id)set;
@end
