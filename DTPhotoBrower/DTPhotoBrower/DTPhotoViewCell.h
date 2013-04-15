//
//  DTPhotoViewCell.h
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAlbumMode.h"

#define kCellForPhotoCount 4

#ifdef UI_USER_INTERFACE_IDIOM

#define IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#else

#define IPHONE false

#endif

#define kCellHeight ( IPHONE ? 79.0f : 186.0f )

@class DTPhotoViewCell;

@protocol DTPhotoViewCellDelegate <NSObject>

- (void)photoViewCell:(DTPhotoViewCell *)photoViewCell tapPhotoForImage:(UIImage *)image;

@end

@interface DTPhotoViewCell : UITableViewCell

@property (nonatomic, retain) NSArray *photos;
@property (assign) id<DTPhotoViewCellDelegate> delegate;

+ (id)photoViewCellWithPhotos:(NSArray *)photos reuseIdentifier:(NSString *)reuseIdentifier;
+ (id)photoViewCellWithPhotosForCopyMode:(NSArray *)photos reuseIdentifier:(NSString *)reuseIdentifier;

@end
