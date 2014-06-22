//
//  ITHSPicturesTableViewController.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-30.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "ITHSPicturesTableViewController.h"
#import "ITHSEditViewViewController.h"


@interface ITHSPicturesTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *imagesTableView;
@property (nonatomic) NSArray *favoriteList;
@end

@implementation ITHSPicturesTableViewController

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
		
		[self.imagesTableView reloadData];
	});
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.favoriteList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
    
	int articleNr = [[self.favoriteList[indexPath.row] objectForKey:@"articleNumber"] integerValue];

	NSString *filename = [NSString stringWithFormat:@"%d-foodFavSnapshot", articleNr ];
	UIImage *image = [ UIImage imageWithContentsOfFile:[self imagePath:filename] ];
	
	if (image) {
		CGSize scaleSize = CGSizeMake(287.0, 172.0);
		UIGraphicsBeginImageContextWithOptions(scaleSize, NO, 0.0);
		[image drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
		UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
		[cell.imageView setImage:resizedImage];
		cell.tag = articleNr;
	}

    return cell;
}


-(NSString *) imagePath:(NSString *)name{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES );
	
	NSString *documentsDirectory = path[0];
	
	NSString *imageName = [NSString stringWithFormat:@"%@.png", name ];
	NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName ];
	
	return imagePath;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 
	if( [segue.identifier isEqualToString:@"editView"] ){
		UITableViewCell *cell= sender;
 
		ITHSEditViewViewController *editView = [segue destinationViewController];
		editView.articleNr = cell.tag;
	}
}
 
 
 
- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
