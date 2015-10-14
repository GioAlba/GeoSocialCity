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
//  ProgressHUD.m
//  Mixare
//
//  Created by Aswin Ly on 22-11-12.
//

#import "ProgressHUD.h"
#import "Resources.h"

@implementation ProgressHUD

@synthesize activityIndicator, progressMessage, appDelegate;

- (id)initWithLabel:(NSString *)text {
    self = [super init];
    if (self) {
        self.appDelegate = (MixareAppDelegate *)[[UIApplication sharedApplication] delegate];
        
//        UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        actInd.frame = CGRectMake(128.0f, 45.0f, 25.0f, 25.0f);
//        [self addSubview:actInd];
//        [actInd startAnimating];
//        [self setValue:actInd forKey:@"accessoryView"];
        
        UILabel *l = [[UILabel alloc]init];
        l.frame = CGRectMake(100, -25, 210, 100);
        l.text = @"Please wait...";
        l.font = [UIFont fontWithName:@"Helvetica" size:16];
        l.textColor = [UIColor whiteColor];
        l.shadowColor = [UIColor blackColor];
        l.shadowOffset = CGSizeMake(1.0, 1.0);
        l.backgroundColor = [UIColor clearColor];
        [l setTextAlignment:NSTextAlignmentCenter];
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
