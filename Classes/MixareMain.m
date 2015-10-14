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
//  MixareMain.m
//  Mixare
//
//  Created by Aswin Ly on 16-01-13.
//

#import "MixareMain.h"

/***
 *
 *  [ EXAMPLE HOW TO USE MIXARE iOS LIBRARY (as sub-project) ]
 *
 *  MixareMain.m is a demo start-up class.
 *  You can use this as an example.
 *
 ***/

// Initialize Mixare library, access to usable classes
#import <Mixare/Mixare.h>

/***
 *
 *  Own custom plugins to initialize
 *  There are 3 types of plugin you can make:
 *    * Bootstrap - will starts before Mixare. (example: own start view)
 *    * DataInput - to gain datasource by users. (example: barcodescanner)
 *    * DataProcessor - to manage the obtained data from datasource. (example: manage special wikipedia data from json)
 *  
 *  Read WIKI for more information.
 *
 ***/
// Own DataProcessor plugins
#import "GoogleAddressesProcessor.h"
#import "TwitterProcessor.h"
#import "WikipediaProcessor.h"
// Own DataInput plugins
#import "StandardInput.h"
#import "BarcodeInput.h"
// Own Bootstrap plugin
// On default (without plugins) BootView.m will be loaded

#import "StationProcessor.h"
#import "AutobusProcessor.h"
#import "FacebookProcessor.h"

#import "GlobalSettings.h"

#import <FacebookSDK/FacebookSDK.h>

@implementation MixareMain

- (id)init {
    self = [super init];
    
    [GlobalSettings sharedInstance].searchKey = @"";
    
    // To use your pre-initialized datasources, you have to add your source to the singleton class DataSourceList
    [[DataSourceList getInstance] addDataSource:@"Wikipedia" dataUrl:@"http://api.geonames.org/findNearbyWikipediaJSON?lat=PARAM_LAT&lng=PARAM_LON&radius=PARAM_RAD&maxRows=50&lang=PARAM_LANG&username=XXXXXX" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Twitter" dataUrl:@"http://search.twitter.com/search.json?geocode=PARAM_LAT,PARAM_LON,PARAM_RADkm" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Google Addresses" dataUrl:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=PARAM_LAT,PARAM_LON&sensor=true" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Facebook" dataUrl:@"http://XXXXXXX.it/webservice/CallStations.php?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Carburanti" dataUrl:@"http://XXXXXXX.it/getdata/carburanti.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Stazioni" dataUrl:@"http://XXXXXXX.it/webservice/CallStations.php?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Autobus" dataUrl:@"http://XXXXXXX.it/webservice/CallBus.php?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Murales" dataUrl:@"http://XXXXXXX.it/getdata/murales.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Sagre" dataUrl:@"http://XXXXXXX.it/getdata/cantine.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Eventi" dataUrl:@"http://XXXXXXX.it/getdata/eventi.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"AroundMe(max 5km)", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Tourism",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Parking",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"camping" dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"chalet" dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Guest House", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Hotel" dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Motel" dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Youth-Hostel", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Shelter", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"College", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"School", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Kindergarten", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Bar"  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Beergarden", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Cafè"  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Fast food", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Ice cream", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Pizza"  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Pub" dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Restaurant", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Snacks" dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Chemist", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Dentist", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Doctor", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Emergency", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Hearing aid", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Hospital", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Optician", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Pharmacy", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Arts Centre", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Cinema" dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Fishing", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Garden", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Music venue", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Nature Reserve", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Park", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Picnic site", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Playground", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Theater", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Theme park", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Water park", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Zoo"  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"ATM" dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Bank", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Exchange", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Religion", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Administration", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Shop", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Bakery", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Beverages", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Books", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Butcher", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Clothes", nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Computer"  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Confectioner",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Department store",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Doit your self",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Florist",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Fish",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Flea Market",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Fruits",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Furniture",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Games",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Garden Centre",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Hi-Fi"  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Kiosk",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Laundry",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"lighting",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Mall",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Market"  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Media"  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Music",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Perfumery",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Pet Shop",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Print Shop",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Print Store",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Stationery",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Sports"  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Supermarket"  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Toys",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Vending Machine",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:NSLocalizedString(@"Wine",nil)  dataUrl:@"http://XXXXXXX.it/getdata/osm.aspx?lat=PARAM_LAT&long=PARAM_LON&radius=PARAM_RAD&language=PARAM_LANG&amenity=PARAM_AMENITY" lockDeletable:YES];

    
    
    // To use your own plugins, you have to add your plugin to the singleton class PluginList
    [[PluginList getInstance] addPlugin:[[GoogleAddressesProcessor alloc] init]];
    [[PluginList getInstance] addPlugin:[[TwitterProcessor alloc] init]];
    [[PluginList getInstance] addPlugin:[[WikipediaProcessor alloc] init]];
    [[PluginList getInstance] addPlugin:[[StandardInput alloc] init]];
    [[PluginList getInstance] addPlugin:[[BarcodeInput alloc] init]];
    [[PluginList getInstance] addPlugin:[[StationProcessor alloc] init]];
    [[PluginList getInstance] addPlugin:[[AutobusProcessor alloc] init]];
    [[PluginList getInstance] addPlugin:[[FacebookProcessor alloc] init]];
    
    // [[ START MIXARE ]]
    // It will load all plugins and data sources
    MixareAppDelegate *delegate = [[MixareAppDelegate alloc] init];
    [delegate runApplication];
    return self;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

@end
