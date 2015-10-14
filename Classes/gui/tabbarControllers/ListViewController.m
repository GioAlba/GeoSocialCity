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

#import "ListViewController.h"
#import "WebViewController.h"
#import "Position.h"
#import "Resources.h"
#import "StationCellView.h"
#import "UIImageView+AFNetworking.h"
#import "ListViewTableViewCell.h"
#import "SAInfoViewController.h"
#import "GlobalSettings.h"

@implementation ListViewController
@synthesize downloadManager;

- (id)init
{
    self = [super init];
    if (self) {
        _loadingView = [[LoadingView alloc] initWithLabel:@"Loading..."];
        currentSearchKey = @"";
    }
    
    return self;
}

- (void) finishedGetData:(NSNotification *)note
{
    [_loadingView dismiss];
    [self.tableView reloadData];
}

/***
 *
 *  PULL TO REDOWNLOAD LAST DOWNLOADED DATA
 *
 ***/

- (void)refresh {
    BOOL isShowingAlert = NO;
    for (UIWindow* window in [UIApplication sharedApplication].windows){
        for (UIView *subView in [window subviews]){
            if ([subView isKindOfClass:[UIAlertView class]]) {
                isShowingAlert = YES;
                NSLog(@"has AlertView");
            }else {
                NSLog(@"No AlertView");
            }
        }
    }
    
    if (isShowingAlert == NO) {
        [_loadingView show];
    }

    [downloadManager redownload];
    [self refreshMe:dataSources];
//    [self refreshFinished:nil];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [downloadManager redownload];
//        [self refreshMe:dataSources];
//        [self performSelectorOnMainThread:@selector(refreshFinished:) withObject:nil waitUntilDone:NO];
//    });

//    [self hideLoadingView];
//    [self stopLoading];
}

- (void)refreshTimer {
    BOOL isShowingAlert = NO;
    for (UIWindow* window in [UIApplication sharedApplication].windows){
        for (UIView *subView in [window subviews]){
            if ([subView isKindOfClass:[UIAlertView class]]) {
                isShowingAlert = YES;
                NSLog(@"has AlertView");
            }else {
                NSLog(@"No AlertView");
            }
        }
    }
    
    if (isShowingAlert == NO) {
        [_loadingView show];
    }
    
    [downloadManager redownloadStaionAndBus];
    [self refreshMe:dataSources];
    //    [self refreshFinished:nil];
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        [downloadManager redownload];
    //        [self refreshMe:dataSources];
    //        [self performSelectorOnMainThread:@selector(refreshFinished:) withObject:nil waitUntilDone:NO];
    //    });
    
    //    [self hideLoadingView];
    //    [self stopLoading];
}

/***
 *
 *  RENEW TABLE VIEW WITH ACTIVE SOURCES
 *
 ***/
- (void)refresh:(NSMutableArray*)datas {
    dataSources = datas;
    BOOL isShowingAlert = NO;
    for (UIWindow* window in [UIApplication sharedApplication].windows){
        for (UIView *subView in [window subviews]){
            if ([subView isKindOfClass:[UIAlertView class]]) {
                isShowingAlert = YES;
                NSLog(@"has AlertView");
            }else {
                NSLog(@"No AlertView");
            }
        }
    }
    
    if (isShowingAlert == NO) {
        [_loadingView show];
    }
    
    BOOL isSocial = NO;
    [dataSourceArray removeAllObjects];
    if (dataSources != nil) {
        for (DataSource *data in dataSources) {
            if ([data.title isEqualToString:@"Facebook"] || [data.title isEqualToString:@"Twitter"]) {
                isSocial = YES;
            }
            [self convertPositionsToListItems:data];
        }
    }
    
    //if (isSocial == NO) {
        [_loadingView dismiss];

        
        [self.tableView reloadData];
    
    
}


