//
//  ITHSContentViewController.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-25.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "ITHSContentViewController.h"

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
@property UICollisionBehavior *collision;
@property UISnapBehavior *snap;

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
/*

 20
 20g 40 kolhydr om dan ( gult )
 40 - 60 > orang
 120 > Rött
 
 ( margarin solrosolja palmolja < verbotten > raps kokos oliv )
 wholegrain = verbotten
 saccharose / disaccharides =
 Annika Dalquist ( fettdoktorn )
 
 matdagboken.
 
 KursInfo...
	Upphämtnings-tid :-)
	Imorgon... Har jag klarat av allt behövs inte närvaro på eftermiddan.
	Sönda deadline.
	Extrauppgiften måste göras :-(
	Skall kunna strömposta någon med en färdig-ifylld sak.
	 Endast mottagaren skall ifyllas.
 
	Jag gör väl även extrauppgiften.
	 minst fem ikoner som visar vad för typ av matvara det handlar om.
 
	
	Del tre av kursen nästa vecka...
	Eget projekt.
	 Något som skall ta en månads tid...
	 Planera milstolpar o jox
	 1. Sinus-app
	 2. RemoteFiles-app (backend hemma hos mig, python/php/laravel???)
	 3. ?
 
 
 Varför inte ett GUI till cocoa Pods? (hms... Eller en egen git)
 
 github.com/trending?l=objective-c
 
 Gå in i roten till ditt projekt, se till att den är stängd i XCode5
 
 pod init
 <redigera din PodFile>
 pod install
 starta genom att använda sig av nya ?.xcworkspace
 
 Klart :)
 
 utvecklings@iths.se
 IThs2012
 
 
 */

- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}


-(void) loadData:(int)articleNumber{
	
	NSString *urlStr = [NSString stringWithFormat:@"http://matapi.se/foodstuff/%d", articleNumber];

	NSURL *URL = [NSURL URLWithString:urlStr];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	NSURLSession *session = [NSURLSession sharedSession];
	
	
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
								  ^(NSData *data, NSURLResponse *response, NSError *err){
									  NSError *parseError;
									  self.nutritionsList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
									  NSLog(@"-- %@", self.nutritionsList );
									  if ([self.nutritionsList objectForKey:@"name"]) {
										  dispatch_async(dispatch_get_main_queue(), ^{
											  self.foodArticleView.text = self.nutritionsList[@"name"];
											  self.navigationItem.title = [NSString stringWithFormat:@"Artikle nr:%i",articleNumber];
											  NSDictionary *nutrients = self.nutritionsList[@"nutrientValues"];
										  
											  //self.vitaminCView.text    = [NSString stringWithFormat:@"%@", nutrients[@"vitaminC"] ];
											  //self.fatView.text         = [NSString stringWithFormat:@"%@", nutrients[@"fat"] ];

											  [self isItLSHFApproved:@"fat" amount:[nutrients[@"fat"] floatValue]];
											  [self isItLSHFApproved:@"magnesium" amount:[nutrients[@"magnesium"] floatValue]];
											  [self isItLSHFApproved:@"protein" amount:[nutrients[@"protein"] floatValue]];
											  [self isItLSHFApproved:@"saturatedFattyAcids" amount:[nutrients[@"saturatedFattyAcids"] floatValue]];
											  
											  //self.proteinView.text     = [NSString stringWithFormat:@"%@", nutrients[@"protein"] ];
											  //self.energyView.text = [NSString stringWithFormat:@"%@", nutrients[@"energyKj"] ];
										  });
									  }else if ([self.nutritionsList objectForKey:@"message"]){
										  self.foodArticleView.text = self.nutritionsList[@"message"];
									  }else{
										  self.foodArticleView.text = @"Unknown error!";
									  }
									  
								  }];
	[task resume];

	//dispatch_async(dispatch_get_main_queue(), ^{
		
	
	//});
	
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
	
	if ([nutrition isEqualToString:@"fat"]) {
		float fatRDI = amount / [self.RDIList[@"fat"] floatValue];
		float hue = (0.25 - (fatRDI*0.25));

		self.Fatlevel.progress = fatRDI;
		self.fatView.backgroundColor = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
		NSLog(@"fatRDI=%f, hue = %f", fatRDI, hue);
}
	
	if ([nutrition isEqualToString:@"magnesium"]) {
		float magnesiumRDI = amount / [self.RDIList[@"magnesium"] floatValue];
		float hue = 0.25 - (magnesiumRDI*0.25);

		self.magnesiumLevel.progress = magnesiumRDI;
		self.magnesiumView.backgroundColor = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
		NSLog(@"magnesiumRDI=%f, hue = %f", magnesiumRDI, hue);
	}
	if ([nutrition isEqualToString:@"protein"]) {
		float proteinRDI = amount / [self.RDIList[@"protein"] floatValue];
		float hue = 0.25 - (proteinRDI*0.25);

		self.ProteinLevel.progress = proteinRDI;
		self.proteinView.backgroundColor = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
		NSLog(@"proteinRDI=%f, hue = %f", proteinRDI, hue);
	}

	if ([nutrition isEqualToString:@"saturatedFattyAcids"]) {
		float sfaRDI = amount / [self.RDIList[@"saturatedFattyAcids"] floatValue];
		float hue = 0.25 - (sfaRDI*0.25);

		self.SaturatedFatLevel.progress = sfaRDI;
		self.SaturatedFattyAcidsView.backgroundColor = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
		NSLog(@"Saturated fatty acids RDI=%f, hue = %f", sfaRDI, hue);
	}

}


