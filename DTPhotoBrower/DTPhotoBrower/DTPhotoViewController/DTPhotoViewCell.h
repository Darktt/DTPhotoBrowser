//
//  DTPhotoViewCell.h
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAlbumMode.h"
#import "DTThumbnailView.h"

#define kCellForPhotoCount 4

#ifdef UI_USER_INTERFACE_IDIOM

#define IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#else

#define IPHONE false

#endif

#define kCellHeight ( IPHONE ? 79.0f : 186.0f )

@class DTPhotoViewCell;

@protocol DTPhotoViewCellDelegate <NSObject>

//- (void)photoViewCell:(DTPhotoViewCell *)photoViewCell tapedPhotoForImage:(UIImage *)image;
- (void)photoViewCell:(DTPhotoViewCell *)photoViewCell tapedPhotoForThumbnail:(NSDictionary *)thumbnail;

@end

@interface DTPhotoViewCell : UITableViewCell

@property (nonatomic, retain) NSArray *thumbnails;
@property (assign) id<DTPhotoViewCellDelegate> delegate;

+ (id)photoViewCellWithThumbnails:(NSArray *)thumbnails reuseIdentifier:(NSString *)reuseIdentifier;
+ (id)photoViewCellWithThumbnailsForCopyMode:(NSArray *)thumbnails reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setCheckMark:(BOOL)checked photoIndex:(NSUInteger)index;

@end
