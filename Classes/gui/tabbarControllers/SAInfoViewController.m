//
//  SAInfoViewController.m
//  Mixare
//
//  Created by menghu on 5/15/15.
//  Copyright (c) 2015 Peer GmbH. All rights reserved.
//

#import "SAInfoViewController.h"
#import "StationCellView.h"

@interface SAInfoViewController ()
{
    NSString *titleText;
    NSString *stationId;
    NSString *percorsoId;
}

@property (nonatomic, strong) NSArray *stationIdArr;

@end

@implementation SAInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil stationId:(NSString *)stationid percorsoId:(NSString *)percorsoid title:(NSString *)title
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        stationId = stationid;
        percorsoId = percorsoid;
        titleText = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadDetailInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)getDetailInfo
{
    NSString *url_string = [[NSString alloc] initWithFormat:@"http://geosocialcity.it/webservice/indexpg.php?Stations=%@",
                            stationId
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

- (void) postGetStationInfo:(id)sender
{
    if (_stationIdArr == nil || _stationIdArr.count == 0) {
        return;
    }
    
    UIView *_popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _popupView.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.8;
    [_popupView addSubview:backView];
    
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(65, (self.view.frame.size.height-(_stationIdArr.count * (35 + 5) + 50 + 12))/2.0, 190, _stationIdArr.count * (35 + 5) + 50 + 12)];
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
    
//    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeBtn.frame = CGRectMake(detailView.frame.size.width-50, -5, 50, 50);
//    [closeBtn setImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
//    [closeBtn addTarget:self action:@selector(closePopup:) forControlEvents:UIControlEventTouchUpInside];
//    [detailView addSubview:closeBtn];
    
    [_popupView addSubview:detailView];
    
    [self.view addSubview:_popupView];
}

- (void)loadDetailInfo
{
    if (stationId) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _stationIdArr = [self getDetailInfo];
            [self performSelectorOnMainThread:@selector(postGetStationInfo:) withObject:titleText waitUntilDone:NO];
        });
    }
    else
    {
        UIView *_popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _popupView.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.8;
        [_popupView addSubview:backView];
        
        UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(65, (self.view.frame.size.height-(35 + 5 + 50 + 12))/2.0, 190, (35 + 5) + 50 + 12)];
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
        titleLabel.text = titleText;
        [detailView addSubview:titleLabel];
        
        StationCellView *cellView = [[StationCellView alloc] initWithFrame:CGRectMake(5, 40, 180, 35) title:titleText percorso:percorsoId];
        [detailView addSubview:cellView];
        
//        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        closeBtn.frame = CGRectMake(detailView.frame.size.width-50, -5, 50, 50);
//        [closeBtn setImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
//        [closeBtn addTarget:self action:@selector(closePopup:) forControlEvents:UIControlEventTouchUpInside];
//        [detailView addSubview:closeBtn];
        
        [_popupView addSubview:detailView];
        
        [self.view addSubview:_popupView];
    }

}
@end
