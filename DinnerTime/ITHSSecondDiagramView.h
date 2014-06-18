//
//  ITHSSecondDiagramView.h
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-06-05.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GraphKit.h>

@interface ITHSSecondDiagramView : GKBarGraph<GKBarGraphDataSource>

@property (nonatomic) NSDictionary *nutritionB;

@end
