//
//  UIImage+DrawImage.m
//
//  Created by Darktt on 13/6/3.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "UIImage+DrawImage.h"

@implementation UIImage (DrawImage)

#pragma mark - Draw Gradient Image

+ (DTInstancetype)drawGradientImageWithRect:(CGRect)frame beginColor:(UIColor *)beginColor endColor:(UIColor *)endColor location:(CGFloat *)loaction
{
    return [self drawGradientImageWithRect:frame gradientColors:@[(id)beginColor.CGColor, (id)endColor.CGColor] location:loaction];
}

+ (DTInstancetype)drawGradientImageWithRect:(CGRect)frame gradientColors:(NSArray *)gradientColors location:(CGFloat *)loaction
{
    CGSize imageSize = frame.size;
    
    UIGraphicsBeginImageContext(imageSize);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, loaction);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    CGContextSaveGState(context);
    [bezierPath addClip];
    
    CGPoint beginPoint = CGPointMake(imageSize.width / 2, 0);
    CGPoint endPoint = CGPointMake(imageSize.width / 2, imageSize.height);
    
    CGContextDrawLinearGradient(context, gradient, beginPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    UIImage *drawnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    return drawnImage;
}

+ (DTInstancetype)bicycleMapsNavigationImage
{
    CGRect imageRect = CGRectMake(0, 0, 320, 44);
    
    UIColor *beginGradientColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:204.0f/255.0f alpha:1];
    UIColor *endGradientColor = [UIColor colorWithRed:0 green:0 blue:102.0f/255.0f alpha:1];
    NSArray *gradientColors = @[(id)beginGradientColor.CGColor, (id)endGradientColor.CGColor];
    CGFloat gradientLocations[] = {0 ,1};
    
    UIImage *navigationBgImage = [self drawGradientImageWithRect:imageRect gradientColors:gradientColors location:gradientLocations];
    
    return navigationBgImage;
}

+ (DTInstancetype)redGradientImageWithframe:(CGRect)frame
{
    UIColor *beginColor = [UIColor colorWithRed:230/255.0f green:54/255.0f blue:54/255.0f alpha:1];
    UIColor *endColor = [UIColor colorWithRed:186/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    NSArray *colors = [NSArray arrayWithObjects:(id)beginColor.CGColor, (id)endColor.CGColor, nil];
    
    CGFloat location[] = {0, 1};
    
    UIImage *redGradientImage = [self drawGradientImageWithRect:frame gradientColors:colors location:location];
    
    return redGradientImage;
}

+ (DTInstancetype)grayGradientImageWithframe:(CGRect)frame
{
    UIColor *beginColor = [UIColor colorWithWhite:241/255.0f alpha:1];
    UIColor *endColor = [UIColor colorWithWhite:220/255.0f alpha:1];
    NSArray *colors = [NSArray arrayWithObjects:(id)beginColor.CGColor, (id)endColor.CGColor, nil];
    
    CGFloat location[] = {0, 1};
    
    UIImage *grayGradientImage = [self drawGradientImageWithRect:frame gradientColors:colors location:location];
    
    return grayGradientImage;
}

+ (DTInstancetype)blueGradientImageWithframe:(CGRect)frame
{
    UIColor *beginColor = [UIColor colorWithRed:43/255.0f green:128/255.0f blue:240/255.0f alpha:1];
    UIColor *endColor = [UIColor colorWithRed:43/255.0f green:108/255.0f blue:194/255.0f alpha:1];
    NSArray *colors = [NSArray arrayWithObjects:(id)beginColor.CGColor, (id)endColor.CGColor, nil];
    
    CGFloat location[] = {0, 1};
    
    UIImage *blueGradientImage = [self drawGradientImageWithRect:frame gradientColors:colors location:location];
    
    return blueGradientImage;
}

+ (DTInstancetype)greenGradientImageWithframe:(CGRect)frame
{
    UIColor *beginColor = [UIColor colorWithRed:68/255.0f green:205/255.0f blue:37/255.0f alpha:1];
    UIColor *endColor = [UIColor colorWithRed:59/255.0f green:164/255.0f blue:36/255.0f alpha:1];
    NSArray *colors = [NSArray arrayWithObjects:(id)beginColor.CGColor, (id)endColor.CGColor, nil];
    
    CGFloat location[] = {0, 1};
    
    UIImage *greenGradientImage = [self drawGradientImageWithRect:frame gradientColors:colors location:location];
    
    return greenGradientImage;
}

+ (DTInstancetype)purpleGradientImageWithframe:(CGRect)frame
{
    UIColor *beginColor = [UIColor colorWithRed:90/255.0f green:0 blue:139/255.0f alpha:1];
    UIColor *endColor = [UIColor colorWithRed:40/255.0f green:0 blue:88/255.0f alpha:1];
    NSArray *colors = [NSArray arrayWithObjects:(id)beginColor.CGColor, (id)endColor.CGColor, nil];
    
    CGFloat location[] = {0, 1};
    
    UIImage *purpleGradientImage = [self drawGradientImageWithRect:frame gradientColors:colors location:location];
    
    return purpleGradientImage;
}

#pragma mark - Draw Rouned Rect Gradient Image

+ (DTInstancetype)drawRounedRectImageWithRect:(CGRect)frame cornerRadius:(CGFloat)cornerRadius gradientColors:(NSArray *)gradientColors lineColor:(UIColor *)lineColor gradientLocation:(CGFloat *)gradientLocation
{
    CGSize imageSize = frame.size;
    CGFloat linWidth = 3.0f;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocation);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius];

    CGContextSaveGState(context);
    [bezierPath addClip];
    
    CGPoint beginPoint = CGPointMake(imageSize.width / 2, 0);
    CGPoint endPoint = CGPointMake(imageSize.width / 2, imageSize.height);
    
    CGContextDrawLinearGradient(context, gradient, beginPoint, endPoint, 0);
    
    if (lineColor != nil) {
        CGContextSetStrokeColorWithColor(context, [lineColor CGColor]);
        
        [bezierPath setLineWidth:linWidth];
        [bezierPath stroke];
    }
    
    CGContextRestoreGState(context);
    
    UIImage *drawnImage = UIGraphicsGetImageFromCurrentImageContext();
    [drawnImage resizableImageWithCapInsets:UIEdgeInsetsMake(linWidth, linWidth, linWidth, linWidth)];
    
    UIGraphicsEndImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    return drawnImage;
}

#pragma mark - Draw The Shadow Image

+ (DTInstancetype)topShadowImage
{
    UIColor *beginColor = [UIColor colorWithWhite:50/255.0f alpha:0.5f];
    UIColor *endColor = [UIColor clearColor];
    NSArray *colors = [NSArray arrayWithObjects:(id)beginColor.CGColor, (id)endColor.CGColor, nil];
    
    CGFloat location[] = {0, 1};
    
    UIImage *shadowImage = [self drawGradientImageWithRect:CGRectMake(0, 0, 1, 3) gradientColors:colors location:location];
    shadowImage = [shadowImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
    
    return shadowImage;
}

+ (DTInstancetype)buttomShadowImage
{
    UIColor *beginColor = [UIColor clearColor];
    UIColor *endColor = [UIColor colorWithWhite:50/255.0f alpha:0.5f];
    NSArray *colors = [NSArray arrayWithObjects:(id)beginColor.CGColor, (id)endColor.CGColor, nil];
    
    CGFloat location[] = {0, 1};
    
    UIImage *shadowImage = [self drawGradientImageWithRect:CGRectMake(0, 0, 1, 3) gradientColors:colors location:location];
    shadowImage = [shadowImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
    
    return shadowImage;
}

@end
