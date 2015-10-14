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
//  DataSource.m
//  Mixare
//
//  Created by Aswin Ly on 24-09-12.
//

#import "DataSource.h"
#import <FacebookSDK/FacebookSDK.h>
#import "STTwitter.h"

typedef void (^accountChooserBlock_t)(ACAccount *account, NSString *errorMessage); // don't bother with NSError for that

@interface DataSource ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *iOSAccounts;
@property (nonatomic, strong) accountChooserBlock_t accountChooserBlock;
@end

@implementation DataSource

@synthesize title, jsonUrl, activated, locked, positions, logo;

/***
 *
 *  CONSTRUCTOR
 *
 ***/
- (id)initTitle:(NSString*)tit jsonUrl:(NSString*)url locked:(BOOL)lock {
    self = [super init];
    if(self) {
        loadingView = [[LoadingView alloc] initWithLabel:@"Loading..."];
        title = tit;
        jsonUrl = url;
        activated = YES;
        locked = lock;
        positions = [[NSMutableArray alloc] init];
        
        self.accountStore = [[ACAccountStore alloc] init];
        
    }
    return self;
}

- (void) showloadingView
{
    [loadingView show];
}

- (void) hideloadingView
{
    [loadingView dismiss];
}

/***
 *
 *  PUBLIC: (Re)create the position objects (for PoiItem and MapAnnotations views)
 *  (Called by DataConverter)
 *
 ***/

- (void)refreshPositionsEventi:(NSMutableArray*)results {
    [positions removeAllObjects];
    
    if ([title isEqualToString:@"Eventi"] == YES) {
        [self setListLogo:@"calendar.png"];
    }
    
    positions = [[NSMutableArray alloc] init];
    for (NSDictionary *poi in results) {
        CGFloat alt = [[poi valueForKey:@"alt"] floatValue];
        float lat = [[poi valueForKey:@"lat"] floatValue];
        float lon = [[poi valueForKey:@"lon"] floatValue];
        Position *newPosition = [[Position alloc] initWithTitle:[poi valueForKey:@"title"] withSummary:[poi valueForKey:@"sum"] withUrl:[poi valueForKey:@"url"] withLatitude:lat withLongitude:lon withAltitude:alt withdatainizio:[poi valueForKey:@"Datainizio"] withcategoria:[poi valueForKey:@"Categoria"] withSource:self];
                             
        if (poi[@"imagemarker"] != nil) {
            [newPosition setMarker:poi[@"imagemarker"]];
        }
        if (poi[@"sid"] != nil) {
            [newPosition updateStationId:[poi valueForKey:@"sid"]];
        }
        if (poi[@"percorso"] != nil) {
            [newPosition updatePercorsoId:[poi valueForKey:@"percorso"]];
        }
        [positions addObject:newPosition];
    }
    NSLog(@"positions count: %d", [positions count]);
}

