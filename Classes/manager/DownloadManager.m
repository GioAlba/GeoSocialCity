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
//  DownloadManager.m
//  Mixare
//
//  Created by Aswin Ly on 15-10-12.
//

#import "DownloadManager.h"
#import "DataConverter.h"

@implementation DownloadManager

- (id)init {
    self = [super init];
    return self;
}

- (BOOL)radiusChanged:(float)rad {
    if (rad != lastDownloadedRadius) {
        return YES;
    }
    return NO;
}

- (BOOL)dataInputChanged:(NSMutableArray*)datas {
    if (![datas isEqual:lastDownloadedSources]) {
        return YES;
    }
    return NO;
}

- (BOOL)locationChanged:(CLLocation*)loc {
    if (lastDownloadedLocation.coordinate.latitude != loc.coordinate.latitude ||
            lastDownloadedLocation.coordinate.longitude != loc.coordinate.longitude) {
        return YES;
    }
    
    return NO;
}

- (void)download:(NSMutableArray*)datas currentLocation:(CLLocation*)loc currentRadius:(float)rad {
    if ([self locationChanged:loc] || [self dataInputChanged:datas] || [self radiusChanged:rad]) {
        NSMutableArray *downloadArray = [[NSMutableArray alloc] initWithArray:datas];
        if ([self dataInputChanged:datas]) {
            [downloadArray removeObjectsInArray:lastDownloadedSources];
        }
        NSString *paramatriOSM = @"osm";
        DataSource *pippo;
        for (DataSource *data in downloadArray) {
            if([data.title  isEqual: @"camping"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"camping"];
                pippo = data;
            }
            else if([data.title  isEqual: @"chalet"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"chalet"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Guest House", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"guest_house"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Youth-Hostel", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"youth_hostel"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Shelter", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"selter"];
                pippo = data;
            }
            else if([data.title  isEqual: @"Hotel"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"hotel"];
                pippo = data;
            }
            else if([data.title  isEqual: @"Motel"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"motel"];
                pippo = data;
            }
            else if([data.title  isEqual: @"pub"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"pub"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"College", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"college"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Pharmacy", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"pharmacy"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Garden", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"garden"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"School", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"school"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Kindergarten", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"asilo"];
                pippo = data;
            }
            else if([data.title  isEqual: @"Bar"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"bar"];
                pippo = data;
            }
            else if([data.title  isEqual: @"Pub"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"pub"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Beergarden", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"beergarden"];
                pippo = data;
            }
            else if([data.title  isEqual: @"Cafè"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"cafè"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Fast food", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"fast_food"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Ice cream", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"ice_cream"];
                pippo = data;
            }
            else if([data.title  isEqual: @"Pizza"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"pizza"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Restaurant", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"restaurant"];
                pippo = data;
            }
            else if([data.title  isEqual: @"Snacks"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"snacks"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Chemist",nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"chemist"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Dentist", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"dentist"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Doctor", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"doctor"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Emergency", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"emergency"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Hearing aid", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"hearing_aid"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Hospital", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"hospital"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Optician", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"optician"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Arts Centre", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"arts_centre"];
                pippo = data;
            }
            else if([data.title  isEqual: @"Cinema"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"cinema"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Fishing", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"fish"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Music venue", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"music_venue"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Nature Reserve", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"nature_reserve"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Park", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"park"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Picnic site", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"picnic_site"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Playground", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"playground"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Theater", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"theater"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Theme park", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"theme_park"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Water park", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"water_park"];
                pippo = data;
            }
            else if([data.title  isEqual: @"Zoo"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"zoo"];
                pippo = data;
            }
            else if([data.title  isEqual: @"ATM"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"atm"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Bank", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"bank"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Exchange", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"exchange"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Religion", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"religion"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Administration", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"administration"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Shop", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"shop"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Bakery", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"bakery"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Beverages", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"beverages"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Books", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"books"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Butcher", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"butcher"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Clothes", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"clothes"];
                pippo = data;
            }
            else if([data.title  isEqual: @"Computer"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"computer"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Confectioner", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"confectioner"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Department store", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"department_store"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Doit your self", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"doityourself"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Florist", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"florist"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Fish", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"fish"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Flea Market", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"flea_market"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Fruits", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"fruits"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Furniture", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"furniture"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Games", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"games"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Garden Centre", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"garden_centre"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Hi-Fi", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"hifi"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Kiosk", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"kiosk"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"lighting", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"lighting"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Mall", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"mall"];
                pippo = data;
            }
            else if([data.title  isEqual: @"Market"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"market"];
                pippo = data;
            }
            else if([data.title  isEqual: @"Media"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"clothes"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Music", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"music"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Perfumery", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"perfumery"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Pet Shop", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"pet_shop"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Print Shop", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"print_shop"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Print Store", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"print_store"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Stationery", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"stationery"];
                pippo = data;
            }
            else if([data.title  isEqual: @"Sports"]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"sports"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Supermarket", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"supermarket"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Toys", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"toys"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Vending Machine", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"vending_machine"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Wine", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"weine"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Tourism", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"sightseeing"];
                pippo = data;
            }
            else if([data.title  isEqual: NSLocalizedString(@"Parking", nil)]){
                paramatriOSM = [NSString stringWithFormat:@"%@;%@",paramatriOSM,@"parking"];
                pippo = data;
            }
           
            else{
            [[DataConverter getInstance] convertData:data currentLocation:loc currentRadius:rad];
            }
               
        }
        if (![paramatriOSM isEqualToString:@"osm"])
        {
            pippo.jsonUrl = [pippo.jsonUrl stringByReplacingOccurrencesOfString:@"PARAM_AMENITY" withString:paramatriOSM];
            [[DataConverter getInstance] convertData:pippo currentLocation:loc currentRadius:rad];
            
        }
        lastDownloadedLocation = loc;
        lastDownloadedRadius = rad;
        [lastDownloadedSources removeAllObjects];
        lastDownloadedSources = datas;
    }
}

- (void)redownload {
    for (DataSource *data in lastDownloadedSources) {
        [[DataConverter getInstance] convertData:data currentLocation:lastDownloadedLocation currentRadius:lastDownloadedRadius];
    }
}

- (void)redownloadStaionAndBus
{
    for (DataSource *data in lastDownloadedSources) {
        if ([data.title isEqualToString:@"Stazioni"] || [data.title isEqualToString:@"Autobus"] || [data.title isEqualToString:@"Facebook"]) {
            [[DataConverter getInstance] convertData:data currentLocation:lastDownloadedLocation currentRadius:lastDownloadedRadius];
        }
    }
}

@end
