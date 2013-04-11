//
//  UIColor+Colors.m
//
//  Created by Darktt on 17/10/12.
//  Copyright (c) 2012 Darktt. All rights reserved.
//

#import "UIColor+Colors.h"

@implementation UIColor (Colors)

+ (UIColor *)randomColor{
	CGFloat red =  (CGFloat)(arc4random()%255+1)/255.0f;
	CGFloat blue = (CGFloat)(arc4random()%255+1)/255.0f;
	CGFloat green = (CGFloat)(arc4random()%255+1)/255.0f;
    
//    NSLog(@"R:%.3f,G:%.3f,B:%.3f", red, green, blue);
    
	return [UIColor colorWithRed:red green:green blue:blue];
}

+ (UIColor *)facebookColor{
    return rgb(59, 89, 182);
}

+ (UIColor *)twitterColor{
    return rgb(144,209,237);
}

+ (UIColor *)googleRedColor{
    return rgb(214, 36, 8);
}

+ (UIColor *)googleGreenColor{
    return rgb(0, 215, 8);
}

+ (UIColor *)googleBlueColor{
    return rgb(22, 69, 174);
}

+ (UIColor *)googleYellowColor{
    return rgb(239, 186, 0);
}

+ (UIColor *)yahooRedColor{
    return rgb(255, 0, 51);
}

+ (UIColor *)colorWithHex:(UInt32)hex{
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
    
	return rgb(r,g,b);
}

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (NSArray *)colorComponentsFromColor:(UIColor *)color{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSString *colorAsString = [NSString stringWithFormat:@"Red:%.0f,Green:%.0f,Blue:%.0f,Alpha:%.0f", components[0]*255.0, components[1]*255.0, components[2]*255.0, components[3]*100];
    NSArray *componentsArr = [colorAsString componentsSeparatedByString:@","];
    
    return componentsArr;
}

@end
