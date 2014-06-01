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
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) BOOL imageUpdated;

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
	dispatch_async(dispatch_get_main_queue(), ^{
		
/*		NSFileManager *fileMgr = [NSFileManager defaultManager];
		NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES );
		NSString *dir = path[0];
		
		NSArray *fileArr = [ fileMgr contentsOfDirectoryAtPath:dir error:nil];
		
		for (NSString *filename in fileArr) {
			NSLog(@"Found file :%@", filename);
		}
*/
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSMutableArray *nutrients = [ NSMutableArray arrayWithArray:[prefs objectForKey:@"nutrients"] ];
		
		if ( nutrients != nil && nutrients.count>0 ) {
			//search...
			NSArray *filtered = [nutrients filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"articleNumber == %d", self.articleNr] ];
			
			if (filtered.count>0) {
				self.descriptionTextField.text = [[filtered objectAtIndex:0] objectForKey:@"description"];
			}
		}

		NSString *filename = [NSString stringWithFormat:@"%d-foodFavSnapshot", self.articleNr ];
		UIImage *image = [ UIImage imageWithContentsOfFile:[self imagePath:filename] ];
		
		if (image) {
			self.imageView.image = image;
		}
		
		self.imageUpdated = YES;
		
	});
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// I should have a popup asking "Really delete post???".... But... äääääh! Orkaaaa!
- (IBAction)deleteClicked:(id)sender {

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSMutableArray *nutrients = [ NSMutableArray arrayWithArray:[prefs objectForKey:@"nutrients"] ];
	
	if ( nutrients != nil && nutrients.count>0 ) {
		//search...
		NSArray *filtered = [nutrients filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"articleNumber == %d", self.articleNr] ];
		
		if (filtered.count==0) {
			// No match... Dafuq... What do we delete then ????
		}else {
			for (int i=0; i<[nutrients count]; i++) {
				if ( [[[nutrients objectAtIndex:i] objectForKey:@"articleNumber"] integerValue] == self.articleNr ) {
					[nutrients removeObjectAtIndex:i];
					
					[prefs setObject:nutrients forKey:@"nutrients"];
					[prefs synchronize];
					
					[self animateDelete:@"Deleted record from favorites"];
					
					// Crap... This is somewhat annoying. But it must be done...
					dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
						[NSThread sleepForTimeInterval:1.5];
						dispatch_async(dispatch_get_main_queue(), ^{
							[self.navigationController popViewControllerAnimated:YES];
						});
						
					});
					return;
				}
			}
			[self animateDelete:@"Oouups! This is weird, I couldn't find it."];
		}
	}

	return;

}

- (IBAction)getSnapshotClicked:(id)sender {
	UIImagePickerController *picker = [[ UIImagePickerController alloc] init];
	
	picker.delegate = self;
	picker.allowsEditing = YES;
	
	if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	} else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	
	[self presentViewController:picker animated:YES completion:nil];

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	[picker dismissViewControllerAnimated:YES completion:nil];
	self.imageView.image = info[UIImagePickerControllerEditedImage];
	self.imageUpdated = NO;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[picker dismissViewControllerAnimated:YES completion:nil];
	
}

-(NSString *) imagePath:(NSString *)name{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES );
	
	NSString *documentsDirectory = path[0];
	
	NSString *imageName = [NSString stringWithFormat:@"%@.png", name ];
	NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName ];
	
	return imagePath;
}


- (IBAction)updateClicked:(id)sender {
	// Creepy file, it persist... Let's remove before saving new one.
	
/*	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *filename = [NSString stringWithFormat:@"%d-foodFavSnapshot", self.articleNr ];

	
	BOOL fileExists = [fileMgr fileExistsAtPath:[self imagePath:filename] ];
	if ( fileExists ) {
		// NSLog(@"Delete the friggin file...");
		[fileMgr removeItemAtPath:[self imagePath:filename] error:nil];
	} */
	if (self.imageUpdated) {
		[self animateUpdate:@"Already up to date."];
		
		return;
	}
	if (self.imageView.image) {
		NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
		
		NSString *filename = [NSString stringWithFormat:@"%d-foodFavSnapshot", self.articleNr ];
		BOOL success = [imageData writeToFile:[self imagePath:filename] atomically:NO];
		
		if (success) {
			[self animateUpdate:@"Update success :)"];
			self.imageUpdated = YES;
		} else{
			[self animateUpdate:@"Ooouf! Something went wrong :-("];
		}
		
	}
}


