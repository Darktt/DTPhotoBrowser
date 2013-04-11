//
//  UIColor+Colors.h
//
//  Created by Darktt on 17/10/12.
//  Copyright (c) 2012 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

#define rgb(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/100]

@interface UIColor (Colors)

+ (UIColor *)randomColor;
+ (UIColor *)facebookColor;
+ (UIColor *)twitterColor;
+ (UIColor *)googleRedColor;
+ (UIColor *)googleGreenColor;
+ (UIColor *)googleBlueColor;
+ (UIColor *)googleYellowColor;
+ (UIColor *)yahooRedColor;
+ (UIColor *)colorWithHex:(UInt32)hex; // eg: [Colors colorWithHex:0xff00ff];
+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (NSArray *)colorComponentsFromColor:(UIColor *)color;

@end
