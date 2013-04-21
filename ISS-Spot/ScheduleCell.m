//
//  ScheduleCell.m
//  ISS-Spot
//
//  Created by Wahyu Sumartha  on 4/21/13.
//  Copyright (c) 2013 Wahyu Sumartha . All rights reserved.
//

#import "ScheduleCell.h"

@implementation ScheduleCell

@synthesize dateLabel = _dateLabel;
@synthesize durationLabel = _durationLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        [_dateLabel setBackgroundColor:[UIColor colorWithRed:224/255.f green:232/255.f blue:237/255.f alpha:1.0]];
        [_dateLabel setText:@"22 Apr 2013"];
        [self.contentView addSubview:_dateLabel];
        
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 320, 50)];
        [_durationLabel setBackgroundColor:[UIColor colorWithRed:244/255.f green:247/255.f blue:249/255.f alpha:1.0]];
        [_durationLabel setFont:[UIFont fontWithName:@"Symbol" size:23]];
        [_durationLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_durationLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
