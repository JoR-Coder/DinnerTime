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
@property (nonatomic) 	NSDictionary *nutritionsList;
@property (weak, nonatomic) IBOutlet UILabel *vitaminCView;
@property (weak, nonatomic) IBOutlet UILabel *fatView;
@property (weak, nonatomic) IBOutlet UILabel *proteinView;
@property (weak, nonatomic) IBOutlet UILabel *energyView;


@end

@implementation ITHSContentViewController

-(id)initWithArticle:(int)articleNumber{
	
	return nil;
}


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


-(void) loadData:(int)articleNumber{
	
	NSString *urlStr = [NSString stringWithFormat:@"http://matapi.se/foodstuff/%d", articleNumber];

	NSURL *URL = [NSURL URLWithString:urlStr];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	NSURLSession *session = [NSURLSession sharedSession];
	
	
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
								  ^(NSData *data, NSURLResponse *response, NSError *err){
									  NSError *parseError;
									  self.nutritionsList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
									  // NSLog(@"%@", self.nutritionsList);
									  if ([self.nutritionsList objectForKey:@"name"]) {
										  self.foodArticleView.text = self.nutritionsList[@"name"];
										  self.navigationItem.title = [NSString stringWithFormat:@"Artikle nr:%i",articleNumber];
										  NSDictionary *nutrients = self.nutritionsList[@"nutrientValues"];
										  
										  self.vitaminCView.text    = [NSString stringWithFormat:@"%@", nutrients[@"vitaminC"] ];
										  self.fatView.text         = [NSString stringWithFormat:@"%@", nutrients[@"fat"] ];
										  self.proteinView.text     = [NSString stringWithFormat:@"%@", nutrients[@"protein"] ];
										  self.self.energyView.text = [NSString stringWithFormat:@"%@", nutrients[@"energyKj"] ];
										  //for (NSString *key in [nutrients allKeys] ) {
										//	  NSLog( @"%@ : %@", key, [nutrients objectForKey:key] );
										  //}
									  }else if ([self.nutritionsList objectForKey:@"message"]){
										  self.foodArticleView.text = self.nutritionsList[@"message"];
									  }else{
										  self.foodArticleView.text = @"Unknown error!";
									  }
									  
								  }];
	[task resume];
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
