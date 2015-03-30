//
//  DTPhotoBrowerSetting.m
//  DTPhotoBrower
//
//  Created by Darktt on 2015/3/27.
//  Copyright (c) 2015 Darktt. All rights reserved.
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
