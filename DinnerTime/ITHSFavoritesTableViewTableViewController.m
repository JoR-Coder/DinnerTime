//
//  ITHSFavoritesTableViewTableViewController.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-27.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "ITHSFavoritesTableViewTableViewController.h"
#import "ITHSEditViewViewController.h"
#import "ITHSFavoriteCell.h"


// TODO: Nevermind this weird stupid name of this class :-O
// TODO: Ignore it, ignore it I say :-(
@interface ITHSFavoritesTableViewTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *favoriteTableView;

@property (nonatomic) NSArray *favoriteList;

@end

@implementation ITHSFavoritesTableViewTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated{

	dispatch_async(dispatch_get_main_queue(), ^{
		
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		self.favoriteList = [ NSMutableArray arrayWithArray:[prefs objectForKey:@"nutrients"] ];
		
		if ( self.favoriteList == nil) {
			self.favoriteList = [[NSMutableArray alloc] init];
			
			[prefs setObject:self.favoriteList forKey:@"nutrients"];
			[prefs synchronize];
		}
		
		[self.favoriteTableView reloadData];
	});
}



-(UIImage*) getFoodTypeImage:(int)id{
	// Cheese, corn, loaf    , veggie,   ?
	// 66-111,     , 162-222 , 299-489
	
	UIImage *imageType;
	
	if (id >= 66 && id <= 111) {
		imageType = [UIImage imageNamed:@"cheese-green-72"];
	} else if (id>=162 && id<=222){
		imageType = [UIImage imageNamed:@"loaf-green-72"];
	} else if (id>=299 && id<=489){
		imageType = [UIImage imageNamed:@"veggie-green-72"];
	} else {
		imageType = [UIImage imageNamed:@"questionmark-green"];
	}
	
	return imageType;
}

-(NSString *) imagePath:(NSString *)name{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES );
	
	NSString *documentsDirectory = path[0];
	
	NSString *imageName = [NSString stringWithFormat:@"%@.png", name ];
	NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName ];
	
	return imagePath;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.favoriteList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ITHSFavoriteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"favoriteCell"];
	
	int articleNr = [[self.favoriteList[indexPath.row] objectForKey:@"articleNumber"] integerValue];
	
	cell.articleNumberLabel.text   = [NSString stringWithFormat:@"%d", articleNr];
	cell.descriptionTextField.text = [NSString stringWithFormat:@"%@", [self.favoriteList[indexPath.row] objectForKey:@"description" ]];
	
	
	NSString *filename = [NSString stringWithFormat:@"%d-foodFavSnapshot", articleNr ];
	UIImage *image = [ UIImage imageWithContentsOfFile:[self imagePath:filename] ];
	
	if (image) {
		CGSize scaleSize = CGSizeMake(71.0, 59.0);
		UIGraphicsBeginImageContextWithOptions(scaleSize, NO, 0.0);
		[image drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
		UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
		[cell.snapshotImageView setImage:resizedImage];
		
	} else {
		[cell.snapshotImageView setImage: [self getFoodTypeImage:articleNr] ];
	}
	
    return cell;
}





#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

	if( [segue.identifier isEqualToString:@"editView"] ){
		ITHSFavoriteCell *cell= sender;

		ITHSEditViewViewController *editView = [segue destinationViewController];
		editView.articleNr = [cell.articleNumberLabel.text integerValue];
	}
}



- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}




@end
