//
//  Nutrient.h
//  DinnerTime
//
//  Created by Jyrki Rajala on 2014-05-27.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Nutrient : NSObject

@property (nonatomic) int       articleNumber;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *imagePath;

-(instancetype) initWithArticleNumber:(int)articleNr andDescription:(NSString *)description;

-(void) setImage:(NSString*)imagePath;

@end
