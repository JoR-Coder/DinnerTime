//
//  ITHSFavoriteCell.h
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-28.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITHSFavoriteCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel     *articleNumberLabel;
@property (nonatomic, weak) IBOutlet UITextField *descriptionTextField;
@property (nonatomic, weak) IBOutlet UIImageView *snapshotImageView;

@end
