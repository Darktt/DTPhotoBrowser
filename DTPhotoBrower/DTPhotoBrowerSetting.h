//
//  DTPhotoBrowerSetting.h
//  DTPhotoBrower
//
//  Created by EdenLi on 2015/3/27.
//  Copyright (c) 2015年 Darktt. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Photos;

@interface DTPhotoBrowerSetting : NSObject

// Titles
+ (NSString *)titleOfGroupList;
+ (NSString *)titleOf;

+ (NSString *)cameraRollTitle;

// Fetch options
+ (PHAssetMediaType)fetchMediaType;
+ (BOOL)includeAllBurstAssets;
+ (BOOL)includeHiddenAssets;

@end
