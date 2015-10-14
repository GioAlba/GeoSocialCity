#import "GlobalSettings.h"

@implementation GlobalSettings

@synthesize coordinate;

+(GlobalSettings *)sharedInstance
{
    static GlobalSettings *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[GlobalSettings alloc] init];
            
    });
    return _sharedInstance;
}

@end
