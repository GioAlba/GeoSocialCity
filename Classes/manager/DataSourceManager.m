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
//  DataSourceManager.m
//  Mixare
//
//  Created by Aswin Ly on 05-10-12.
//

#import "DataSourceManager.h"
#import "DataSourceList.h"

@implementation DataSourceManager

@synthesize dataSources;

- (id)init {
    self = [super init];
    [self loadDataSources];
    return self;
}

- (DataSource*)getDataSourceByTitle:(NSString*)title {
    for (DataSource *data in dataSources) {
        if ([data.title isEqualToString:title]) {
            return data;
        }
    }
    return nil;
}

- (NSMutableArray*)getActivatedSources {
    NSMutableArray *sources = [[NSMutableArray alloc] init];
    for (DataSource *source in dataSources) {
        if (source.activated) {
            [sources addObject:source];
        }
    }
    return sources;
}

- (DataSource*)createDataSource:(NSString *)title dataUrl:(NSString *)url {
    if ([self getDataSourceByTitle:title] == nil) {
        DataSource *data = [[DataSource alloc] initTitle:title jsonUrl:url locked:NO];
        data.activated = NO;
        [dataSources addObject:data];
        [self writeDataSources];
        return data;
    } 
    return nil;
}

- (void)writeDataSources {
    NSMutableArray *saveArray = [[NSMutableArray alloc] init];
    for (DataSource *data in dataSources) {
        if (!data.locked) {
            [saveArray addObject:@{@"title":data.title, @"url":data.jsonUrl}];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"dataSources"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadDataSources {
    NSArray *loadedData = [[NSUserDefaults standardUserDefaults] arrayForKey:@"dataSources"];
    dataSources = [NSMutableArray array];
    for (DataSource *data in [[DataSourceList getInstance] dataSources]) {
        if ([data.title isEqualToString:@"Facebook"] == YES || [data.title isEqualToString:@"Twitter"] == YES ) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"facebookid"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
       
        if ([data.title isEqualToString:@"Autobus"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Stazioni"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
 
        if ([data.title isEqualToString:@"Carburanti"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Guest House", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Snacks"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Bank", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Hi-Fi", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Hotel"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Motel"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Youth-Hostel", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Shelter", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"College", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"School", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Kindergarten", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Beergarden", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Ice cream", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Pizza"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Pub"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Restaurant", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Chemist", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Dentist", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Doctor", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Emergency", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Hearing aid", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Hospital", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Optician", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Pharmacy", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Arts Centre", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Cinema"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Fishing", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Garden", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Music venue", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Nature Reserve", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Park", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Picnic site", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Playground", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Theater", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Theme park", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Water park", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Zoo"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"ATM"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Exchange", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Religion", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Administration", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Shop", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Bakery", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Fast food", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Beverages", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Books", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Butcher", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Clothes", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Computer"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Confectioner", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Department store", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Doit your self", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Florist", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Fish", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Flea Market", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Fruits", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Furniture", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Games", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Garden Centre", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Kiosk", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Laundry", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"lighting", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Mall", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Market"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Media"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Music", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Perfumery", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Pet Shop", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Print Shop", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Print Store", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Stationery", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Sports"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Supermarket"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Toys", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Vending Machine", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Wine", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Tourism", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Parking", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Bar"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Cafè"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Murales"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"Guest House", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:NSLocalizedString(@"AroundMe(max 5km)", nil)] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"pub"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"camping"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"chalet"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Sagre"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Eventi"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }
        if ([data.title isEqualToString:@"Wikipedia"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"title"];
            if (facebookId == nil || facebookId.length == 0) {
                data.activated = NO;
                data.locked = YES;
            }
            
        }

        [dataSources addObject:data];
    }
    for (NSDictionary *data in loadedData) {
        if ([data[@"title"] isEqualToString:@"Facebook"] == YES) {
            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
            NSString *facebookId = [df objectForKey:@"facebookid"];
            if (facebookId == nil || facebookId.length == 0) {
                DataSource *source = [[DataSource alloc] initTitle:data[@"title"] jsonUrl:data[@"url"] locked:YES];
                [dataSources addObject:source];
            }
            else
            {
                DataSource *source = [[DataSource alloc] initTitle:data[@"title"] jsonUrl:data[@"url"] locked:NO];
                [dataSources addObject:source];
            }
        }
    }
}

- (void)deleteDataSource:(DataSource*)source {
    if (!source.locked) {
        [dataSources removeObject:source];
    }
    [self writeDataSources];
}

- (void)deactivateAllSources {
    for (DataSource *data in dataSources) {
        data.activated = NO;
    }
}

- (void)clearLocalData {
    NSMutableArray *saveArray = [[NSMutableArray alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"dataSources"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
