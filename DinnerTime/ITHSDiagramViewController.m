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
@property (weak, nonatomic) IBOutlet GKBarGraph *diagramView;
@property (weak, nonatomic) IBOutlet GKBarGraph *diagramViewBack;
@property (weak, nonatomic) IBOutlet UITableView *ArticlesToCompareTableView;

@property (nonatomic) ITHSSecondDiagramView *backBarView;

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
    // Do any additional setup after loading the view.
	
	// self.Values = @[ @10, @20, @30];
	
	
	CGRect frame = CGRectMake(0, 0, 258, 190);
	 self.backBarView = [[ITHSSecondDiagramView alloc] initWithFrame:frame];
	[self.diagramViewBack addSubview:self.backBarView];
	[self.backBarView draw];
	
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
		
		NSDictionary *recievedData = [[MatAPI sharedInstance] getNutritions:articleNumber];
		
		self.nutritionA = recievedData[@"nutrientValues"];
		[self.diagramView draw];
		
	});

}


-(void) loadDataForDiagramBack:(int)articleNumber{
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		NSDictionary *recievedData = [[MatAPI sharedInstance] getNutritions:articleNumber];
		
		self.backBarView.nutritionB = recievedData[@"nutrientValues"];
		
		//[self.diagramViewBack.subviews[0] draw];
		[self.backBarView draw];
		
	});

	
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Diagram protocol

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
	return @[ @"A",@"B",@"C",@"D",@"E" ][index];
}




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
	
	// Update backDiagram...
	[self loadDataForDiagramBack:cell.tag];
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
