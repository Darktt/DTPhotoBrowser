//
//  NSString+String.h
//
//  Created by Darktt on 30/12/12.
//  Copyright (c) 2012 Darktt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (String)

+ (id)stringWithInteger:(NSInteger)integer;
+ (id)stringWithFloat:(float)f numberOfDecimalPlaces:(NSUInteger)dP;

- (id)initWithInteger:(NSInteger)integer;
- (id)initWithFloat:(float)f numberOfDecimalPlaces:(NSUInteger)dP;

- (long long)hexLongLongValue;
- (NSInteger)hexIntegerValue;

@end
