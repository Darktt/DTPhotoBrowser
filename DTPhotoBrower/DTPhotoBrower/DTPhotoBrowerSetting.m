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
    return NSLocalizedString(@"Photos", @"");
}

+ (NSString *)cameraRollTitle
{
    return NSLocalizedString(@"Camera Roll", @"");
}

+ (NSString *)cancelBarButtonTitle
{
    return NSLocalizedString(@"Cancel", @"");
}

+ (NSString *)cancelTitle
{
    return NSLocalizedString(@"Cancel", @"");
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
