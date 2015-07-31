//
//  DTPhotoBrowserController.h
//  DTPhotoBrowser
//
//  Created by Darktt on 2015/3/30.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHFetchResult;

@interface DTPhotoBrowserController : UIViewController

// An array contains ALAsset.
+ (instancetype)photoBrowerWithAssets:(NSArray *)assets;

// A PHFetchResult contains PHAsset
+ (instancetype)photoBrowerWithPHAssets:(PHFetchResult *)assets;

@end
