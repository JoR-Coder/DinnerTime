//
//  ITHSViewController.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-07.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "ITHSViewController.h"
#import "MatAPI.h"

@interface ITHSViewController ()

@end

@implementation ITHSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	
	//if ([[MatAPI sharedInstance] dataLoaded]) {
	//	NSLog(@"Data is supposed to be loaded now???");
	//} else{
	//	NSLog(@"Not yet... These things take time.");
	//}

	// I made a nice Singletonian foodAPI :-D.
	[MatAPI sharedInstance];

}

@end