- (void)refreshMe:(NSMutableArray*)datas {
    dataSources = datas;
    BOOL isShowingAlert = NO;
    for (UIWindow* window in [UIApplication sharedApplication].windows){
        for (UIView *subView in [window subviews]){
            if ([subView isKindOfClass:[UIAlertView class]]) {
                isShowingAlert = YES;
                NSLog(@"has AlertView");
            }else {
                NSLog(@"No AlertView");
            }
        }
    }
    
    if (isShowingAlert == NO) {
        [_loadingView show];
    }
    
    BOOL isSocial = NO;
    [dataSourceArray removeAllObjects];
    if (dataSources != nil) {
        for (DataSource *data in dataSources) {
            if ([data.title isEqualToString:@"Facebook"] || [data.title isEqualToString:@"Twitter"]) {
                isSocial = YES;
            }
            [self convertPositionsToListItems:data];
        }
    }
    
        [_loadingView dismiss];
            [self.tableView reloadData];

}

- (void)convertPositionsToListItems:(DataSource*)data {
    if (dataSourceArray == nil) {
        dataSourceArray = [[NSMutableArray alloc] init];
    }
    for (Position *pos in data.positions) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (pos.isFacebookEvent == YES || pos.isTwitterEvent == YES) {
            [dic setValue:pos.coverUrl forKey:@"image"];
        }
        else
            [dic setValue:pos.image forKey:@"image"];
        if (self.searchBar.text && self.searchBar.text.length > 0) {
            if ([pos.title rangeOfString:self.searchBar.text].location == NSNotFound) {
                continue;
            }
        }
        
        [dic setValue:pos.title forKey:@"title"];
        [dic setValue:pos.summary forKey:@"sum"];
        [dic setValue:pos.url forKey:@"url"];
        [dic setValue:pos.stationId forKey:@"stationId"];
        [dic setValue:pos.percorsoId forKey:@"percorsoId"];
        [dic setValue:[NSNumber numberWithBool:pos.isFacebookEvent] forKey:@"isFBevent"];
        [dic setValue:[NSNumber numberWithBool:pos.isTwitterEvent] forKey:@"isTWevent"];
        [dic setValue:[NSNumber numberWithBool:pos.isEvent] forKey:@"isEvent"];
        [dic setValue:pos.Datainizio forKey:@"Datainizio"];
         [dic setValue:pos.Categoria forKey:@"Categoria"];
        [dic setValue:pos.ownerName forKey:@"ownername"];
        [dic setValue:[self convertDateString:pos.startTime] forKey:@"starttime"];
        [dic setValue:pos.address forKey:@"address"];
        [dataSourceArray addObject:dic];
    }
}

- (NSString *)convertDateString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssxxx";
    
    NSDate *fromDate = [dateFormatter dateFromString:dateString];
    dateFormatter.dateFormat = @"yyyy MMM dd";
    
    return [dateFormatter stringFromDate:fromDate];
}

- (void)viewDidLoad {	
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Poi List", @"Localizable", [[Resources getInstance] bundle], @"");
    
    _popupView = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedGetData:) name:@"gotData" object:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(preparecounterUpdate:)
                                   userInfo:nil
                                    repeats:NO];
    
    countTimer = [NSTimer scheduledTimerWithTimeInterval:100.0
                                                  target:self
                                                selector:@selector(counterUpdate:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [countTimer invalidate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

// called after the view controller's view is released and set to nil.
// For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
// So release any properties that are loaded in viewDidLoad or can be recreated lazily.
//
- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	// release the controls and set them nil in case they were ever created
	// note: we can't use "self.xxx = nil" since they are read only properties
	//
	dataSourceArray = nil;	// this will release and set to nil
    
    [countTimer invalidate];
}

- (void)preparecounterUpdate:(NSTimer *)timer
{
    BOOL isShowingAlert = NO;
    for (UIWindow* window in [UIApplication sharedApplication].windows){
        for (UIView *subView in [window subviews]){
            if ([subView isKindOfClass:[UIAlertView class]]) {
                isShowingAlert = YES;
                NSLog(@"has AlertView");
            }else {
                NSLog(@"No AlertView");
            }
        }
    }
    
    if (isShowingAlert == NO) {
        [_loadingView show];
    }
    
    [self refreshTimer];
}

- (void)counterUpdate:(NSTimer *)timer
{
    BOOL isShowingAlert = NO;
    for (UIWindow* window in [UIApplication sharedApplication].windows){
        for (UIView *subView in [window subviews]){
            if ([subView isKindOfClass:[UIAlertView class]]) {
                isShowingAlert = YES;
                NSLog(@"has AlertView");
            }else {
                NSLog(@"No AlertView");
            }
        }
    }
    
    if (isShowingAlert == NO) {
        [_loadingView show];
    }

    [self refreshTimer];
}

- (NSArray *)getDetailInfo:(NSString *)stationId
{
    NSString *url_string = [[NSString alloc] initWithFormat:@"http://geosocialcity.it/webservice/indexpg.php?Stations=%@",
                            @"1"
                            ];
    
    url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"URL_STRING %@", url_string);
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_string]];
    
    if(data) {
        NSArray *stationsArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        return stationsArr;
    }
    
    return nil;
}

