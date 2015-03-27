//
//  DTPhotoBrowerSetting.m
//  DTPhotoBrower
//
//  Created by EdenLi on 2015/3/27.
//  Copyright (c) 2015年 Darktt. All rights reserved.
//

#import "DTPhotoBrowerSetting.h"

@implementation DTPhotoBrowerSetting

+ (NSString *)titleOfGroupList
{
    return NSLocalizedString(@"Groups", @"");
}

+ (NSString *)cameraRollTitle
{
    return NSLocalizedString(@"Camera Roll", @"");
}

+ (PHAssetMediaType)fetchMediaType
{
    return PHAssetMediaTypeImage;
}

+ (BOOL)includeAllBurstAssets
{
    return YES;
}

+ (BOOL)includeHiddenAssets
{
    return YES;
}

@end
