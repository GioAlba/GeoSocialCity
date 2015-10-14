#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GlobalSettings : NSObject
+(GlobalSettings *)sharedInstance;

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSString *searchKey;

@end
