//
//  PHImageManager+ImageManager.h
//  DTPhotoBrower
//
//  Created by Darktt on 2015/3/30.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import <Photos/Photos.h>

typedef void (^PHImageManagerFetchImageResult) (UIImage *image);

@interface PHImageManager (ImageManager)

- (void)thumbnailImageWithAsset:(PHAsset *)asset imageSize:(CGSize)size result:(PHImageManagerFetchImageResult)result;

@end
