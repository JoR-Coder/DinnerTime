//
//  ITHSContentViewController.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-25.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "ITHSContentViewController.h"
#import "ITHSDiagramViewController.h"
#import "MatAPI.h"

@interface ITHSContentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *foodArticleView;

@property (weak, nonatomic) IBOutlet UILabel *SaturatedFattyAcidsView;
@property (weak, nonatomic) IBOutlet UILabel *fatView;
@property (weak, nonatomic) IBOutlet UILabel *proteinView;
@property (weak, nonatomic) IBOutlet UILabel *magnesiumView;

@property (weak, nonatomic) IBOutlet UIProgressView *Fatlevel;
@property (weak, nonatomic) IBOutlet UIProgressView *magnesiumLevel;
@property (weak, nonatomic) IBOutlet UIProgressView *ProteinLevel;
@property (weak, nonatomic) IBOutlet UIProgressView *SaturatedFatLevel;

@property (nonatomic) 	NSDictionary *nutritionsList;
@property (nonatomic) 	NSDictionary *RDIList;

@property (nonatomic) BOOL added2Favorite;

@property UIDynamicAnimator *animator; // Holds all the behaviours.
@property UIGravityBehavior *gravity;
// @property UICollisionBehavior *collision;
// @property UISnapBehavior *snap;

@end

@implementation ITHSContentViewController

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
	self.foodArticleView.text = [NSString stringWithFormat:@"Näringsvärden att hämta från : %d", self.foodArticle ];
	[self loadData:self.foodArticle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}


-(void) loadData:(int)articleNumber{
	
	dispatch_async(dispatch_get_main_queue(), ^{

		self.nutritionsList = [[MatAPI sharedInstance] getNutritions:self.foodArticle];

		self.foodArticleView.text = self.nutritionsList[@"name"];
		self.navigationItem.title = [NSString stringWithFormat:@"Artikle nr:%i",articleNumber];
		NSDictionary *nutrients = self.nutritionsList[@"nutrientValues"];
		
		[self isItLSHFApproved:@"fat" amount:[nutrients[@"fat"] floatValue]];
		[self isItLSHFApproved:@"magnesium" amount:[nutrients[@"magnesium"] floatValue]];
		[self isItLSHFApproved:@"protein" amount:[nutrients[@"protein"] floatValue]];
		[self isItLSHFApproved:@"saturatedFattyAcids" amount:[nutrients[@"saturatedFattyAcids"] floatValue]];
		
	});


	
	// Based on 2000 Calorie intake, for adults and children four or more years...
	NSMutableDictionary *rdi = [[NSMutableDictionary alloc] init];
	
//	[rdi setObject:@0.0 forKey:@"alcohol"];
//	[rdi setObject:@0.0 forKey:@"ash"];
//	[rdi setObject:@0.0 forKey:@"betacarotene"];
//	[rdi setObject:@0.0 forKey:@"calcium"];
//	[rdi setObject:@0.0 forKey:@"carbohydrates"];
//	[rdi setObject:@0.0 forKey:@"cholesterol"];
//	[rdi setObject:@0.0 forKey:@"dha = 0"];
//	[rdi setObject:@0.0 forKey:@"disaccharides"];
//	[rdi setObject:@0.0 forKey:@"dpa"];
//	[rdi setObject:@0.0 forKey:@"energyKcal"];
//	[rdi setObject:@0.0 forKey:@"energyKj"];
//	[rdi setObject:@0.0 forKey:@"epa"];
	[rdi setObject:@65.0 forKey:@"fat"]; // grams
//	[rdi setObject:@0.0 forKey:@"fattyAcid120"];
//	[rdi setObject:@0.0 forKey:@"fattyAcid140"];
//	[rdi setObject:@0.0 forKey:@"fattyAcid160"];
//	[rdi setObject:@0.0 forKey:@"fattyAcid161"];
//	[rdi setObject:@0.0 forKey:@"fattyAcid180"];
//	[rdi setObject:@0.0 forKey:@"fattyAcid181"];
//	[rdi setObject:@0.0 forKey:@"fattyAcid182"];
//	[rdi setObject:@0.0 forKey:@"fattyAcid183"];
//	[rdi setObject:@0.0 forKey:@"fattyAcid200"];
//	[rdi setObject:@0.0 forKey:@"fattyAcid204"];
//	[rdi setObject:@0.0 forKey:@"fattyAcid40100"];
//	[rdi setObject:@0.0 forKey:@"fibres"];
//	[rdi setObject:@0.0 forKey:@"folate"];
//	[rdi setObject:@0.0 forKey:@"iron"];
	[rdi setObject:@400.0 forKey:@"magnesium"]; // grams
//	[rdi setObject:@0.0 forKey:@"monosaccharides"];
//	[rdi setObject:@0.0 forKey:@"monounsaturatedFattyAcids"];
//	[rdi setObject:@0.0 forKey:@"niacin"];
//	[rdi setObject:@0.0 forKey:@"niacinEquivalents"];
//	[rdi setObject:@0.0 forKey:@"phosphorous"];
//	[rdi setObject:@0.0 forKey:@"potassium"];
	[rdi setObject:@50.0 forKey:@"protein"]; // grams
//	[rdi setObject:@0.0 forKey:@"retinol"];
//	[rdi setObject:@0.0 forKey:@"retinolEquivalents"];
//	[rdi setObject:@0.0 forKey:@"riboflavin"];
//	[rdi setObject:@0.0 forKey:@"saccharose"];
//	[rdi setObject:@0.0 forKey:@"salt"];
	[rdi setObject:@20.0 forKey:@"saturatedFattyAcids"]; // grams
//	[rdi setObject:@0.0 forKey:@"selenium"];
//	[rdi setObject:@0.0 forKey:@"sodium"];
//	[rdi setObject:@0.0 forKey:@"sumPolyunsaturatedFattyAcids"];
//	[rdi setObject:@0.0 forKey:@"thiamine"];
//	[rdi setObject:@0.0 forKey:@"transFattyAcids"];
//	[rdi setObject:@0.0 forKey:@"trash"];
//	[rdi setObject:@0.0 forKey:@"vitaminB12"];
//	[rdi setObject:@0.0 forKey:@"vitaminB6"];
//	[rdi setObject:@0.0 forKey:@"vitaminC"];
//	[rdi setObject:@0.0 forKey:@"vitaminD"];
//	[rdi setObject:@0.0 forKey:@"vitaminE"];
//	[rdi setObject:@0.0 forKey:@"water"];
//	[rdi setObject:@0.0 forKey:@"wholegrain"];
//	[rdi setObject:@0.0 forKey:@"zink"];
	
	self.RDIList = rdi;
}


