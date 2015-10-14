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

#import "SourceViewController.h"
#import "SourceTableCell.h"
#import "Resources.h"
#import "PluginLoader.h"
#import "DataInput.h"
#import "UIImageView+AFNetworking.h"
#import "GlobalSettings.h"

#import <FacebookSDK/FacebookSDK.h>

@implementation SourceViewController
@synthesize dataSourceArray, downloadManager;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (id)init
{
    self = [super init];
    if (self) {
        _loadingView = [[LoadingView alloc] initWithLabel:@"Loading..."];
    }
    
    return self;
}

/***
 *
 *  PULL TO REDOWNLOAD LAST DOWNLOADED DATA
 *
 ***/
- (void)refresh {
    [downloadManager redownload];
    [self refresh:dataSourceManager];
    
//    [self stopLoading];
}

/***
 *
 *  RENEW TABLE VIEW WITH ACTIVE SOURCES
 *
 ***/
- (void)refresh:(DataSourceManager*)sourceManager {
    dataSourceManager = sourceManager;
    if (dataSourceArray == nil) {
        dataSourceArray = [[NSMutableArray alloc] init];
    }
    [dataSourceArray removeAllObjects];
    for (DataSource* data in dataSourceManager.dataSources) {
        [dataSourceArray addObject:data.title];
        NSLog(@"%@", data.title);
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Sources", nil);
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSource)];
    //[NSThread sleepForTimeInterval:1.0];
    self.navigationItem.rightBarButtonItem = addButton;
   NSMutableArray *availablePlugins = [[PluginLoader getInstance] getPluginsFromClassName:@"DataInput"];
    if ([availablePlugins count] == 0) {
     addButton.enabled = NO;
   }
}

- (void)setNewData:(NSDictionary *)data {
    NSString *title = [data objectForKey:@"title"];
    NSString *url = [data objectForKey:@"url"];
    if (url == nil || title == nil || [url isEqualToString:@""] || [title isEqualToString:@""]) {
        [self errorPopUp:@"You have to fill all inputs"];
    } else {
        NSLog(@"URL: %@", url);
        NSLog(@"TITLE: %@", title);
        if ([dataSourceManager createDataSource:title dataUrl:url] != nil) {
            [dataSourceArray addObject:title];
        } else {
            [self errorPopUp:@"Added title already exists"];
        }
    }
    [self.tableView reloadData];
}

/***
 *
 *  Open an alert dialog to insert a custom data source by link
 *
 ***/
- (void)addSource {
    NSMutableArray *availablePlugins = [[PluginLoader getInstance] getPluginsFromClassName:@"DataInput"];
    if ([availablePlugins count] == 0) {
        [self errorPopUp:@"No input possibility found"];
    } else if ([availablePlugins count] == 1) {
        id<DataInput> inputPlugin = availablePlugins[0];
        [inputPlugin runInput:self];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Data input", nil)
                                                          message:NSLocalizedString(@"Choose your data input method.", nil)
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                otherButtonTitles:nil];
        for (id<DataInput> inputPlugin in availablePlugins) {
            [message addButtonWithTitle:[inputPlugin getTitle]];
        }
        [message show];
    }
}

/***
 *
 *  Response to (void)addSource
 *
 ***/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSMutableArray *availablePlugins = [[PluginLoader getInstance] getPluginsFromClassName:@"DataInput"];
    for (id<DataInput> inputPlugin in availablePlugins) {
        if([title isEqualToString:[inputPlugin getTitle]]) {
            [inputPlugin runInput:self];
        }
    }
}

- (void)errorPopUp:(NSString*)message {
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                       message:NSLocalizedString(message, nil)
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                             otherButtonTitles:nil];
    [addAlert show];
}

/***
 *
 *  Called after the view controller's view is released and set to nil.
 *  For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
 *  So release any properties that are loaded in viewDidLoad or can be recreated lazily.
 *
 ***/
- (void)viewDidUnload {
    [super viewDidUnload];
	// release the controls and set them nil in case they were ever created
	// note: we can't use "self.xxx = nil" since they are read only properties
	//
	self.dataSourceArray = nil;	// this will release and set to nil
}

- (void) showLoadingView
{
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    HUD.delegate = self;
    HUD.labelText = @"Connecting";
    [HUD show:YES];
}

- (void) hideLoadingView
{
    [HUD hide:YES];
}

- (void) connectToFB
{
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_events", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        [self hideLoadingView];
        // Show the user the logged-in UI
//        [self fetechUserInfoFromFB];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        [self hideLoadingView];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self hideLoadingView];
    }
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataSourceArray count];
}

/***
 *
 *  To determine specific row height for each cell, override this.
 *  In this example, each row is determined by its subviews that are embedded.
 *
 ***/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	return 55.0;
}

/***
 *
 *  To determine which UITableViewCell to be used on a given row.
 *
 ***/
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *CellIdentifier = @"SourceCell";
	SourceTableCell *cell = (SourceTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SourceCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (SourceTableCell*)currentObject;
                //[cell.sourceSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                break;
            }
        }
    }
    