- (IBAction)add2Favorite:(id)sender {

	[self animateSaved];
	return;
	
	NSNumber *v1 = @10;
	NSNumber *v2 = @12;
	NSNumber *v3 = @( [v1 integerValue] +  [v2 integerValue] );
	
	NSLog(@"I got %@", v3);

	NSDictionary *Favorite = @{ @"articleNumber" : [NSNumber numberWithInteger:self.foodArticle],
								   @"description"   : self.nutritionsList[@"name"],
								   @"imagePath"     : @" " };

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSMutableArray *nutrients = [ NSMutableArray arrayWithArray:[prefs objectForKey:@"nutrients"] ];
	
	if ( nutrients == nil) {
		NSMutableArray *newNutrients = [[NSMutableArray alloc] init];
		
		[newNutrients addObject: Favorite ];
		
		[prefs setObject:newNutrients forKey:@"nutrients"];
		[prefs synchronize];

	} else {
		if (nutrients.count>0) {
			//search...
			
		}
		[nutrients addObject: Favorite ];

		[prefs setObject:nutrients forKey:@"nutrients"];
		[prefs synchronize];
	}
	
	
}

-(void)animateSaved{

	UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 100, 100, 20)];

	[yourLabel setTextColor:[UIColor blackColor]];
	[yourLabel setBackgroundColor:[UIColor clearColor]];
	[yourLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
	[yourLabel setText:@"I'm Adding"];
	
	[yourLabel setTextAlignment:NSTextAlignmentCenter];
	
	[self.view addSubview:yourLabel];
	[self.view bringSubviewToFront:yourLabel];
	
	CGFloat screenWidth  = [[UIScreen mainScreen] bounds].size.width;
	CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
	CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    int statusBarHeight = MIN(statusBarSize.width, statusBarSize.height);
	
	int navBarHeight     = self.navigationController.navigationBar.frame.size.height;
	int yourLabelHeight = yourLabel.frame.size.height;
	int yourLabelWidth  = yourLabel.frame.size.width;
	
	int viewTop;
	int viewBottom;
	int viewLeft;
	int viewRight;
	
	if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) ||
        ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))
	{
		// NSLog(@"Landscape mode");
		viewTop = (statusBarHeight*2)+(navBarHeight)+(yourLabelHeight/2);
		viewRight        = screenHeight-statusBarHeight- (yourLabelWidth/2);
		viewLeft         = statusBarHeight + (yourLabelWidth/2);
		viewBottom       = screenWidth-statusBarHeight - (yourLabelHeight/2);
		
	} else {
		// NSLog(@"Portrait mode!");
		viewTop = (statusBarHeight*2)+(navBarHeight)+(yourLabelHeight/2);
		viewRight        = screenWidth-statusBarHeight- (yourLabelWidth/2);
		viewLeft         = statusBarHeight + (yourLabelWidth/2);
		viewBottom       = screenHeight-statusBarHeight - (yourLabelHeight/2);
	}
	
	// NSLog(@"Screen width = %f, height = %f", screenWidth, screenHeight);
	
//	CGPoint p_upperLeft  = { viewLeft ,    viewTop }; //  52, 96
	CGPoint p_upperRight = { viewRight,    viewTop }; // 268, 96
//	CGPoint p_lowerLeft  = { viewLeft , viewBottom };   //  52, 428
	CGPoint p_lowerRight = { viewRight, viewBottom };   // 268, 428
	
	yourLabel.center = p_upperRight;
	
	[UIView animateWithDuration:1.2 animations:^{
		yourLabel.center = p_lowerRight;
	} completion:^(BOOL finished) {
		[yourLabel removeFromSuperview];
	}];

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

@end
