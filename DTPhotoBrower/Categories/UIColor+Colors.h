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

// Random color
+ (UIColor *)randomColor;

// Custom colors
+ (UIColor *)facebookColor;
+ (UIColor *)twitterColor;
+ (UIColor *)googleRedColor;
+ (UIColor *)googleGreenColor;
+ (UIColor *)googleBlueColor;
+ (UIColor *)googleYellowColor;
+ (UIColor *)yahooRedColor;
+ (UIColor *)lightBrownColor;
+ (UIColor *)togoBoxGrayColor;
+ (UIColor *)togoBoxGreenColor;
+ (UIColor *)baseWhiteColor;

// iOS 7 UI Color
+ (UIColor *)iOS7WhiteColor;
+ (UIColor *)iOS7BlueColor;

// Flat Colors
+ (UIColor *)flatRedColor;
+ (UIColor *)flatDarkRedColor;

+ (UIColor *)flatGreenColor;
+ (UIColor *)flatDarkGreenColor;

+ (UIColor *)flatBlueColor;
+ (UIColor *)flatDarkBlueColor;

+ (UIColor *)flatTealColor;
+ (UIColor *)flatDarkTealColor;

+ (UIColor *)flatPurpleColor;
+ (UIColor *)flatDarkPurpleColor;

+ (UIColor *)flatBlackColor;
+ (UIColor *)flatDarkBlackColor;

+ (UIColor *)flatYellowColor;
+ (UIColor *)flatDarkYellowColor;

+ (UIColor *)flatOrangeColor;
+ (UIColor *)flatDarkOrangeColor;

+ (UIColor *)flatWhiteColor;
+ (UIColor *)flatDarkWhiteColor;

+ (UIColor *)flatGrayColor;
+ (UIColor *)flatDarkGrayColor;

// Input hexadecimal string and integer
+ (id)colorWithHex:(UInt32)hex; // eg: [UIColor colorWithHex:0xff00ff];
+ (id)colorWithHexString:(NSString *)hex; // eg: [UIColor colorWithHexString:@"ff00ff"];

// Input color name with safe web color names
// Color names is define in ClolorNames.h file
+ (id)colorWithColorName:(NSString *)name;

// Input RGB value, without alpha value.
+ (id)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

// return Color RGB value.
// eg: Red Color, return Red:255,Green:0,Blue:0,Alpha:100
+ (NSArray *)colorComponentsFromColor:(UIColor *)color;
- (NSArray *)colorComponents;

@end
