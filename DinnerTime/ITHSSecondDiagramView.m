//
//  ITHSSecondDiagramView.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-06-05.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "ITHSSecondDiagramView.h"

@implementation ITHSSecondDiagramView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

		self.dataSource = self;
    }
    return self;
}

- (NSInteger)numberOfBars{
	return 5;
}
- (NSNumber *)valueForBarAtIndex:(NSInteger)index{
	switch (index) {
		case 0:
			return self.nutritionB[@"fat"];
		case 1:
			return self.nutritionB[@"magnesium"];
		case 2:
			return self.nutritionB[@"protein"];
		case 3:
			return self.nutritionB[@"saturatedFattyAcids"];
		default:
			return 0;
	}
}

-(UIColor *)colorForBarAtIndex:(NSInteger)index{
	return [UIColor colorWithHue:index * 0.25f saturation:0.8f brightness:0.8f alpha:1.0f];
}

-(UIColor *)colorForBarBackgroundAtIndex:(NSInteger)index{
	return [UIColor clearColor];
}

-(CFTimeInterval)animationDurationForBarAtIndex:(NSInteger)index{
	return 1;
}

-(NSString *)titleForBarAtIndex:(NSInteger)index{
	return @[ @"a",@"b",@"c",@"d",@"e" ][index];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
