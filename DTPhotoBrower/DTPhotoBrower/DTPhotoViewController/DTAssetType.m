//
//  DTAssetType.m
//  togodrive
//
//  Created by Darktt on 13/7/11.
//  Copyright (c) 2013 MAC. All rights reserved.
//

#import <AssetsLibrary/ALAsset.h>
#import "DTAssetType.h"

@interface DTAssetType ()
{
    NSMutableArray *_videoAssets;
    NSMutableArray *_photoAssets;
}

@end

@implementation DTAssetType

+ (id)defaultType
{
    DTAssetType *assetType = [[DTAssetType new] autorelease];
    
    return assetType;
}

- (void)filterAssetsWithAssets:(NSArray *)assets
{
    
    [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
        if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
            if (_videoAssets == nil) {
                _videoAssets = [[NSMutableArray alloc] initWithObjects:asset, nil];
                return;
            }
            
            [_videoAssets addObject:asset];
            return;
        }
        
        if (_photoAssets == nil) {
            _photoAssets = [[NSMutableArray alloc] initWithObjects:asset, nil];
            return;
        }
        
        [_photoAssets addObject:asset];
    }];
}

- (NSArray *)videoAssets
{
    return _videoAssets;
}

- (NSArray *)photoAssets
{
    return _photoAssets;
}

@end
