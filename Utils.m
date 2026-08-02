#import "Utils.h"
#include <objc/runtime.h>

@implementation SCIUtils

+ (id)getIvarForObj:(id)obj name:(NSString *)name {
    id value = nil;
    object_getInstanceVariable(obj, [name UTF8String], (void **)&value);
    return value;
}

+ (void)setIvarForObj:(id)obj name:(NSString *)name value:(id)value {
    object_setInstanceVariable(obj, [name UTF8String], (void *)value);
}

@end
