//
//  DTPhotoViewController.h
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAblumMode.h"

@class ALAssetsGroup;

@interface DTPhotoViewController : UIViewController

+ (id)photoViewWithAssetsGroup:(ALAssetsGroup *)group mode:(DTAlbumMode)mode;

@end
