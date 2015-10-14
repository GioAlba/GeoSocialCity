//
//  LoadingView.h
//  Mixare
//
//  Created by menghu on 5/6/15.
//  Copyright (c) 2015 Peer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIAlertView
{
    UIActivityIndicatorView *activityIndicator;
    UILabel *progressMessage;
}

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *progressMessage;

- (id)initWithLabel:(NSString *)text;
- (void)show;
- (void)dismiss;

@end
