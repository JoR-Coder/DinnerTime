//
//  ITHSInfoViewController.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-28.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "ITHSInfoViewController.h"

@interface ITHSInfoViewController ()

@end

@implementation ITHSInfoViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendEmailClicked:(id)sender {
	if ( [MFMailComposeViewController canSendMail] ) {
		MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
		mailController.mailComposeDelegate = self;
		[mailController setSubject:@"Hint about an awesome app..."];
		[mailController setMessageBody:@"Hej Älghagen :-D...\nDetta har skickats via min übersexiga app." isHTML:NO];
		if (mailController) [self presentViewController:mailController animated:YES completion:nil];
	}else{
		NSLog(@"Cannot send :-(");
	}
	
}

#pragma mark - email

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	if (result == MFMailComposeResultSent) {
		NSLog(@"Aaaaw! I sent a frikkin letter");
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
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
