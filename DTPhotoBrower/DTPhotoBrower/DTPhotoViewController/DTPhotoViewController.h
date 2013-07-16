//
//  DTPhotoViewController.h
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

///////////////////////////////////////////////////
/*
    Asset Array Pattern
 
    Photo (Dictionary) : {
        Type        :   DTPhotoTypePhoto
        Thumbnail   :   (UIImage) image data
    }
    
    Vedio (Dictionary) : {
        Type        :   DTPhotoTypeVedio
        Thumbnail   :   (UIImage) image data
        Duration    :   (NSNumber) video duration
    }
 
*/
///////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "DTAlbumMode.h"

@class ALAssetsGroup;

@interface DTPhotoViewController : UIViewController

@property (nonatomic, retain) NSArray *selectedFiles;

+ (id)photoViewWithAssetsGroup:(ALAssetsGroup *)group mode:(DTAlbumMode)mode;
//+ (id)photoViewWithAssetsGroup:(ALAssetsGroup *)group mode:(DTAlbumMode)mode source:(FileSource)source;

@end
