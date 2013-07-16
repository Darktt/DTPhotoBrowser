//
//  UIImageView+imageView.m
//
//  Created by Darktt on 13/4/23.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "UIImageView+imageView.h"
#import <QuartzCore/QuartzCore.h>

//#define USE_QUARTZCORE_FRAMEWORK 

@implementation UIImageView (imageView)

+ (id)imageViewWithFrame:(CGRect)frame
{
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    
    return imageView;
}

+ (id)imageViewWithImage:(UIImage *)image
{
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    
    return imageView;
}

+ (id)imageViewWithScreenShotFrame:(CGRect)frame
{
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    [imageView setImage:[self screenImageWithRect:frame]];
    
    return imageView;
}

+ (UIImage *)screenImageWithRect:(CGRect)rect
{
#ifdef USE_QUARTZCORE_FRAMEWORK
    CALayer *layer = [[[UIApplication sharedApplication] keyWindow] layer];
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