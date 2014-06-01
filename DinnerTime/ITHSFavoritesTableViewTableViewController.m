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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;



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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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


-(UIImage*) getFoodTypeImage:(int)id{
	// Cheese, corn, loaf    , veggie,   ?
	// 66-111,     , 162-222 , 299-489
	
	UIImage *imageType;
	
	//		NSLog(@"Index: %d got : %@", indexPath.row, self.foodList[indexPath.row][@"name"]);
	if (id >= 66 && id <= 111) {
		NSLog(@"Cheeses");
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

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
