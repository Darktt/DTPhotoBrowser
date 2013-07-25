//
//  ALAssetsLibrary+SaveAsset.m
//  DTTest
//
//  Created by Darktt on 13/7/24.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <AssetsLibrary/ALAssetsGroup.h>
#import "ALAssetsLibrary+SaveAsset.h"

@implementation ALAssetsLibrary (SaveAsset)

- (void)saveImageToAlbumWithImage:(UIImage *)image album:(NSString *)albumName completionBlock:(ALAssetsLibrarySaveCompletionBlock)completionBlock
{
    ALAssetsLibraryWriteImageCompletionBlock _completionBlock = ^(NSURL *assetURL, NSError *error){
        if (error != nil) {
            completionBlock(error);
            return;
        }
        
        [self addAssetToAlbumWithAssetURL:assetURL album:albumName completionBlock:completionBlock];
    };
    
    [self writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:_completionBlock];
}

- (void)addAssetToAlbumWithAssetURL:(NSURL *)assetURL album:(NSString *)albumName completionBlock:(ALAssetsLibrarySaveCompletionBlock)completionBlock
{
    __block BOOL albumFound = NO;
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group == nil && !albumFound) {
            NSError *error = [NSError errorWithDomain:@"Album Not Found!!" code:ALAssetsLibraryWriteFailedError userInfo:nil];
            
            completionBlock(error);
        }
        
        ALAssetsGroupType groupType = [[group valueForProperty:ALAssetsGroupPropertyType] integerValue];
        if (groupType == ALAssetsGroupSavedPhotos) {
            albumFound = YES;
            
            completionBlock(nil);
            return;
        }
        
        NSString *groupAlbumName = [group valueForProperty:ALAssetsGroupPropertyName];
        
        if ([albumName compare:groupAlbumName] != NSOrderedSame) {
            return;
        }
        
        ALAssetsLibraryAssetForURLResultBlock result = ^(ALAsset *asset){
            albumFound = YES;
            [group addAsset:asset];
        };
        
        [self assetForURL:assetURL resultBlock:result failureBlock:completionBlock];
    };
    
    ALAssetsGroupType groupType = ALAssetsGroupAlbum | ALAssetsGroupSavedPhotos;
    [self enumerateGroupsWithTypes:groupType usingBlock:resultBlock failureBlock:completionBlock];
}

@end
