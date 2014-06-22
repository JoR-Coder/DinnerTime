//
//  MatAPI.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-06-18.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "MatAPI.h"

@interface MatAPI()

@property (nonatomic) BOOL dataLoaded;
@property (nonatomic) NSDictionary *tmpData;
@property (nonatomic) BOOL errorDetected;
@property (nonatomic) NSString *ErrorMessage;

@property (nonatomic) NSArray *CachedFoodList;
@property (nonatomic) NSMutableArray *CachedfoodItems;

@end


@implementation MatAPI


+(MatAPI *)sharedInstance{
	static MatAPI *_sharedInstance = nil;
	static dispatch_once_t oncePredicate;
	
	dispatch_once(&oncePredicate, ^{
		_sharedInstance = [[MatAPI alloc] init];
	});
	
	return _sharedInstance;
}


-(instancetype)init{
	self = [super init];
	
	if (self) {
		// Init stuff here...
		self.CachedfoodItems = [[NSMutableArray alloc] init];
		self.dataLoaded = NO;
		self.errorDetected = NO;
		[self loadData];
	}
	
	return self;
}

// TODO: Check if matapi.se has a timestamp on it's list.
// Would be good to only check that one and compare with the
// cached version :-D
// If timestamp is different, load list from matapi.se, else
//  use the saved version :-D

//  (Nope, no timestamps)
// TODO: Have only one method to fetch data from matapi.se :-/
-(void) loadData{

	dispatch_async(dispatch_get_main_queue(), ^{
		
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		self.foodList = [ NSArray arrayWithArray:[prefs objectForKey:@"foodList"] ];

		if ( self.foodList == nil) {

			NSString *urlStr = @"http://matapi.se/foodstuff";
			NSURL *URL = [NSURL URLWithString:urlStr];
			NSURLRequest *request = [NSURLRequest requestWithURL:URL];
			NSURLSession *session = [NSURLSession sharedSession];
			
			NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *err){

				if (err==nil) {
					if( [(NSHTTPURLResponse*)response statusCode] == 200) {

						NSError *parseError;
						self.foodList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];

						if (parseError == nil ) {

							self.dataLoaded = YES;
							[prefs setObject:self.foodList forKey:@"foodList"];
							[prefs synchronize];

						} else {
							[self setError:[NSString stringWithFormat:@"Error parsing JSON data : %@", parseError.localizedDescription] ];
						}
					}else{
						[self setError:[NSString stringWithFormat:@"HTTP response error : %@", response.description] ];
					}
				}else{
					[self setError:[NSString stringWithFormat:@"Error retrieving data: %@", err.localizedDescription] ];
				}
			}];
			
			[task resume];

		} else {
			// List already cached...
			self.dataLoaded = YES;
		}

		// Let's try to remember where we were the last time :-)
		self.tmpData = [[NSDictionary alloc] initWithDictionary:[prefs objectForKey:@"lastCheckedItem"]];

	});
}


-(BOOL)dataLoaded{
	return YES;
}


-(NSString *)getItemName:(int)forItem{
	
	if (self.dataLoaded) {
		// Let's see if we can find the item...
		NSPredicate *cached = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"number = %d", forItem] ];
		NSArray *filteredCached = [self.foodList filteredArrayUsingPredicate:cached];
		
		if (filteredCached.count>0) {
			// Found it. We'll assume only one hit.
			return [filteredCached[0] objectForKey:@"name"];
		}
	}

	return nil;
}

// TODO: I want to have another list... This list should contain already obtained
//  nutritionsdata. So...
// First check if forItem already is in list, return THAT, else load from matapi.se
//  and store it in the list :-D
-(NSDictionary *)getNutritions:(int)forItem{
	
	// Here I want code to check if item already is loaded.
	NSPredicate *cached = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"number = %d", forItem] ];
	NSArray *filteredCached = [self.CachedfoodItems filteredArrayUsingPredicate:cached];
	
	if (filteredCached.count>0) { return filteredCached[0]; }

	// Nope, not in list, let's fetch it from matapi.se
	dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
	
	NSString *urlStr = [NSString stringWithFormat:@"http://matapi.se/foodstuff/%d", forItem];
		
	NSURL *URL = [NSURL URLWithString:urlStr];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	NSURLSession *session = [NSURLSession sharedSession];
		
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
		^(NSData *data, NSURLResponse *response, NSError *err){
			if (err==nil) {
				if( [(NSHTTPURLResponse*)response statusCode] == 200) {

					NSError *parseError;
					NSDictionary *recievedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];

					if (parseError == nil ) {
						if ([recievedData objectForKey:@"name"]) {

							[self.CachedfoodItems addObject:recievedData];
							self.tmpData = recievedData;

						} else if ([recievedData objectForKey:@"message"]){
							[self setError:@"message"];
						}else{
							[self setError:@"Unknown error!"];
						}
					} else {
						[self setError:[NSString stringWithFormat:@"Error parsing JSON data : %@", parseError.localizedDescription] ];
					}
				}else{
					[self setError:[NSString stringWithFormat:@"HTTP response error : %@", response.description] ];
				}
			}else{
				[self setError:[NSString stringWithFormat:@"Error retrieving data: %@", err.localizedDescription] ];
			}
			dispatch_semaphore_signal(semaphore);
		}];
		
	[task resume];
	
	dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

	return self.tmpData;
}


-(NSDictionary *)getLastItem{
	return self.tmpData;
}


// ErrorHandling is important. This is my petty solution.
-(void)setError:(NSString*)msg{
	self.errorDetected = YES;
	self.ErrorMessage = msg;
}

-(NSString *)Error{
	if (self.errorDetected) {
		self.errorDetected = NO;
		return self.ErrorMessage;
	}
	return NO;
}

@end
