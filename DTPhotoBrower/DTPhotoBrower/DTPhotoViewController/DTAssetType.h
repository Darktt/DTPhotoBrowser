//
//  DTAssetType.h
//
//  Created by Darktt on 13/7/11.
//  Copyright (c) 2013 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    AssetTypePhoto = 0,
    AssetTypeVideo
};
typedef NSInteger AssetType;

@interface DTAssetType : NSObject

@property (assign) AssetType type;
@property (readonly) NSArray *videoAssets;
@property (readonly) NSArray *photoAssets;

+ (id)defaultType;
- (void)filterAssetsWithAssets:(NSArray *)assets;

@end
