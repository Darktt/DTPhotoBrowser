//
//  DTPhotoBrowerSetting.h
//  DTPhotoBrower
//
//  Created by Darktt on 2015/3/27.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Photos;

@interface DTPhotoBrowerSetting : NSObject

// Titles
+ (NSString *)titleOfGroupList;
//+ (NSString *)titleOf;

+ (NSString *)cameraRollTitle;

// BarButtonItem Title
+ (NSString *)cancelBarButtonTitle;

// Button Titles
+ (NSString *)cancelTitle;

// Fetch options
+ (PHAssetMediaType)fetchMediaType;
+ (BOOL)includeAllBurstAssets;
+ (BOOL)includeHiddenAssets;

@end