- (void)openPopupWithIndexPath:(NSIndexPath *)indexPath {
    if (_popupView) {
        [_popupView removeFromSuperview];
        _popupView = nil;
    }
    
    NSString *stationId = [dataSourceArray[indexPath.row] valueForKey:@"stationId"];
    NSString *percorsoId = [dataSourceArray[indexPath.row] valueForKey:@"percorsoId"];
    if (stationId) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _stationIdArr = [self getDetailInfo:stationId];
            [self performSelectorOnMainThread:@selector(postGetStationInfo:) withObject:[dataSourceArray[indexPath.row] valueForKey:@"title"] waitUntilDone:NO];
        });
    }
    else
    {
        _popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _popupView.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.8;
        [_popupView addSubview:backView];
        
        UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(65, (self.view.frame.size.height-(35 + 5 + 50 + 12))/2.0 + self.tableView.contentOffset.y, 190, (35 + 5) + 50 + 12)];
        detailView.backgroundColor = [UIColor clearColor];
        
        UIImage *img = [[UIImage imageNamed:@"bg_station_info.png"] stretchableImageWithLeftCapWidth:20  topCapHeight:15];
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [detailView addSubview:bgImgView];
        bgImgView.image = img;
        bgImgView.frame = CGRectMake(0, 0, detailView.frame.size.width, detailView.frame.size.height-12);
        
        UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(84.5, (35 + 5) + 50, 21, 12)];
        pointImageView.image = [UIImage imageNamed:@"icon_staion_point.png"];
        [detailView addSubview:pointImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, detailView.frame.size.width, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = [dataSourceArray[indexPath.row] valueForKey:@"title"];
        [detailView addSubview:titleLabel];
        
        StationCellView *cellView = [[StationCellView alloc] initWithFrame:CGRectMake(5, 40, 180, 35) title:[dataSourceArray[indexPath.row] valueForKey:@"title"] percorso:percorsoId];
        [detailView addSubview:cellView];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(detailView.frame.size.width-50, -5, 50, 50);
        [closeBtn setImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closePopup:) forControlEvents:UIControlEventTouchUpInside];
        [detailView addSubview:closeBtn];
        
        [_popupView addSubview:detailView];
        
        [self.view addSubview:_popupView];
    }
}

- (void) postGetStationInfo:(id)sender
{
    if (_stationIdArr == nil || _stationIdArr.count == 0) {
        return;
    }
    
    _popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGRect asf = _popupView.frame;
    _popupView.backgroundColor = [UIColor redColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.8;
    [_popupView addSubview:backView];

    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(65, (self.view.frame.size.height-(_stationIdArr.count * (35 + 5) + 50 + 12))/2.0 + self.tableView.contentOffset.y, 190, _stationIdArr.count * (35 + 5) + 50 + 12)];
    detailView.backgroundColor = [UIColor clearColor];
    
    UIImage *img = [[UIImage imageNamed:@"bg_station_info.png"] stretchableImageWithLeftCapWidth:20  topCapHeight:15];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [detailView addSubview:bgImgView];
    bgImgView.image = img;
    bgImgView.frame = CGRectMake(0, 0, detailView.frame.size.width, detailView.frame.size.height-12);
    
    UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(84.5, _stationIdArr.count * (35 + 5) + 50, 21, 12)];
    pointImageView.image = [UIImage imageNamed:@"icon_staion_point.png"];
    [detailView addSubview:pointImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, detailView.frame.size.width, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = (NSString *)sender;
    [detailView addSubview:titleLabel];
    
    for ( int i=0; i<_stationIdArr.count; i++) {
        NSDictionary *dic = [_stationIdArr objectAtIndex:i];
        StationCellView *cellView = [[StationCellView alloc] initWithFrame:CGRectMake(5, 40+i*(35+5), 180, 35) title:[NSString stringWithFormat:@"Autobus n.%@", [dic objectForKey:@"numeroautobus"]] distance:[dic objectForKey:@"distance"] time:[dic objectForKey:@"TempoArrivo"]];
        [detailView addSubview:cellView];
    }
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(detailView.frame.size.width-50, -5, 50, 50);
    [closeBtn setImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePopup:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:closeBtn];
    
    [_popupView addSubview:detailView];
    
    [self.view addSubview:_popupView];
}

