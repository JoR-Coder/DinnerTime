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
	 3.
 
 
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

-(void) isItLSHFApproved:(NSString*) nutrition amount:(float) amount
{
	NSLog(@"Asking RDI for %f grams of %@", amount, nutrition);
	
	if ([nutrition isEqualToString:@"fat"]) {
		float fatRDI = amount / [self.RDIList[@"fat"] floatValue];
		if (fatRDI <= 0.5 ) {
			self.Fatlevel.progress = fatRDI;
		}
		else if (fatRDI > 0.5 && fatRDI < 1 ) {
			self.Fatlevel.progress = fatRDI;
			self.fatView.backgroundColor = [UIColor orangeColor];
			NSLog(@" %f fat of RDI", fatRDI);
		} else{
			self.Fatlevel.progress = 1;
			self.fatView.backgroundColor = [UIColor redColor];
			NSLog(@"Fat Maxed out.");
		}
	}
	
	if ([nutrition isEqualToString:@"magnesium"]) {
		float magnesiumRDI = amount / [self.RDIList[@"magnesium"] floatValue];
		if (magnesiumRDI <= 0.5 ) {
			self.magnesiumLevel.progress = magnesiumRDI;
		}
		else if (magnesiumRDI > 0.5 && magnesiumRDI < 1 ) {
			self.magnesiumLevel.progress = magnesiumRDI;
			self.magnesiumView.backgroundColor = [UIColor orangeColor];
			NSLog(@" %f magnesium of RDI", magnesiumRDI);
		} else{
			self.magnesiumLevel.progress = 1;
			self.magnesiumView.backgroundColor = [UIColor redColor];
			NSLog(@"Magnesium Maxed out.");
		}
	}
	if ([nutrition isEqualToString:@"protein"]) {
		float proteinRDI = amount / [self.RDIList[@"protein"] floatValue];
		if (proteinRDI <= 0.5 ) {
			self.ProteinLevel.progress = proteinRDI;
		}
		else if (proteinRDI > 0.5 && proteinRDI < 1 ) {
			self.ProteinLevel.progress = proteinRDI;
			self.proteinView.backgroundColor = [UIColor orangeColor];
			NSLog(@" %f protein of RDI", proteinRDI);
		} else{
			self.ProteinLevel.progress = 1;
			self.proteinView.backgroundColor = [UIColor redColor];
			NSLog(@"Protein Maxed out.");
		}
	}

	if ([nutrition isEqualToString:@"saturatedFattyAcids"]) {
		float sfaRDI = amount / [self.RDIList[@"saturatedFattyAcids"] floatValue];
		if (sfaRDI <= 0.5 ) {
			self.SaturatedFatLevel.progress = sfaRDI;
		}
		else if (sfaRDI > 0.5 && sfaRDI < 1 ) {
			self.SaturatedFatLevel.progress = sfaRDI;
			self.SaturatedFattyAcidsView.backgroundColor = [UIColor orangeColor];
			NSLog(@" %f saturated fat of RDI", sfaRDI);
		} else{
			self.SaturatedFatLevel.progress = 1;
			self.SaturatedFattyAcidsView.backgroundColor = [UIColor redColor];
			NSLog(@"SFA Maxed out.");
		}
	}

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
