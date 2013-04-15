//
//  DTAlbumViewController.h
//  DTAlbumBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAlbumMode.h"

typedef enum {
    DTAlbumViewStyleTable = 1,
    DTAlbumViewStyleSplit
} DTAlbumViewStyle;

@interface DTAlbumViewController : UIViewController

+ (id)albumViewWithPhotoMode:(DTAlbumMode)mode;
+ (id)albumViewWithPhotoStyle:(DTAlbumViewStyle)style mode:(DTAlbumMode)mode;

@end
