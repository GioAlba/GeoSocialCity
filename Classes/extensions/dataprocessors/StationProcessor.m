//
//  StationProcessor.m
//  Mixare
//
//  Created by menghu on 4/29/15.
//  Copyright (c) 2015 Peer GmbH. All rights reserved.
//

#import "StationProcessor.h"

@implementation StationProcessor

- (id)init {
    self = [super init];
    return self;
}

- (BOOL)matchesDataType:(NSString*)title {
    if ([title isEqualToString:@"Stazioni"]) {
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
            marker = @"station_logo_small.png";
        } else {
            marker = [marker stringByReplacingOccurrencesOfString:@"_normal"
                                                       withString:@"_mini"];
        }
        [ret addObject:@{
                         keys[@"user"]: @"xxxxx",
                         keys[@"title"]: [NSString stringWithFormat:@"Stazione %@", tweet[@"id"]],
                         keys[@"altitude"]: [NSString stringWithFormat:@"%f", height],
                         keys[@"url"]: [NSString stringWithFormat:@"http://maps.google.com/maps?ll=%@,%@" , [self getLatitude:tweet], [self getLongitude:tweet]],
                         keys[@"latitude"]: [self getLatitude:tweet],
                         keys[@"longitude"]: [self getLongitude:tweet],
                         keys[@"marker"]: marker,
                         keys[@"logo"]: @"station_logo.png",
                         keys[@"stationid"]: tweet[@"id"]}];
        
    }
    return ret;
}

@end
