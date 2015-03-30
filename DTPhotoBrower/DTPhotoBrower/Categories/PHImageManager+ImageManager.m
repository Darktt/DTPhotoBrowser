//
//  PHImageManager+ImageManager.m
//  DTPhotoBrower
//
//  Created by Darktt on 2015/3/30.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import "PHImageManager+ImageManager.h"

@implementation PHImageManager (ImageManager)

- (void)thumbnailImageWithAsset:(PHAsset *)asset imageSize:(CGSize)size result:(PHImageManagerFetchImageResult)resultHandler
{
    PHImageContentMode contentMode = PHImageContentModeAspectFill;
    
    CGFloat minimumSide = MIN(asset.pixelWidth, asset.pixelHeight);
    CGRect square = CGRectMake(0, 0, minimumSide, minimumSide);
    
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    [requestOptions setSynchronous:YES];
    [requestOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    [requestOptions setResizeMode:PHImageRequestOptionsResizeModeExact];
    [requestOptions setNormalizedCropRect:square];
    
    void (^_resultHandler) (UIImage *, NSDictionary *) = ^(UIImage *result, NSDictionary *info) {
        NSError *error = info[PHImageErrorKey];
        
        if (error != nil) {
            NSLog(@"Request image error: %@", error);
        }
        
        if (resultHandler != nil) resultHandler(result);
    };
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset targetSize:size contentMode:contentMode options:requestOptions resultHandler:_resultHandler];
    [requestOptions release];
}

@end