- (IBAction)closePopup:(id)sender
{
    [_popupView removeFromSuperview];
    _popupView = nil;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (dataSourceArray != nil) ? [dataSourceArray count] :0;
}

// to determine specific row height for each cell, override this.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return ([indexPath row] == 0) ? 60.0 : 60.0;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    static NSString *CellIdentifier = @"ListViewTableViewCell";
    ListViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell = [[[NSBundle mainBundle] loadNibNamed:@"ListViewTableViewCell" owner:nil options:nil] objectAtIndex:0];
//	cell = [[ListViewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
	if (dataSourceArray != nil) {
        //setting the corresponding title for each row .. source array gets set in the app delegate class when downloading new data

//        cell.textLabel.text = [dataSourceArray[indexPath.row] valueForKey:@"title"];
//		cell.detailTextLabel.text = [dataSourceArray[indexPath.row] valueForKey:@"sum"];
        
        cell.titleLabel.text = [dataSourceArray[indexPath.row] valueForKey:@"title"];
        
        //adding custom label to each row according to their source
        if ([[dataSourceArray[indexPath.row] valueForKey:@"isFBevent"] boolValue] == YES) {
            [cell.photoView setImageWithURL:[NSURL URLWithString:[dataSourceArray[indexPath.row] valueForKey:@"image"]]];
            cell.titleLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:129.0/255.0 blue:213.0/255.0 alpha:1.0];
            cell.titleLabel.frame = CGRectMake(74, 4, 238, 21);
         
            cell.nametimelabel.text = [NSString stringWithFormat:@"%@, %@",[dataSourceArray[indexPath.row] valueForKey:@"ownername"], [dataSourceArray[indexPath.row] valueForKey:@"starttime"]];
            cell.nametimelabel.frame = CGRectMake(74, 22, 238, 21);
            cell.nametimelabel.textColor = [UIColor colorWithRed:52.0/255.0 green:224.0/255.0 blue:255.0/255.0 alpha:1.0];
            
            cell.addressLabel.text = [dataSourceArray[indexPath.row] valueForKey:@"address"];
            cell.addressLabel.textColor = [UIColor blackColor];
            cell.addressLabel.frame = CGRectMake(74, 39, 238, 21);
            cell.addressLabel.numberOfLines = 1;
                                                   
            [cell.nametimelabel setHidden:NO];
            [cell.addressLabel setHidden:NO];
        }
        else if ([[dataSourceArray[indexPath.row] valueForKey:@"isTWevent"] boolValue] == YES) {
            NSLog(@"-=-=-=-= %@", [dataSourceArray[indexPath.row] valueForKey:@"image"]);
            [cell.photoView setImageWithURL:[NSURL URLWithString:[dataSourceArray[indexPath.row] valueForKey:@"image"]]];
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.titleLabel.frame = CGRectMake(74, 3, 153, 21);
            cell.titleLabel.text = [dataSourceArray[indexPath.row] valueForKey:@"ownername"];
            
            cell.nametimelabel.text = [dataSourceArray[indexPath.row] valueForKey:@"starttime"];
            cell.nametimelabel.frame = CGRectMake(242, 3, 71, 21);
            
            cell.addressLabel.frame = CGRectMake(74, 19, 238, 36);
            cell.addressLabel.textColor = [UIColor blackColor];
            cell.addressLabel.numberOfLines = 2;
            cell.addressLabel.text = [dataSourceArray[indexPath.row] valueForKey:@"title"];
            
            [cell.nametimelabel setHidden:NO];
            [cell.addressLabel setHidden:NO];
        }
        else if ([[dataSourceArray[indexPath.row] valueForKey:@"isEvent"] boolValue] == YES) {
            cell.photoView.image = [dataSourceArray[indexPath.row] valueForKey:@"image"];
            cell.titleLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:129.0/255.0 blue:213.0/255.0 alpha:1.0];
            cell.titleLabel.frame = CGRectMake(74, 2, 238, 45);
            cell.titleLabel.numberOfLines = 2;
            cell.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            cell.titleLabel.text = [dataSourceArray[indexPath.row] valueForKey:@"title"];
            NSString *str =[[dataSourceArray[indexPath.row] valueForKey:@"Datainizio"]
                            stringByReplacingOccurrencesOfString:@"T00:00:00" withString:@""];
            cell.nametimelabel.text = str;
            
            cell.nametimelabel.frame = CGRectMake(74, 33, 238, 36);
            cell.nametimelabel.textColor = [UIColor colorWithRed:52.0/255.0 green:224.0/255.0 blue:255.0/255.0 alpha:1.0];
            
            
            cell.addressLabel.frame = CGRectMake(150, 33, 238, 36);
            cell.addressLabel.textColor = [UIColor blackColor];
            cell.addressLabel.numberOfLines = 2;
            cell.addressLabel.text = [dataSourceArray[indexPath.row] valueForKey:@"Categoria"];
            
            [cell.nametimelabel setHidden:NO];
            [cell.addressLabel setHidden:NO];
        }
        else {
            cell.photoView.image = [dataSourceArray[indexPath.row] valueForKey:@"image"];
            [cell.titleLabel setFrame:CGRectMake(74, 10, 238, 45)];
            cell.titleLabel.numberOfLines = 2;
            cell.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.titleLabel.textColor = [UIColor blackColor];
            [cell.nametimelabel setHidden:YES];
            [cell.addressLabel setHidden:YES];
//            cell.imageView.image = [dataSourceArray[indexPath.row] valueForKey:@"image"];
        }
    }
	return cell;
}
#pragma mark -
#pragma mark UITableViewDelegate

