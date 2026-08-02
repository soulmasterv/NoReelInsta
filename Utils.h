#import <Foundation/Foundation.h>

@interface SCIUtils : NSObject
+ (id)getIvarForObj:(id)obj name:(NSString *)name;
+ (void)setIvarForObj:(id)obj name:(NSString *)name value:(id)value;
@end
