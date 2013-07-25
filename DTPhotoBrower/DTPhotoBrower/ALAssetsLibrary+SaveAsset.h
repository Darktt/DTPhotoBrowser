//
//  ALAssetsLibrary+SaveAsset.h
//  DTTest
//
//  Created by Darktt on 13/7/24.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <AssetsLibrary/ALAssetsLibrary.h>

typedef void (^ALAssetsLibrarySaveCompletionBlock) (NSError *);

@interface ALAssetsLibrary (SaveAsset)

- (void)saveImageToAlbumWithImage:(UIImage *)image album:(NSString *)albumName completionBlock:(ALAssetsLibrarySaveCompletionBlock)completionBlock;
- (void)addAssetToAlbumWithAssetURL:(NSURL *)assetURL album:(NSString *)albumName completionBlock:(ALAssetsLibrarySaveCompletionBlock)completionBlock;

@end