// stort tips... Nyttja colorWithHue istället.
// Från 120 till 0 är alltså grönt -> gult -> rött.
// Ta alltså procentsatsen RDI av 120 minus 120.
// Eller i vårt fall... från 0.25 till noll.

-(void) isItLSHFApproved:(NSString*) nutrition amount:(float) amount
{
	// NSLog(@"Asking RDI for %f grams of %@", amount, nutrition);
	
	NSDictionary *views = @{ @"fat"                : @{@"level": self.Fatlevel, @"view":self.fatView},
							 @"magnesium"          : @{@"level": self.magnesiumLevel, @"view":self.magnesiumView},
							 @"protein"            : @{@"level": self.ProteinLevel, @"view":self.proteinView},
							 @"saturatedFattyAcids": @{@"level": self.SaturatedFatLevel, @"view":self.SaturatedFattyAcidsView} };

	float nutritionRDI = amount / [self.RDIList[nutrition] floatValue];
	float hue = (0.25 - (nutritionRDI*0.25));

	[[views[nutrition] objectForKey:@"level"] setProgress: nutritionRDI];
	[[views[nutrition] objectForKey:@"view"] setBackgroundColor:[UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0] ];
	
	// TODO: Add code to detect forbidden substances here...
/*	20
	20g 40 kolhydr om dan ( gult )
	40 - 60 > orang
	120 > Rött
	
	( margarin solrosolja palmolja < verbotten > raps kokos oliv )
	wholegrain = verbotten
	saccharose / disaccharides = Oooononononononoooou!
	Annika Dalquist ( fettdoktorn ) */

}


- (IBAction)add2Favorite:(id)sender {

	NSDictionary *Favorite = @{ @"articleNumber" : [NSNumber numberWithInteger:self.foodArticle],
								   @"description": self.nutritionsList[@"name"],
								   @"imagePath"  : @" " };

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSMutableArray *nutrients = [ NSMutableArray arrayWithArray:[prefs objectForKey:@"nutrients"] ];
	
	if ( nutrients == nil) {
		NSMutableArray *newNutrients = [[NSMutableArray alloc] init];
		[newNutrients addObject: Favorite ];
		[prefs setObject:newNutrients forKey:@"nutrients"];

	} else {
		if (nutrients.count>0) {
			//search...
			NSArray *filtered = [nutrients filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"articleNumber == %d", self.foodArticle] ];

			if (filtered.count>0) {
				// Found it... Bail out, bail the heck out, now now nooow.
				[self animateSaved:@"Already in favourites"];
				return;
				
			}
		}
		
		[nutrients addObject: Favorite ];
		[prefs setObject:nutrients forKey:@"nutrients"];
		
		[prefs synchronize];
	}


	[self animateSaved:@"Adding to favourites"];

	return;
}

-(void)animateSaved:(NSString*)message{

	UITextField *dropMessage = [[UITextField alloc] init];

	[dropMessage setTextColor:[UIColor blueColor]];
	[dropMessage setBackgroundColor:[UIColor greenColor]];
	[dropMessage setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
	[dropMessage setUserInteractionEnabled:NO];
	[dropMessage setBorderStyle:UITextBorderStyleRoundedRect];
	[dropMessage setTextAlignment:NSTextAlignmentCenter];
	[dropMessage setText:message];
	[dropMessage sizeToFit];
	
	[self.view addSubview:dropMessage];
	
	NSDictionary *dropMessageGeometries = [self getGeometries:dropMessage];

	CGPoint upperRight = [dropMessageGeometries[@"upperLeft"] CGPointValue];
	CGPoint lowerRight = [dropMessageGeometries[@"lowerLeft"] CGPointValue];

	lowerRight.y = lowerRight.y/2;
	[dropMessage setCenter:upperRight];
	
	[UIView animateWithDuration:3 animations:^{
		[dropMessage setCenter:lowerRight];
		[dropMessage setAlpha:0.0];
	} completion:^(BOOL finished) {
		[dropMessage removeFromSuperview];
	}];
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



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	if( [segue.identifier isEqualToString:@"DiagramSegue"] || [segue.identifier isEqualToString:@"DiagramSwipe"]){
				
		ITHSDiagramViewController *diagramView = [segue destinationViewController];
		
		diagramView.foodArticle = self.foodArticle;
	}
}

@end
