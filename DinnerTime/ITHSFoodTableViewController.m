//
//  ITHSFoodTableViewController.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-18.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "ITHSFoodTableViewController.h"
#import "ITHSContentViewController.h"

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
		[self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// TODO: Errorcheck... No good idea to have foodList nil.
-(void) loadData{
	NSString *urlStr = @"http://matapi.se/foodstuff";
	NSURL *URL = [NSURL URLWithString:urlStr];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	NSURLSession *session = [NSURLSession sharedSession];
	
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
								  ^(NSData *data, NSURLResponse *response, NSError *err){
									  NSError *parseError;
									  self.foodList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
									  dispatch_async(dispatch_get_main_queue(), ^{
										  [self.foodTableView reloadData];
									  });

								  }];
	[task resume];
}


-(BOOL) searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString*)searchString{
	
	NSPredicate *searchPredicate = [ NSPredicate predicateWithFormat:@"name contains[c] %@", searchString ];
	
	self.foodSearchList = [self.foodList filteredArrayUsingPredicate:searchPredicate];

	return YES;
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
	
	
    // Configure the cell...
	if (tableView == self.searchDisplayController.searchResultsTableView ) {
		cell.textLabel.text = self.foodSearchList[indexPath.row][@"name"];
	} else {
		cell.textLabel.text = self.foodList[indexPath.row][@"name"];
	}
	

    return cell;
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
	if( [segue.identifier isEqualToString:@"DetailView"] ){
		UITableViewCell *cell= sender;
		
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
