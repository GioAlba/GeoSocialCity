//
//  ListViewTableViewCell.h
//  Mixare
//
//  Created by menghu on 5/6/15.
//  Copyright (c) 2015 Peer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *photoView;
@property (nonatomic, weak) IBOutlet UILabel *nametimelabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;

@end
