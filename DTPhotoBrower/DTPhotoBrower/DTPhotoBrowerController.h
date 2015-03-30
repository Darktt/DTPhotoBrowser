//
//  DTPhotoBrowerController.h
//  DTPhotoBrower
//
//  Created by Darktt on 2015/3/30.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHFetchResult;

@interface DTPhotoBrowerController : UIViewController

+ (instancetype)photoBrowerWithAssets:(NSArray *)assets;
+ (instancetype)photoBrowerWithFetchResult:(PHFetchResult *)fetchResult;

@end
