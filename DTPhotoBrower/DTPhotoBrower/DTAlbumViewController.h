//
//  DTAlbumViewController.h
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DTPhotoViewStyleTable = 1,
    DTPhotoViewStyleSplit
} DTPhotoViewStyle;

typedef enum {
    DTPhotoViewNormalMode = 1,
    DTPhotoViewCopyMode
} DTPhotoViewMode;

@interface DTAlbumViewController : UIViewController

+ (id)photoViewWithPhotoMode:(DTPhotoViewMode)mode;
+ (id)photoViewWithPhotoStyle:(DTPhotoViewStyle)style mode:(DTPhotoViewMode)mode;

@end
