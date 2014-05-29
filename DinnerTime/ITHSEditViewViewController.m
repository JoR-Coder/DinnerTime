//
//  ITHSEditViewViewController.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-27.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "ITHSEditViewViewController.h"
// #import "ImageUtils.h"

@interface ITHSEditViewViewController ()
@property (weak, nonatomic) IBOutlet UILabel *articleNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation ITHSEditViewViewController

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
	self.articleNumberLabel.text = [NSString stringWithFormat:@"Article: %d", self.articleNr];
	
	//[self.deleteButton ];
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
- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