- (void)refreshPositions:(NSMutableArray*)results {
    [positions removeAllObjects];
    
    if ([title isEqualToString:@"Wikipedia"] == YES) {
        [self setListLogo:@"wikipedia_logo.png"];
    }
    else if ([title isEqualToString:@"Google Addresses"] == YES) {
        [self setListLogo:@"buzz_logo.png"];
    }
    else if ([title isEqualToString:@"Stazioni"] == YES) {
        [self setListLogo:@"station_logo.png"];
    }
    else if ([title isEqualToString:@"Autobus"] == YES) {
        [self setListLogo:@"autobus_logo.png"];
    }
    else if ([title isEqualToString:@"Facebook"] == YES) {
        [self setListLogo:@"facebook_logo.png"];
    }
    else if ([title isEqualToString:@"Carburanti"] == YES) {
        [self setListLogo:@"fluel_logo.png"];
    }
    else if ([title isEqualToString:@"Twitter"] == YES) {
        [self setListLogo:@"twitter_logo.png"];
    }
    else if ([title isEqualToString:@"Sagre"] == YES) {
        [self setListLogo:@"wine_icon.png"];
    }
    else if ([title isEqualToString:@"Murales"] == YES) {
        [self setListLogo:@"murales_logo.png"];
    }
    else if ([title isEqualToString:@"camping"] == YES) {
        [self setListLogo:@"camping.png"];
    }
    else if ([title isEqualToString:@"pub"] == YES) {
        [self setListLogo:@"pub.png"];
    }
    else if ([title isEqualToString:@"chalet"] == YES) {
        [self setListLogo:@"chalet"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Guest House", nil)] == YES) {
        [self setListLogo:@"empty.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"AroundMe(max 5km)", nil)] == YES) {
        [self setListLogo:@"empity.png"];
    }
    else if ([title isEqualToString:@"Hotel"] == YES) {
        [self setListLogo:@"hotel.png"];
    }
    else if ([title isEqualToString:@"Motel"] == YES) {
        [self setListLogo:@"motel.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Youth-Hostel", nil)] == YES) {
        [self setListLogo:@"youth-hostelpng"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Shelter", nil)] == YES) {
        [self setListLogo:@"shelter.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"College", nil)] == YES) {
        [self setListLogo:@"empty.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"School", nil)] == YES) {
        [self setListLogo:@"school.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Kindergarten", nil)] == YES) {
        [self setListLogo:@"kindergarten.png"];
    }
    else if ([title isEqualToString:@"Bar"] == YES) {
        [self setListLogo:@"bar.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Beergarden", nil)] == YES) {
        [self setListLogo:@"biergarten.png"];
    }
    else if ([title isEqualToString:@"Cafè"] == YES) {
        [self setListLogo:@"cafe.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Fast food", nil)] == YES) {
        [self setListLogo:@"fast_food.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Ice cream", nil)] == YES) {
        [self setListLogo:@"ice_cream.png"];
    }
    else if ([title isEqualToString:@"Pizza"] == YES) {
        [self setListLogo:@"pizza.png"];
    }
    else if ([title isEqualToString:@"Pub"] == YES) {
        [self setListLogo:@"pub.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Restaurant", nil)] == YES) {
        [self setListLogo:@"restaurant.png"];
    }
    else if ([title isEqualToString:@"Snacks"] == YES) {
        [self setListLogo:@"snacks.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Chemist", nil)] == YES) {
        [self setListLogo:@"chemist.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Dentist", nil)] == YES) {
        [self setListLogo:@"dentist.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Doctor", nil)] == YES) {
        [self setListLogo:@"doctor.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Emergency", nil)] == YES) {
        [self setListLogo:@"emergency.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Hearing aid", nil)] == YES) {
        [self setListLogo:@"hearing_aid.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Hospital", nil)] == YES) {
        [self setListLogo:@"hospital.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Optician", nil)] == YES) {
        [self setListLogo:@"optician.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Arts Centre", nil)] == YES) {
        [self setListLogo:@"arts_centre.png"];
    }
    else if ([title isEqualToString:@"Cinema"] == YES) {
        [self setListLogo:@"cinema.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Fishing", nil)] == YES) {
        [self setListLogo:@"fish.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Music venue", nil)] == YES) {
        [self setListLogo:@"music_venue.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Nature Reserve", nil)] == YES) {
        [self setListLogo:@"nature_reserve.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Park", nil)] == YES) {
        [self setListLogo:@"park.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Picnic site", nil)] == YES) {
        [self setListLogo:@"picnic_site.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Playground", nil)] == YES) {
        [self setListLogo:@"playground.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Theater", nil)] == YES) {
        [self setListLogo:@"theater.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Theme park", nil)] == YES) {
        [self setListLogo:@"theme_park.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Water park", nil)] == YES) {
        [self setListLogo:@"water_park.png"];
    }
    else if ([title isEqualToString:@"Zoo"] == YES) {
        [self setListLogo:@"zoo.png"];
    }
    else if ([title isEqualToString:@"ATM"] == YES) {
        [self setListLogo:@"atm.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Bank", nil)] == YES) {
        [self setListLogo:@"bank.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Exchange", nil)] == YES) {
        [self setListLogo:@"exchange.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Religion", nil)] == YES) {
        [self setListLogo:@"religion.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Administration", nil)] == YES) {
        [self setListLogo:@"administration.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Shop", nil)] == YES) {
        [self setListLogo:@"shop.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Bakery", nil)] == YES) {
        [self setListLogo:@"bakery.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Beverages", nil)] == YES) {
        [self setListLogo:@"beverages.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Books", nil)] == YES) {
        [self setListLogo:@"books.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Butcher", nil)] == YES) {
        [self setListLogo:@"butcher.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Clothes", nil)] == YES) {
        [self setListLogo:@"clothes.png"];
    }
    else if ([title isEqualToString:@"Computer"] == YES) {
        [self setListLogo:@"computers.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Confectioner", nil)] == YES) {
        [self setListLogo:@"confectioner.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Department store", nil)] == YES) {
        [self setListLogo:@"department_store.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Doit your self", nil)] == YES) {
        [self setListLogo:@"doityourself.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Florist", nil)] == YES) {
        [self setListLogo:@"florist.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Fish", nil)] == YES) {
        [self setListLogo:@"fish.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Flea Market", nil)] == YES) {
        [self setListLogo:@"flea_market.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Fruits", nil)] == YES) {
        [self setListLogo:@"fruits.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Furniture", nil)] == YES) {
        [self setListLogo:@"furniture.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Games", nil)] == YES) {
        [self setListLogo:@"games.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Garden Centre", nil)] == YES) {
        [self setListLogo:@"garden_centre.png"];
    }
    else if ([title isEqualToString:@"Hi-Fi"] == YES) {
        [self setListLogo:@"hifi.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Kiosk", nil)] == YES) {
        [self setListLogo:@"kiosk.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"lighting", nil)] == YES) {
        [self setListLogo:@"lighting.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Mall", nil)] == YES) {
        [self setListLogo:@"mall.png"];
    }
    else if ([title isEqualToString:@"Market"] == YES) {
        [self setListLogo:@"market.png"];
    }
    else if ([title isEqualToString:@"Media"] == YES) {
        [self setListLogo:@"media.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Music", nil)] == YES) {
        [self setListLogo:@"music.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Perfumery", nil)] == YES) {
        [self setListLogo:@"perfumery.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Pet Shop", nil)] == YES) {
        [self setListLogo:@"pet_shop.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Print Shop", nil)] == YES) {
        [self setListLogo:@"print_shop.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Print Store", nil)] == YES) {
        [self setListLogo:@"print_store.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Stationery", nil)] == YES) {
        [self setListLogo:@"stationery.png"];
    }
    else if ([title isEqualToString:@"Sports"] == YES) {
        [self setListLogo:@"sports.png"];
    }
    else if ([title isEqualToString:@"Supermarket"] == YES) {
        [self setListLogo:@"supermarket.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Toys", nil)] == YES) {
        [self setListLogo:@"toys.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Vending Machine", nil)] == YES) {
        [self setListLogo:@"vending_machine.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Wine", nil)] == YES) {
        [self setListLogo:@"wine.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Tourism", nil)] == YES) {
        [self setListLogo:@"empty.png"];
    }
    else if ([title isEqualToString:NSLocalizedString(@"Parking", nil)] == YES) {
        [self setListLogo:@"parking.png"];
    }
    else if ([title isEqualToString:@"Eventi"] == YES) {
        [self setListLogo:@"calendar.png"];
    }
    


    
