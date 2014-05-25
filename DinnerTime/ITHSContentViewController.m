//
//  ITHSContentViewController.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-25.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "ITHSContentViewController.h"

@interface ITHSContentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *foodArticleView;

@end

@implementation ITHSContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.foodArticleView.text = [NSString stringWithFormat:@"Näringsvärden att hämta från : %d", self.foodArticle ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
