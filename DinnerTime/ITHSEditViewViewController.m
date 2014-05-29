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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


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
		[self restoreFromCache];
/*		NSFileManager *fileMgr = [NSFileManager defaultManager];
		NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES );
		NSString *dir = path[0];
		
		NSArray *fileArr = [ fileMgr contentsOfDirectoryAtPath:dir error:nil];
		
		for (NSString *filename in fileArr) {
			NSLog(@"Found file :%@", filename);
		}
*/		
	});
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteClicked:(id)sender {
	
//	NSDictionary *Favorite = @{ @"articleNumber" : [NSNumber numberWithInteger:self.foodArticle],
//								@"description": self.nutritionsList[@"name"],
//								@"imagePath"  : @" " };
	
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
				}
			}
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

- (IBAction)updateClicked:(id)sender {
	// Creepy file, it persist... Let's remove before saving new one.
	
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *filename = [NSString stringWithFormat:@"%d-foodFavSnapshot", self.articleNr ];

	
	BOOL fileExists = [fileMgr fileExistsAtPath:[self imagePath:filename] ];
	if ( fileExists ) {
		// NSLog(@"Delete the friggin file...");
		[fileMgr removeItemAtPath:[self imagePath:filename] error:nil];
	}

	[self save2Cache];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	[picker dismissViewControllerAnimated:YES completion:nil];
	self.imageView.image = info[UIImagePickerControllerEditedImage];
	
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

-(void) save2Cache{
	if (self.imageView.image) {
		NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
		
		NSString *filename = [NSString stringWithFormat:@"%d-foodFavSnapshot", self.articleNr ];
		BOOL success = [imageData writeToFile:[self imagePath:filename] atomically:NO];
		
		if (success) {
			NSLog(@"Saved to cache.");
		} else{
			NSLog(@"Failed saveing to cache.");
		}
		
	}
}

-(void)restoreFromCache{
	NSString *filename = [NSString stringWithFormat:@"%d-foodFavSnapshot", self.articleNr ];
	UIImage *image = [ UIImage imageWithContentsOfFile:[self imagePath:filename] ];
	
	if (image) {
		self.imageView.image = image;
		NSLog(@"Loaded file from cache");
	}else{
		NSLog(@"Failed to load from cache");
		
	}
}
- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