//    if (results.count > 0) {
//        if ([results[0] valueForKey:@"logo"] != nil && logo == nil) {
//            [self setListLogo:[results[0] valueForKey:@"logo"]];
//        }
//    }
    positions = [[NSMutableArray alloc] init];
    for (NSDictionary *poi in results) {
        CGFloat alt = [[poi valueForKey:@"alt"] floatValue];
        float lat = [[poi valueForKey:@"lat"] floatValue];
        float lon = [[poi valueForKey:@"lon"] floatValue];
        Position *newPosition = [[Position alloc] initWithTitle:[poi valueForKey:@"title"] withSummary:[poi valueForKey:@"sum"] withUrl:[poi valueForKey:@"url"] withLatitude:lat withLongitude:lon withAltitude:alt withSource:self];
        if (poi[@"imagemarker"] != nil) {
            [newPosition setMarker:poi[@"imagemarker"]];
        }
        if (poi[@"sid"] != nil) {
            [newPosition updateStationId:[poi valueForKey:@"sid"]];
        }
        if (poi[@"percorso"] != nil) {
            [newPosition updatePercorsoId:[poi valueForKey:@"percorso"]];
        }
        [positions addObject:newPosition];
    }
    NSLog(@"positions count: %d", [positions count]);
}

- (void)setListLogo:(NSString*)marker {
    if ([self isImageUrl:marker]) {
        NSURL *urls = [NSURL URLWithString:marker];
        NSData *data = [NSData dataWithContentsOfURL:urls];
        logo = [UIImage imageWithData:data];
    } else if (marker != nil) {
        logo = [UIImage imageNamed:marker];
        if (logo == nil) {
            logo = [UIImage imageWithContentsOfFile:marker];
        }
    }
}