-(void)animateDelete:(NSString*)message{
	
	UITextField * msg = [self createTextField:message];

	[self.view addSubview:msg];
	
	NSDictionary *msgGeometries = [self getGeometries:msg];
	
	CGPoint upperLeft = [msgGeometries[@"upperLeft"] CGPointValue];
	CGPoint lowerLeft = [msgGeometries[@"lowerLeft"] CGPointValue];
	
	upperLeft.y = upperLeft.y/2;
	[msg setCenter:lowerLeft];
	
	[UIView animateWithDuration:1.5 animations:^{
		[msg setCenter:upperLeft];
		[msg setAlpha:0.0];
	} completion:^(BOOL finished) {
		[msg removeFromSuperview];
	}];
}

-(void)animateUpdate:(NSString*)message{
	
	UITextField * msg = [self createTextField:message];
	
	[self.view addSubview:msg];
	
	NSDictionary *msgGeometries = [self getGeometries:msg];
	
	CGPoint upperRight = [msgGeometries[@"upperRight"] CGPointValue];

	CGPoint lowerRight = [msgGeometries[@"lowerRight"] CGPointValue];
	
	upperRight.y = upperRight.y/2;
	[msg setCenter:lowerRight];

	[UIView animateWithDuration:3 animations:^{
		[msg setCenter:upperRight];
		[msg setAlpha:0.0];
	} completion:^(BOOL finished) {
		[msg removeFromSuperview];
	}];
}


-(UITextField*) createTextField:(NSString*)message{

	UITextField *textField = [[UITextField alloc] init];
	
	[textField setTextColor:[UIColor blueColor]];
	[textField setBackgroundColor:[UIColor greenColor]];
	[textField setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
	[textField setUserInteractionEnabled:NO];
	[textField setBorderStyle:UITextBorderStyleRoundedRect];
	[textField setText:message];
	[textField setTextAlignment:NSTextAlignmentCenter];
	[textField sizeToFit];
	
	return textField;

}

/* This is something I'll be using frequently in other projects to.
 Makes sense creating this method.
 
 Parameter:
 Any view with a frame property i.e UILabel, UITextField etc
 returns:
 A NSDictionary with keys
 'upperLeft', 'upperRight', 'lowerLeft', 'lowerRight'
 containing a wrapped CGPoint structure.
 Usage:
 // This'll get the geometries for you...
 NSDictionary *yourLabelGeometries = [self getGeometries:yourLabel];
 // And this is how they're retrieved...
 CGPoint upperRight = [yourLabelGeometries[@"upperRight"] CGPointValue];
 TODO:
 Add support for ALL orientations.
 */
-(NSDictionary *) getGeometries:(UIView *)view{
	
	CGFloat screenWidth  = [[UIScreen mainScreen] bounds].size.width;
	CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
	CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    int statusBarHeight  = MIN(statusBarSize.width, statusBarSize.height);
	
	int navBarHeight = self.navigationController.navigationBar.frame.size.height;
	int viewHeight   = view.frame.size.height;
	int viewWidth    = view.frame.size.width;
	
	int viewTop;
	int viewBottom;
	int viewLeft;
	int viewRight;
	
	if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) ||
        ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))
	{
		// NSLog(@"Landscape mode");
		viewTop = (statusBarHeight*2)+(navBarHeight)+(viewHeight/2);
		viewRight        = screenHeight-statusBarHeight- (viewWidth/2);
		viewLeft         = statusBarHeight + (viewWidth/2);
		viewBottom       = screenWidth-statusBarHeight - (viewHeight/2);
		
	} else {
		// NSLog(@"Portrait mode!");
		viewTop = (statusBarHeight*2)+(navBarHeight)+(viewHeight/2);
		viewRight        = screenWidth-statusBarHeight- (viewWidth/2);
		viewLeft         = statusBarHeight + (viewWidth/2);
		viewBottom       = screenHeight-statusBarHeight - (viewHeight/2);
	}
	
	CGPoint upperLeft  = { viewLeft ,    viewTop };
	CGPoint upperRight = { viewRight,    viewTop };
	CGPoint lowerLeft  = { viewLeft , viewBottom };
	CGPoint lowerRight = { viewRight, viewBottom };
	
	NSDictionary *geometries = @{ @"upperLeft": [NSValue valueWithCGPoint:upperLeft],
								  @"upperRight": [NSValue valueWithCGPoint:upperRight],
								  @"lowerLeft": [NSValue valueWithCGPoint:lowerLeft],
								  @"lowerRight": [NSValue valueWithCGPoint:lowerRight], };
	return geometries;
}


- (IBAction)goBack:(id)sender {
	// Here we check if image IS updated or not... BEFORE popping.
	if (self.imageUpdated) {
		[self.navigationController popViewControllerAnimated:YES];

	}else{
		UIAlertView *confirmExit = [[UIAlertView alloc] initWithTitle:@"Data not updated!" message:@"This data is not updated. Really quit?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Nooo", nil];
		[confirmExit show];
		// [confirmExit release];
	}
	
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex==0) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

@end
