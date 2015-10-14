//
//  StationCellView.m
//  Mixare
//
//  Created by menghu on 4/29/15.
//  Copyright (c) 2015 Peer GmbH. All rights reserved.
//

#import "StationCellView.h"

@implementation StationCellView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title distance:(NSString *)distance time:(NSString *)time
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
        self.titleLabel.text = title;
        self.distanceLabel.text = [NSString stringWithFormat:@"Distance:%@", distance];
        self.timeLabel.text = [NSString stringWithFormat:@"Tempo di arrive:%@", time];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title percorso:(NSString *)percorso
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
        self.titleLabel.text = title;
        [self.distanceLabel removeFromSuperview];
        self.timeLabel.text = [NSString stringWithFormat:@"Linea:%@", percorso];
    }
    return self;
}

- (void)setup
{
    [[NSBundle mainBundle] loadNibNamed:@"StationCellView" owner:self options:nil];
    
    [self addSubview:self.view];
}


@end
