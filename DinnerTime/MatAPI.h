//
//  MatAPI.h
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-06-18.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatAPI : NSObject

+(MatAPI *) sharedInstance;

@property (nonatomic) NSArray *foodList;

-(BOOL)dataLoaded;
-(NSDictionary*)getNutritions:(int)forItem;

-(NSString*)Error;

@end