// the table's selection has changed, switch to that item's UIViewController -> opens the webpage of the item/poi
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"in select row");
    NSString *stationId = [dataSourceArray[indexPath.row] valueForKey:@"stationId"];
    NSString *percorsoId = [dataSourceArray[indexPath.row] valueForKey:@"percorsoId"];
    if (stationId || percorsoId) {
        SAInfoViewController *controller = [[SAInfoViewController alloc] initWithNibName:@"SAInfoViewController" bundle:nil stationId:stationId percorsoId:percorsoId title:[dataSourceArray[indexPath.row] valueForKey:@"title"]];
        [self.navigationController pushViewController:controller animated:YES];
//        [self openPopupWithIndexPath:indexPath];
    }
    else {
        WebViewController *targetViewController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];
        targetViewController.url = [dataSourceArray[indexPath.row] valueForKey:@"url"];
        [[self navigationController] pushViewController:targetViewController animated:YES];
        
    }
}

#pragma mark - UISearchBarDelegate Method

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([currentSearchKey isEqualToString:searchBar.text] == YES) {
        [self.searchBar setShowsCancelButton:NO animated:YES];
        [self.searchBar resignFirstResponder];
        return;
    }
    
    currentSearchKey = searchBar.text;
    
    [_loadingView show];
    [self refresh];

    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [GlobalSettings sharedInstance].searchKey = searchText;
//    _accountArr = [[NSMutableArray alloc] init];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        _accountArr = [[WebServiceAPI sharedInstance] getAccountInventory:[_accountInfo objectForKey:@"id"] searchKey:searchText];
//        [self performSelectorOnMainThread:@selector(postGetAccount:) withObject:nil waitUntilDone:NO];
//    });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    
    if ([currentSearchKey isEqualToString:searchBar.text] == YES) {
        return;
    }
    
    currentSearchKey = @"";
    [_loadingView show];
    [self refresh];
//    [self loadAccountInventory];
}

- (void)refreshFinished:(id)sender
{
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    //cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}

@end
