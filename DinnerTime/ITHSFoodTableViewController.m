//
//  ITHSFoodTableViewController.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-18.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "ITHSFoodTableViewController.h"
#import "ITHSContentViewController.h"
#import "MatAPI.h"

@interface ITHSFoodTableViewController ()

@property (nonatomic) NSArray *foodList;
@property (nonatomic) NSArray *foodSearchList;
@property (strong, nonatomic) IBOutlet UITableView *foodTableView;

@end

@implementation ITHSFoodTableViewController

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
    
	[self loadData];
}


-(void) loadData{
	
	dispatch_async(dispatch_get_main_queue(), ^{
		int count=0;
		while ( ![[MatAPI sharedInstance] dataLoaded] ) {

			[NSThread sleepForTimeInterval:0.5];

			if (++count>8) {
				NSLog(@"I didn't want to wait anymore :/");
				break;
			}
		}
		self.foodList = [[MatAPI sharedInstance] foodList];
		[self.foodTableView reloadData];
	});
									  
}


-(BOOL) searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString*)searchString{
	
	NSPredicate *searchPredicate = [ NSPredicate predicateWithFormat:@"name contains[c] %@", searchString ];
	
	self.foodSearchList = [self.foodList filteredArrayUsingPredicate:searchPredicate];

	return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView ) {
		return self.foodSearchList.count;

	} else {

		return self.foodList.count;
	}

    return self.foodList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"foodCell"];
	
	if (tableView == self.searchDisplayController.searchResultsTableView ) {

		cell.textLabel.text = self.foodSearchList[indexPath.row][@"name"];
		int number = [self.foodSearchList[indexPath.row][@"number"] integerValue];
		cell.imageView.image = [self getFoodTypeImage:number];

	} else {

		cell.textLabel.text = self.foodList[indexPath.row][@"name"];
		int number = [self.foodList[indexPath.row][@"number"] integerValue];
		cell.imageView.image = [self getFoodTypeImage:number];
	}

	return cell;
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
		imageType = [UIImage imageNamed:@"questionmark-green-small"];
	}

	return imageType;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if( [segue.identifier isEqualToString:@"DetailView"] ){

		UITableViewCell *cell = sender;
		
		NSString * foodArticle = cell.textLabel.text;
		NSArray *filtered = [self.foodList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", foodArticle] ];
		NSDictionary *item = [filtered objectAtIndex:0];

		ITHSContentViewController *contentView = [segue destinationViewController];

		contentView.foodArticle = [item[@"number"] integerValue];
	}
}


- (IBAction)goBack:(id)sender {

	[self.navigationController popViewControllerAnimated:YES];
}

@end
