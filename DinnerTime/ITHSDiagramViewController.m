//
//  ITHSDiagramViewController.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-06-04.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "ITHSDiagramViewController.h"
#import "ITHSSecondDiagramView.h"
#import "MatAPI.h"

@interface ITHSDiagramViewController ()

@property (retain, nonatomic) IBOutlet GKBarGraph *diagramView;
@property (retain, nonatomic) IBOutlet ITHSSecondDiagramView *diagramViewBack;
@property (weak, nonatomic) IBOutlet UITableView *ArticlesToCompareTableView;
@property (weak, nonatomic) IBOutlet UILabel *articleNameLabel;

@property (nonatomic) NSDictionary *nutritionA;

@property (nonatomic) NSDictionary *recievedDataTable;

@property (nonatomic) NSArray *foodList;


@end

@implementation ITHSDiagramViewController

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
	
	// Awh! For the love of every bug there is :-(
	//  Why is GKBarGraph drawing outside it's own view :-(
	CGRect frame = self.diagramView.frame;
	
	frame.size.width = 270;
	frame.size.height = 124;

	self.diagramViewBack.frame = frame;
	self.diagramViewBack.dataSource = self.diagramViewBack;
	[self.diagramViewBack draw];

	self.diagramView.frame = frame;
	self.diagramView.dataSource = self;
	[self loadDataForDiagramFront:self.foodArticle];

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
		[self.ArticlesToCompareTableView reloadData];
	});
	
}


-(void) loadDataForDiagramFront:(int)articleNumber{
	

	dispatch_async(dispatch_get_main_queue(), ^{
		
		self.articleNameLabel.text = [[MatAPI sharedInstance] getItemName:articleNumber];
		
		NSDictionary *recievedData = [[MatAPI sharedInstance] getNutritions:articleNumber];
		
		self.nutritionA = recievedData[@"nutrientValues"];

		[self.diagramView draw];
	});

}


-(void) loadDataForDiagramBack:(int)articleNumber{
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		NSDictionary *recievedData = [[MatAPI sharedInstance] getNutritions:articleNumber];
		
		self.diagramViewBack.nutritionB = recievedData[@"nutrientValues"];
		
		[self.diagramViewBack draw];
		
	});

	
}


#pragma mark - GKBarGraphDataSource

- (NSInteger)numberOfBars {
    return 4;
}

- (NSNumber *)valueForBarAtIndex:(NSInteger)index {
	switch (index) {
		case 0:
			return self.nutritionA[@"fat"];
		case 1:
			return self.nutritionA[@"magnesium"];
		case 2:
			return self.nutritionA[@"protein"];
		case 3:
			return self.nutritionA[@"saturatedFattyAcids"];
		default:
			return 0;
	}

    // return @( 20 + 10 * index );
}

-(UIColor *)colorForBarAtIndex:(NSInteger)index{
	return [UIColor colorWithHue:index * 0.25f saturation:1.0f brightness:1.0f alpha:1.0f];
}

-(UIColor *)colorForBarBackgroundAtIndex:(NSInteger)index{
	return [UIColor clearColor];
}

-(CFTimeInterval)animationDurationForBarAtIndex:(NSInteger)index{
	return 1;
}

-(NSString *)titleForBarAtIndex:(NSInteger)index{
	return @[ @"A",@"B",@"C",@"D" ][index];
}


#pragma mark - UITableViewData & Delegations...

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.foodList.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

	UITableViewCell *cell = [self.ArticlesToCompareTableView dequeueReusableCellWithIdentifier:@"articleCell"];
	
	cell.textLabel.text = self.foodList[indexPath.row][@"name"];
	cell.tag = [self.foodList[indexPath.row][@"number"] integerValue];
	
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	[self loadDataForDiagramBack:cell.tag];
}


#pragma mark - Navigation

- (IBAction)goBack:(id)sender {

	[self.navigationController popViewControllerAnimated:YES];
}

@end
