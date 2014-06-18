//
//  ITHSDiagramViewController.h
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-06-04.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GraphKit.h>

@interface ITHSDiagramViewController : UIViewController<GKBarGraphDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *Values;

@property (nonatomic) int foodArticle;


@end
