//
//  ITHSFavoriteCell.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-28.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "ITHSFavoriteCell.h"

@implementation ITHSFavoriteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
