//
//  UIImage+resizeImage.h
//
//  Created by Darktt on 13/4/3.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeImage)

+ (UIImage *)resizeImageWithSourceImageName:(NSString *)sourceName forMaxSize:(CGFloat)maxSize;

@end
