//
//  CustomAnnotationView.h
//  CustomAnnotation
//
//  Created by akshay on 8/17/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol CustomAnnotationViewDelegate;

@interface CustomAnnotationView : MKPinAnnotationView
{
    CGSize parentSize;
}

@property (nonatomic, strong) id<CustomAnnotationViewDelegate> delegate;

@property (strong, nonatomic) UIView *detailView;
@property (nonatomic, strong) NSArray *stainInfoArr;
@property (nonatomic, strong) UIImage *pinImage;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)animateCalloutAppearance;

- (instancetype)initWithAnnotation:(id <MKAnnotation>)annotation pinImage:(UIImage *)img reuseIdentifier:(NSString *)reuseIdentifier viewSize:(CGSize)size;

@end

@protocol CustomAnnotationViewDelegate <NSObject>

@optional
- (void)openFBEvent:(NSString *)evenURL;

@end