//
//  Nutrient.m
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-27.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import "Nutrient.h"

@implementation Nutrient

-(instancetype) initWithArticleNumber:(int)articleNr andDescription:(NSString *)description{
	self = [ super init];
	
	if (self ) {
		self.articleNumber = articleNr;
		self.description = description;
		self.imagePath = nil;
	}
	
	return self;

}

-(void) setImage:(NSString*)imagePath{
	self.imagePath = imagePath;
}

@end
