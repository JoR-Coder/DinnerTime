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
}


// TODO: Add "proper" erorcheck and more information about errors (if they'd appear).
- (IBAction)sendEmailClicked:(id)sender {

	if ( [MFMailComposeViewController canSendMail] ) {

		MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
		[mailController setMailComposeDelegate:self];
		[mailController setSubject:@"Hint about an awesome app..."];
		
		[mailController setMessageBody:@"Hej Älghagen :-D...\nDetta har skickats via min übersexiga app." isHTML:NO];

		[self presentViewController:mailController animated:YES completion:nil];

	}else{
		NSLog(@"Cannot send :-(");
	}
	
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	if (result == MFMailComposeResultSent) {
		NSLog(@"Aaaaw! I sent a frikkin letter");
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
