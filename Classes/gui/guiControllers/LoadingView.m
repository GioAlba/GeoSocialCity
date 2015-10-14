//
//  LoadingView.m
//  Mixare
//
//  Created by menghu on 5/6/15.
//  Copyright (c) 2015 Peer GmbH. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

@synthesize activityIndicator, progressMessage;

- (id)initWithLabel:(NSString *)text {
    self = [super init];
    if (self) {        
        UILabel *l = [[UILabel alloc]init];
        l.frame = CGRectMake(100, -25, 210, 100);
        l.textAlignment = NSTextAlignmentCenter;
        l.text = @"Please wait...";
        l.font = [UIFont fontWithName:@"Helvetica" size:16];
        l.textColor = [UIColor whiteColor];
        l.shadowColor = [UIColor blackColor];
        l.shadowOffset = CGSizeMake(1.0, 1.0);
        l.backgroundColor = [UIColor clearColor];
        [self addSubview:l];
        
        [self setValue:l forKey:@"accessoryView"];        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
}


- (void)show {
    [super show];
}

- (void)dismiss {
    [super dismissWithClickedButtonIndex:0 animated:YES];
}


@end
