//
//  AutobusProcessor.m
//  Mixare
//
//  Created by menghu on 4/30/15.
//  Copyright (c) 2015 Peer GmbH. All rights reserved.
//

#import "AutobusProcessor.h"

@implementation AutobusProcessor
- (id)init {
    self = [super init];
    return self;
}

- (BOOL)matchesDataType:(NSString*)title {
    if ([title isEqualToString:@"Autobus"]) {
        return YES;
    }
    return NO;
}

- (NSString *) getLatitude:(NSDictionary *)dic
{
    double latitude = [[dic objectForKey:@"x"] doubleValue];
    //    return [NSString stringWithFormat:@"%f", 38.918231];
    return [NSString stringWithFormat:@"%f", latitude];
}

- (NSString *) getLongitude:(NSDictionary *)dic
{
    double longitude = [[dic objectForKey:@"y"] doubleValue];
    return [NSString stringWithFormat:@"%f", longitude];
    //    return [NSString stringWithFormat:@"%f", 116.693030];
}

- (NSMutableArray*)convert:(NSString*)dataString {
    
    NSString *string = [NSString stringWithFormat:@"{\"results\":%@", dataString];
    string = [NSString stringWithFormat:@"%@}", string];
    NSDictionary *data = [string JSONValue];
    NSArray *tweets = data[@"results"];
    NSLog(@"%@", data);
    
    
    NSMutableArray *ret = [[NSMutableArray alloc]init];
    float height = 500.0;
    for (NSDictionary *tweet in tweets) {
        NSString *marker = tweet[@"profile_image_url_https"];
        if (marker == nil || [marker isEqualToString:@""]) {
            marker = @"autobus_logo_small.png";
        } else {
            marker = [marker stringByReplacingOccurrencesOfString:@"_normal"
                                                       withString:@"_mini"];
        }
        [ret addObject:@{
                         keys[@"user"]: @"xxxxx",
                         keys[@"title"]: [NSString stringWithFormat:@"Autobus n.%@", tweet[@"numeroautobus"]],
                         keys[@"altitude"]: [NSString stringWithFormat:@"%f", height],
                         keys[@"url"]: [NSString stringWithFormat:@"http://maps.google.com/maps?ll=%@,%@" , [self getLatitude:tweet], [self getLongitude:tweet]],
                         keys[@"latitude"]: tweet[@"x"],
                         keys[@"longitude"]: tweet[@"y"],
                         keys[@"marker"]: marker,
                         keys[@"logo"]: @"autobus_logo.png",
                         keys[@"percorso"]: tweet[@"percorso"]}];
        
    }
    return ret;
}

@end
