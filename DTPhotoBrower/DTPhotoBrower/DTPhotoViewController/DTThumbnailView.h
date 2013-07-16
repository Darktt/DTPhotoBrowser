//
//  DTThumbnailView.h
//  togodrive
//
//  Created by Darktt on 13/7/11.
//  Copyright (c) 2013 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAssetType.h"

#define kTypeKey @"Type"
#define kThumbnailKey @"Thumbnail"
#define kDurationKey @"Duration"

@interface DTThumbnailView : UIImageView

@property (nonatomic, assign, getter = isChecked) BOOL checked;
@property (nonatomic, retain) NSDictionary *thumbnail;

@end
