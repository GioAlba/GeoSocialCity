//
//  CustomAnnotationView.m
//  CustomAnnotation
//
//  Created by akshay on 8/17/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "MapViewAnnotation.h"
#import "StationCellView.h"

@implementation CustomAnnotationView

@synthesize detailView;


- (instancetype)initWithAnnotation:(id <MKAnnotation>)annotation  pinImage:(UIImage *)img reuseIdentifier:(NSString *)reuseIdentifier viewSize:(CGSize)size
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    _pinImage = img;
    parentSize = size;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{

   MapViewAnnotation *ann = self.annotation;

    if (ann.isFacebookEvent == YES || ann.isTwitterEvent == YES) {
        self.canShowCallout = NO;

        [self.delegate openFBEvent:ann.fbEventURL];
        return;
    }
    
    if (ann.stationId == nil && ann.percorsoId == nil) {
        self.canShowCallout = YES;
        [super setSelected:selected animated:animated];
        return;
    }
    
    if(selected)
    {
        //Add your custom view to self...

        self.canShowCallout = NO;
        
        if (ann.percorsoId == nil) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                _stainInfoArr = [self getDetailInfo:ann.stationId];
                [self performSelectorOnMainThread:@selector(postGetStationInfo:) withObject:nil waitUntilDone:NO];
            });
        }
        else
        {
            detailView = [[UIView alloc] initWithFrame:CGRectMake(-100, -35, 190, (35 + 5) + 50 + 12)];
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
            titleLabel.text = ann.title;
            [detailView addSubview:titleLabel];
            
            StationCellView *cellView = [[StationCellView alloc] initWithFrame:CGRectMake(5, 40, 180, 35) title:ann.title percorso:ann.percorsoId];
            [detailView addSubview:cellView];
            
            [self animateCalloutAppearance];
            [self addSubview:detailView];
        }
    }
    else
    {
        //Remove your custom view...
        [detailView removeFromSuperview];
    }
}

- (void) postGetStationInfo:(id)sender
{
    if (_stainInfoArr == nil || _stainInfoArr.count == 0) {
        return;
    }
    MapViewAnnotation *ann = self.annotation;
    
    detailView = [[UIView alloc] initWithFrame:CGRectMake(-100, -35, 190, _stainInfoArr.count * (35 + 5) + 50 + 12)];
    detailView.backgroundColor = [UIColor clearColor];
    
    UIImage *img = [[UIImage imageNamed:@"bg_station_info.png"] stretchableImageWithLeftCapWidth:20  topCapHeight:15];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [detailView addSubview:bgImgView];
    bgImgView.image = img;
    bgImgView.frame = CGRectMake(0, 0, detailView.frame.size.width, detailView.frame.size.height-12);
    
    UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(84.5, _stainInfoArr.count * (35 + 5) + 50, 21, 12)];
    pointImageView.image = [UIImage imageNamed:@"icon_staion_point.png"];
    [detailView addSubview:pointImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, detailView.frame.size.width, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = ann.title;
    [detailView addSubview:titleLabel];
    
    for ( int i=0; i<_stainInfoArr.count; i++) {
        NSDictionary *dic = [_stainInfoArr objectAtIndex:i];
        StationCellView *cellView = [[StationCellView alloc] initWithFrame:CGRectMake(5, 40+i*(35+5), 180, 35) title:[NSString stringWithFormat:@"Autobus n.%@", [dic objectForKey:@"numeroautobus"]] distance:[dic objectForKey:@"distance"] time:[dic objectForKey:@"TempoArrivo"]];
        [detailView addSubview:cellView];
    }

        [self animateCalloutAppearance];
    [self addSubview:detailView];
}

//- (void)didAddSubview:(UIView *)subview{
//    Annotation *ann = self.annotation;
//    if (![ann.locationType isEqualToString:@"dropped"]) {
//        if ([[[subview class] description] isEqualToString:@"UICalloutView"]) {
//            for (UIView *subsubView in subview.subviews) {
//                if ([subsubView class] == [UIImageView class]) {
//                    UIImageView *imageView = ((UIImageView *)subsubView);
//                    [imageView removeFromSuperview];
//                }else if ([subsubView class] == [UILabel class]) {
//                    UILabel *labelView = ((UILabel *)subsubView);
//                    [labelView removeFromSuperview];
//                }
//            }
//        }
//    }
//}

- (void)animateCalloutAppearance {
    CGFloat scale = 0.001f;
    detailView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -50);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
        CGFloat scale = 1.1f;
        detailView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGFloat scale = 0.95;
            detailView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.075 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                CGFloat scale = 1.0;
                detailView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 0);
            } completion:nil];
        }];
    }];
}

- (NSArray *)getDetailInfo:(NSString *)stationId
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

- (IBAction)closePopup:(id)sender
{
    [detailView removeFromSuperview];
}

@end
