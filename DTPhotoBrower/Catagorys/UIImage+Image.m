//
//  UIImage+Image.m
//  DTTest
//
//  Created by Darktt on 13/3/28.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "UIImage+Image.h"
#import <QuartzCore/QuartzCore.h>

//#define USE_QUARTZCORE_FRAMEWORK

@implementation UIImage (Image)

+ (UIImage *)screenImageWithRect:(CGRect)rect
{
#ifdef USE_QUARTZCORE_FRAMEWORK
    CALayer *layer = [[UIApplication sharedApplication] keyWindow].layer;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, scale);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    rect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale
                      , rect.size.width * scale, rect.size.height * scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([screenshot CGImage], rect);
    UIImage *croppedScreenshot = [UIImage imageWithCGImage:imageRef
                                                     scale:screenshot.scale
                                               orientation:screenshot.imageOrientation];
    CGImageRelease(imageRef);
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    UIImageOrientation imageOrientation = UIImageOrientationUp;
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            imageOrientation = UIImageOrientationDown;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            imageOrientation = UIImageOrientationRight;
            break;
        case UIInterfaceOrientationLandscapeRight:
            imageOrientation = UIImageOrientationLeft;
            break;
        default:
            break;
    }
    
    UIImage *shotImage = [[UIImage alloc] initWithCGImage:croppedScreenshot.CGImage
                                                    scale:croppedScreenshot.scale
                                              orientation:imageOrientation];
    
    return [shotImage autorelease];
#else
    return nil;
#endif
}

@end