- (BOOL)isImageUrl:(NSString*)urls {
    NSArray *elements = @[@"http", @"."];
    for (NSString *element in elements) {
        if ([urls rangeOfString:element].location == NSNotFound) {
            return NO;
        }
    }
    NSArray *possibleFiles = @[@"jpeg", @"png", @"jpg"];
    for (NSString *file in possibleFiles) {
        if ([urls rangeOfString:file].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

- (void) refreshPositionsFB:(CLLocation*)loc currentRadius:(float)rad
{
//    [self showloadingView];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded || FBSession.activeSession.state == FBSessionStateOpen )
    {
        [FBRequestConnection startWithGraphPath:@"me/events/not_replied?fields=owner,description,cover,name,place" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSLog(@"FACEBOOK EVENTS INFO %@", result);
                NSMutableArray *array = [NSMutableArray new];
                for (NSDictionary *data in result[@"data"]) {
                    [array addObject:data];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self refreshForFacebook:array location:loc currentRadius:rad];
                });
            } else {
                NSLog(@"Failed to get FB events.");
            }
        }];
    }
}

- (void) refreshForFacebook:(NSMutableArray *)results location:(CLLocation *)loc currentRadius:(float)rad
{
    [positions removeAllObjects];
    [self setListLogo:@"facebook_logo.png"];
    
    positions = [[NSMutableArray alloc] init];
    for (NSDictionary *poi in results) {
        NSString *eventTitle = [poi objectForKey:@"name"];
        NSString *description = [poi objectForKey:@"description"];
        NSString *startTime = [poi objectForKey:@"start_time"];
        
        NSDictionary *ownerDic = [poi objectForKey:@"owner"];
        NSString *ownerName = [ownerDic objectForKey:@"name"];
        
        NSDictionary *coverDic = [poi objectForKey:@"cover"];
        NSString *coverURLString = [coverDic objectForKey:@"source"];
        
        NSDictionary *placeDic = [poi objectForKey:@"place"];
        if ([placeDic objectForKey:@"location"]) {
            float lat = [[[placeDic objectForKey:@"location"] objectForKey:@"latitude"] floatValue];
            float lon = [[[placeDic objectForKey:@"location"] objectForKey:@"longitude"] floatValue];
            NSString *add = [placeDic objectForKey:@"name"];
            CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
            CLLocationDistance distance = [loc1 distanceFromLocation:loc];
            if (distance/1000.0 > rad) {
                continue;
            }
            
            Position *newPosition = [[Position alloc] initWithTitle:eventTitle withSummary:description withUrl:[NSString stringWithFormat:@"https://www.facebook.com/events/%@", [poi objectForKey:@"id"]] withLatitude:lat withLongitude:lon withAltitude:1.0 withCover:coverURLString withTime:startTime withOwnerName:ownerName withAddress:add withSource:self];
            [newPosition setMarker:@"facebook_logo_small.png"];
            
            [positions addObject:newPosition];
        }
        else
        {
            NSString *add = [placeDic objectForKey:@"name"];
            CLLocationCoordinate2D coord = [self getLocationFromAddress:add];
            float lat = coord.latitude;
            float lon = coord.longitude;

            CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
            CLLocationDistance distance = [loc1 distanceFromLocation:loc];
            if (distance/1000.0 > rad) {
                continue;
            }
            
            Position *newPosition = [[Position alloc] initWithTitle:eventTitle withSummary:description withUrl:[NSString stringWithFormat:@"https://www.facebook.com/events/%@", [poi objectForKey:@"id"]] withLatitude:lat withLongitude:lon withAltitude:1.0 withCover:coverURLString withTime:startTime withOwnerName:ownerName withAddress:add withSource:self];
            [newPosition setMarker:@"facebook_logo_small.png"];
            
            [positions addObject:newPosition];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotData" object:nil];
    
//    [self hideloadingView];
    NSLog(@"positions count: %d", [positions count]);
}

- (CLLocationCoordinate2D) getLocationFromAddress:(NSString*) address
{
    NSError *error = nil;
    CLLocationCoordinate2D _location;
    
    NSString *lookUpString;
    NSDictionary *jsonDict;
    NSData *jsonResponse;
    NSArray *locationArray;
    
    lookUpString = [[NSString alloc] initWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", address];
    
    lookUpString = [lookUpString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    jsonResponse = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:lookUpString]];
    
    if (jsonResponse == nil) {
        return CLLocationCoordinate2DMake(0, 0);
    }
    jsonDict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    
    locationArray = [[NSArray alloc] init];
    locationArray = [[[jsonDict valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"];
    
    @try {
        locationArray = [locationArray objectAtIndex:0];
        NSLog(@" LOADING, %lu, %lu, %lu", (unsigned long)[locationArray count], (unsigned long)[jsonDict count], (unsigned long)[jsonResponse length]);
    }
    @catch (NSException *exception) {
        NSLog(@"ERROR LOADING, %lu, %lu, %lu", (unsigned long)[locationArray count], (unsigned long)[jsonDict count], (unsigned long)[jsonResponse length]);
        
    }
    @finally {
        
    }
    
    NSString *latitudeString = [[NSString alloc] init];
    latitudeString = [locationArray valueForKey:@"lat"];
    
    NSString *longitudeString = [[NSString alloc] init];
    longitudeString = [locationArray valueForKey:@"lng"];
    
    
    NSString *statusString = [[NSString alloc] init];
    statusString = [jsonDict valueForKey:@"status"];
    
    
    double latitude = 0.0;
    double longitude = 0.0;
    
    if ([statusString isEqualToString:@"OK"])
    {
        latitude = [latitudeString doubleValue];
        longitude = [longitudeString doubleValue];
    }
    
    else
        NSLog(@"Something went wrong, couldn't find address");
    
    
    _location.longitude = longitude;
    _location.latitude = latitude;
    
    return _location;
    
}

- (void)searchWithGeo:(CLLocation*)loc radius:(float)rad {
    
    [_twitter getSearchTweetsWithQuery:@"" geocode:[NSString stringWithFormat:@"%f,%f,%fmi", loc.coordinate.latitude, loc.coordinate.longitude, rad/1.609344] lang:nil locale:nil resultType:nil count:nil until:nil sinceID:nil maxID:nil includeEntities:nil callback:nil successBlock:^(NSDictionary *searchMetadata, NSArray *statuses)
     {
         NSLog(@"-- places: %@", searchMetadata);
         NSLog(@"+++ statuses %@", statuses);
         
         [self putPositions:statuses];
     } errorBlock:^(NSError *error) {
         NSLog(@"-- %@", [error localizedDescription]);
     }];
}

- (NSString *)passTimeFromCreateDateString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE MMMM dd HH:mm:ss xxx yyyy";
    
    NSDate *fromDate = [dateFormatter dateFromString:dateString];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:timeStamp];
    
    NSDateComponents *components;
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond
                                                 fromDate: fromDate toDate: currentDate options: 0];
    NSInteger secs = [components second];
    if (secs < 60) {
        return [NSString stringWithFormat:@"%lds ago", (long)secs];
    }
    
    NSInteger days = secs / 3600 / 24;
    if (days >= 1) {
        return [NSString stringWithFormat:@"%ldday ago", (long)days];
    }
    
    NSInteger hours = secs / 3600;
    if (hours >=1 ) {
        return [NSString stringWithFormat:@"%ldhr ago", (long)hours];
    }
    
    NSInteger mins = secs / 60;
    return [NSString stringWithFormat:@"%ldmin ago", (long)mins];
    
    return [dateFormatter stringFromDate:fromDate];
}

- (void)putPositions:(NSArray *)arr
{
    [positions removeAllObjects];
    [self setListLogo:@"facebook_logo.png"];
    
    positions = [[NSMutableArray alloc] init];
    for (NSDictionary *poi in arr) {

        NSString *geo = [poi objectForKey:@"geo"];
        if ([poi objectForKey:@"geo"] == nil || geo == (id)[NSNull null]) {
            continue;
        }
        

//        NSArray *coord = [geo objectForKey:@"coordinates"];
        
        float lat = [[[[poi objectForKey:@"geo"] objectForKey:@"coordinates"] objectAtIndex:0] floatValue];
        float lng = [[[[poi objectForKey:@"geo"] objectForKey:@"coordinates"] objectAtIndex:1] floatValue];
        
        NSString *text = [poi objectForKey:@"text"];
        NSString *passTime = [self passTimeFromCreateDateString:[poi objectForKey:@"created_at"]];
        
        NSDictionary *userDic =[poi objectForKey:@"user"];
        NSString *userRealName = [userDic objectForKey:@"name"];
        NSString *userProfileUrl = [userDic objectForKey:@"profile_image_url"];
        
        NSString *twId = [poi objectForKey:@"id_str"];
        NSString *username = [userDic objectForKey:@"screen_name"];
        NSString *twUrl = [NSString stringWithFormat:@"https://twitter.com/%@/status/%@", username, twId];
                
        Position *newPosition = [[Position alloc] initWithTitle:text withSummary:@"" withUrl:twUrl withLatitude:lat withLongitude:lng withAltitude:1.0 withCover:userProfileUrl withTime:passTime withOwnerName:userRealName withSource:self];
        [newPosition setMarker:@"twitter_logo_small.png"];
        
        [positions addObject:newPosition];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotData" object:nil];        
}

- (void) refreshPositionsTW:(CLLocation *)loc currentRadius:(float)rad
{
    __weak __typeof(self) weakSelf = self;
    
    self.accountChooserBlock = ^(ACAccount *account, NSString *errorMessage) {
        
        NSString *status = nil;
        if(account) {
            status = [NSString stringWithFormat:@"Did select %@", account.username];
            
            [weakSelf loginWithiOSAccount:account location:loc radius:rad];
        } else {
            status = errorMessage;
        }
        
    };
    
    [self chooseAccount];
}

- (void)loginWithiOSAccount:(ACAccount *)account location:(CLLocation *)loc radius:(float)rad {
    
    self.twitter = [STTwitterAPI twitterAPIOSWithAccount:account];
    
    [_twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        
        [self searchWithGeo:loc radius:rad];
        
    } errorBlock:^(NSError *error) {

    }];
    
}

- (void)chooseAccount {
    
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreRequestCompletionHandler = ^(BOOL granted, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if(granted == NO) {
                _accountChooserBlock(nil, @"Acccess not granted.");
                return;
            }
            
            self.iOSAccounts = [_accountStore accountsWithAccountType:accountType];

            if([_iOSAccounts count] == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ops!" message:@"Sorry, First you need to add your account in Settings App." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }
            else if([_iOSAccounts count] == 1) {
                ACAccount *account = [_iOSAccounts lastObject];
                _accountChooserBlock(account, nil);
            } else {
                ACAccount *account = [_iOSAccounts lastObject];
                _accountChooserBlock(account, nil);
//                UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Select an account:"
//                                                                delegate:self
//                                                       cancelButtonTitle:@"Cancel"
//                                                  destructiveButtonTitle:nil otherButtonTitles:nil];
//                for(ACAccount *account in _iOSAccounts) {
//                    [as addButtonWithTitle:[NSString stringWithFormat:@"@%@", account.username]];
//                }
//                [as showInView:self.view.window];
            }
        }];
    };
    
#if TARGET_OS_IPHONE &&  (__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0)
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_6_0) {
        [self.accountStore requestAccessToAccountsWithType:accountType
                                     withCompletionHandler:accountStoreRequestCompletionHandler];
    } else {
        [self.accountStore requestAccessToAccountsWithType:accountType
                                                   options:NULL
                                                completion:accountStoreRequestCompletionHandler];
    }
#else
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:accountStoreRequestCompletionHandler];
#endif
    
}

@end
