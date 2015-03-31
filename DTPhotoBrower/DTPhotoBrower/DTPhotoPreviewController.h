//
//  DTPhotoPreviewController.h
//  DTPhotoBrower
//
//  Created by Darktt on 2015/3/31.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTPhotoPreviewController : UIViewController

+ (instancetype)photoPreviewWithPhoto:(UIImage *)previewImage;

- (void)pushFromViewController:(UIViewController *)viewController appearRect:(CGRect)rect;

@end