/*	if (cell == nil) {
		NSArray *topLevelObjects = [[[Resources getInstance] bundle] loadNibNamed:@"SourceCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (SourceTableCell*)currentObject;
				//[cell.sourceSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
				break;
			}
		}
	}
 */
	if (dataSourceArray != nil) {
		cell.sourceLabel.text = dataSourceArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([dataSourceManager getDataSourceByTitle:cell.sourceLabel.text].logo != nil) {
			[cell.sourceLogoView setImage:[dataSourceManager getDataSourceByTitle:cell.sourceLabel.text].logo];
		}
        if ([dataSourceArray[indexPath.row] isEqualToString:@"Facebook"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"facebook_logo.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Twitter"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"twitter_logo.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Carburanti"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"fluel_logo.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Autobus"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"autobus_logo.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Stazioni"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"station_logo.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Sagre"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"wine_icon.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Murales"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"murales_logo.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Guest House", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"guest_house.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"AroundMe(max 5km)", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"empty.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"pub"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"pub.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"camping"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"camping.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"chalet"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"chalet.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Eventi"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"calendar.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Hotel"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"hotel.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Motel"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"motel.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Youth-Hostel", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"youth-hostel.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Shelter", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"shelter.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"College", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"empty.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"School", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"school.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Kindergarten", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"kindergarten.png"]];
    

        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Beergarden", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"biergarten.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Cafè"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"cafe.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Fast food", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"fast_food.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Ice cream", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"ice_cream.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Pizza"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"pizza.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Pub"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"pub.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Restaurant", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"restaurant.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Snacks"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"snacks.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Chemist", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"chemist.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Dentist", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"dentist.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Doctor", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"doctor.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Emergency", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"emergency.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Hearing aid", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"hearing_aid.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Hospital", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"hospital.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Optician", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"optician.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Arts Centre", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"arts_centre.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Cinema"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"cinema.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Fishing", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"fish.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Music venue", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"music_venue.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Nature Reserve", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"nature_reserve.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Park", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"park.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Picnic site", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"picnic_site.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Playground", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"playground.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Theater", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"theater.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Theme park", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"theme_park.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Water park", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"water_park.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Zoo"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"zoo.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"ATM"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"atm.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Bank", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"bank.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Exchange", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"exchange.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Religion", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"religion.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Administration", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"administration.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Shop", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"shop.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Bakery", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"bakery.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Beverages", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"beverages.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Books", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"books.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Butcher", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"butcher.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Clothes", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"clothes.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Computer"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"computers.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Confectioner", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"confectioner.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Department store", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"department_store.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Doit your self", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"doityourself.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Florist", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"florist.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Fish", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"fish.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Flea Market", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"flea_market.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Fruits", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"fruits.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Furniture", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"furniture.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Games", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"games.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Garden Centre", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"garden_centre.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Hi-Fi", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"hifi.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Kiosk", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"kiosk.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"lighting", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"lighting.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Mall", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"mall.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Market"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"market.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Media"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"media.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Music", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"music.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Perfumery", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"perfumery.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Pet Shop", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"pet_shop.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Print Shop", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"print_shop.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Print Store", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"print_store.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Stationery", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"stationery.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Sports", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"sports.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Supermarket", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"supermarket.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Toys", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"toys.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Vending Machine", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"vending_machine.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Bar"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"bar.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Wine", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"wine.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Tourism", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"empty.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:NSLocalizedString(@"Parking", nil)] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"parking.png"]];
        }
        else if ([dataSourceArray[indexPath.row] isEqualToString:@"Wikipedia"] == YES){
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"wikipedia_logo.png"]];
        }
     
        
	} 
    if ([dataSourceManager getDataSourceByTitle:cell.sourceLabel.text].activated) {
        NSLog(cell.sourceLabel.text);
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
       cell.accessoryType = UITableViewCellAccessoryNone;
    }
	return cell;
}

/***
 *
 *  Select source(s) for view
 *
 ***/
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	SourceTableCell *cell = (SourceTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell != nil) {
		if (cell.accessoryType == UITableViewCellAccessoryNone) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [dataSourceManager getDataSourceByTitle:cell.sourceLabel.text].activated = YES; //ACTIVATE DataSource
            if ([cell.sourceLabel.text isEqualToString:@"Facebook"] == YES)
            {
//                if (FBSession.activeSession.state != FBSessionStateCreatedTokenLoaded )
                [self showLoadingView];
                [self connectToFB];
            }
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
            [dataSourceManager getDataSourceByTitle:cell.sourceLabel.text].activated = NO; //DEACTIVATE DataSource
		}
        
       // [self refresh];
	} else NSLog(@"NOT WORKING");

}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    //if user wants to deleta a soucre checkin weather if its a source he added else get restricted
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([[dataSourceManager getDataSourceByTitle:dataSourceArray[indexPath.row]] locked]) {
            [self errorPopUp:@"You can only delete your own sources!"];
        } else {
            [dataSourceManager deleteDataSource:[dataSourceManager getDataSourceByTitle:dataSourceArray[indexPath.row]]];
            [dataSourceArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView*)tableView canMoveRowAtIndexPath:(NSIndexPath*)indexPath {
    return NO;
}

  
    
@end

