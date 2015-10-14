//
//  StationCellView.h
//  Mixare
//
//  Created by menghu on 4/29/15.
//  Copyright (c) 2015 Peer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationCellView : UIView

@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title distance:(NSString *)distance time:(NSString *)time;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title percorso:(NSString *)percorso;

@end
