//
//  UIImage+DrawImage.h
//
//  Created by Darktt on 13/6/3.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTInstancetype.h"

@interface UIImage (DrawImage)

// Draw Gradient Image 
+ (DTInstancetype)drawGradientImageWithRect:(CGRect)frame beginColor:(UIColor *)beginColor endColor:(UIColor *)endColor location:(CGFloat *)loaction;
+ (DTInstancetype)drawGradientImageWithRect:(CGRect)frame gradientColors:(NSArray *)gradientColors location:(CGFloat *)loaction;

+ (DTInstancetype)bicycleMapsNavigationImage;
+ (DTInstancetype)redGradientImageWithframe:(CGRect)frame;
+ (DTInstancetype)grayGradientImageWithframe:(CGRect)frame;
+ (DTInstancetype)blueGradientImageWithframe:(CGRect)frame;
+ (DTInstancetype)greenGradientImageWithframe:(CGRect)frame;
+ (DTInstancetype)purpleGradientImageWithframe:(CGRect)frame;

// Draw Rounded Rect Gradient Image
+ (DTInstancetype)drawRounedRectImageWithRect:(CGRect)frame cornerRadius:(CGFloat)cornerRadius gradientColors:(NSArray *)gradientColors lineColor:(UIColor *)lineColor gradientLocation:(CGFloat *)gradientLocation;

// Draw Shadow Image
+ (DTInstancetype)topShadowImage;
+ (DTInstancetype)buttomShadowImage;

@end
