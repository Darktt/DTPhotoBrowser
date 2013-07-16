//
//  UIImageView+imageView.h
//
//  Created by Darktt on 13/4/23.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (imageView)

+ (id)imageViewWithFrame:(CGRect)frame;
+ (id)imageViewWithImage:(UIImage *)image;

+ (id)imageViewWithScreenShotFrame:(CGRect)frame;

@end
