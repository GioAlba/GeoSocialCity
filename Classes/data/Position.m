/*
 * Copyright (C) 2010- Peer internet solutions
 *
 * This file is part of mixare.
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>
 */
//
//  Position.m
//  Mixare
//
//  Created by Aswin Ly on 24-09-12.
//

#import "Position.h"
#import "DataSource.h"
#import "GlobalSettings.h"

@implementation Position

@synthesize mapViewAnnotation, poiItem, title, summary, url, source, longitude, altitude, latitude, image, coverUrl, startTime, ownerName, address;

- (id)initWithTitle:(NSString*)tit withSummary:(NSString*)sum withUrl:(NSString*)u withLatitude:(float)lat withLongitude:(float)lon withAltitude:(CGFloat)alt withSource:(DataSource*)sour {
    self = [super init];
    title = tit;
    summary = sum;
    if ([u rangeOfString:@"http://maps.google.com/maps"].location != NSNotFound) {
        url = [NSString stringWithFormat:@"https://www.google.com/maps/dir/%f,%f/%f,%f", [GlobalSettings sharedInstance].coordinate.latitude, [GlobalSettings sharedInstance].coordinate.longitude, lat, lon];
    }
    else
        url = u;
    latitude = lat;
    longitude = lon;
    altitude = alt;
    source = sour;
    if (sour.title == @"Eventi"){
        _isEvent = YES;
    }
    _isFacebookEvent = NO;
    _isTwitterEvent = NO;
    
    [self initMarkerAndMapAnnotation];
    return self;
}

- (id)initWithTitle:(NSString*)tit withSummary:(NSString*)sum withUrl:(NSString*)u withLatitude:(float)lat withLongitude:(float)lon withAltitude:(CGFloat)alt withdatainizio:(NSString*)Datainizio withcategoria:(NSString *)Categoria withSource:(DataSource*)sour {
    self = [super init];
    title = tit;
    summary = sum;
    if ([u rangeOfString:@"http://maps.google.com/maps"].location != NSNotFound) {
        url = [NSString stringWithFormat:@"https://www.google.com/maps/dir/%f,%f/%f,%f", [GlobalSettings sharedInstance].coordinate.latitude, [GlobalSettings sharedInstance].coordinate.longitude, lat, lon];
    }
    else
        url = u;
    latitude = lat;
    longitude = lon;
    altitude = alt;
    source = sour;
    if (sour.title == @"Eventi"){
        _isEvent = YES;
        _Datainizio = Datainizio;
        _Categoria = Categoria;
    }
    _isFacebookEvent = NO;
    _isTwitterEvent = NO;
    
    [self initMarkerAndMapAnnotation];
    return self;
}

- (id)initWithTitle:(NSString *)tit withSummary:(NSString *)sum withUrl:(NSString *)u withLatitude:(float)lat withLongitude:(float)lon withAltitude:(CGFloat)alt withCover:(NSString *)coverurl withTime:(NSString *)starttime withOwnerName:(NSString *)ownername withAddress:(NSString *)addr withSource:(DataSource *)sour
{
    self = [super init];
    title = tit;
    summary = sum;
    if ([u rangeOfString:@"http://maps.google.com/maps"].location != NSNotFound) {
        url = [NSString stringWithFormat:@"https://www.google.com/maps/dir/%f,%f/%f,%f", [GlobalSettings sharedInstance].coordinate.latitude, [GlobalSettings sharedInstance].coordinate.longitude, lat, lon];
    }
    else
        url = u;
    latitude = lat;
    longitude = lon;
    altitude = alt;
    source = sour;
    coverUrl = coverurl;
    startTime = starttime;
    ownerName = ownername;
    address = addr;
    _isFacebookEvent = YES;
    _isTwitterEvent = NO;
    
    [self initMarkerAndMapAnnotation];
    return self;
}

- (id)initWithTitle:(NSString*)tit withSummary:(NSString*)sum withUrl:(NSString*)u withLatitude:(float)lat withLongitude:(float)lon withAltitude:(CGFloat)alt withCover:(NSString *)coverurl withTime:(NSString *)passTime withOwnerName:(NSString *)ownername withSource:(DataSource*)sour
{
    self = [super init];
    title = tit;
    summary = sum;
    
    if ([u rangeOfString:@"http://maps.google.com/maps"].location != NSNotFound) {
        url = [NSString stringWithFormat:@"https://www.google.com/maps/dir/%f,%f/%f,%f", [GlobalSettings sharedInstance].coordinate.latitude, [GlobalSettings sharedInstance].coordinate.longitude, lat, lon];
    }
    else
        url = u;
    
    latitude = lat;
    longitude = lon;
    altitude = alt;
    source = sour;
    coverUrl = coverurl;
    startTime = passTime;
    ownerName = ownername;

    _isFacebookEvent = NO;
    _isTwitterEvent = YES;
    
    [self initMarkerAndMapAnnotation];
    return self;
}

- (void)initMarkerAndMapAnnotation {
    mapViewAnnotation = [[MapViewAnnotation alloc] initWithLatitude:latitude longitude:longitude position:self];
    [mapViewAnnotation setTitle:title];
    [mapViewAnnotation setSubTitle:summary];
    if ([title rangeOfString:@"Stazione"].location != NSNotFound) {
        mapViewAnnotation.isStation = YES;
    }
    else
        mapViewAnnotation.isStation = NO;

    if ([title rangeOfString:@"Autobus"].location != NSNotFound) {
        mapViewAnnotation.isAutoBus = YES;
    }
    else
        mapViewAnnotation.isAutoBus = NO;

    mapViewAnnotation.isFacebookEvent = _isFacebookEvent;
    mapViewAnnotation.isTwitterEvent = _isTwitterEvent;
    mapViewAnnotation.fbEventURL = url;
    mapViewAnnotation.twEventURL = url;
    poiItem = [[PoiItem alloc] initWithLatitude:latitude longitude:longitude altitude:altitude position:self];
}

- (void)updateStationId:(NSString *)stationid
{
    self.stationId = stationid;
    mapViewAnnotation.stationId = stationid;
}
- (void)updatePercorsoId:(NSString *)percorsoid
{
    self.percorsoId = percorsoid;
    mapViewAnnotation.percorsoId = percorsoid;
}

- (void)setMarker:(NSString*)marker {
    if ([self isImageUrl:marker]) {
        NSURL *urls = [NSURL URLWithString:marker];
        NSData *data = [NSData dataWithContentsOfURL:urls];
        image = [self imageWithImage:[UIImage imageWithData:data] scaledToSize:CGSizeMake(30, 30)];
    } else if (marker != nil) {
        image = [UIImage imageNamed:marker];
    }
}

- (BOOL)isImageUrl:(NSString*)urls {
    NSArray *elements = @[@"http", @"."];
    for (NSString *element in elements) {
        if ([urls rangeOfString:element].location == NSNotFound) {
            return NO;
        }
    }
    NSArray *possibleFiles = @[@"jpeg", @"png", @"jpg", @"_mini"];
    for (NSString *file in possibleFiles) {
        if ([urls rangeOfString:file].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

- (UIImage *)imageWithImage:(UIImage *)img scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
