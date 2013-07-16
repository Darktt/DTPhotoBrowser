//
//  DTPhotoViewCell.m
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTPhotoViewCell.h"

#define kBackgroundViewViewTag 99

#define kDefaultCellColor   [UIColor clearColor]
#define kBlackCellColor     [UIColor blackColor]

@interface DTPhotoViewCell ()
{
    NSArray *_thumbnails;
    NSArray *imageViews;
}

@end

@implementation DTPhotoViewCell

+ (id)photoViewCellWithThumbnails:(NSArray *)thumbnails reuseIdentifier:(NSString *)reuseIdentifier
{
    DTPhotoViewCell *cell = [[[DTPhotoViewCell alloc] initWithThumbnails:thumbnails reuseIdentifier:reuseIdentifier] autorelease];
    
    return cell;
}

+ (id)photoViewCellWithThumbnailsForCopyMode:(NSArray *)thumbnails reuseIdentifier:(NSString *)reuseIdentifier
{
    DTPhotoViewCell *cell = [[[DTPhotoViewCell alloc] initWithThumbnailsForCopyMode:thumbnails reuseIdentifier:reuseIdentifier] autorelease];
    
    return cell;
}

- (id)initWithThumbnails:(NSArray *)thumbnails reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self == nil) return nil;
    
    _thumbnails = [thumbnails retain];
    
    [self setDefaultViewForCopyMode:NO];
    
    return self;
}

- (id)initWithThumbnailsForCopyMode:(NSArray *)thumbnails reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self == nil) return nil;
    
    _thumbnails = [thumbnails retain];
    
    [self setDefaultViewForCopyMode:YES];
    
    return self;
}

- (void)layoutSubviews
{
    [self loadCellView];
}

- (void)dealloc
{
    [_thumbnails release];
    [imageViews release];
    [super dealloc];
}

#pragma mark - Set Views

- (void)setDefaultViewForCopyMode:(BOOL)copyMode
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [backgroundView setBackgroundColor:kBlackCellColor];
    [backgroundView setTag:kBackgroundViewViewTag];
    [backgroundView setOpaque:YES];
    
    [self setBackgroundView:backgroundView];
    [backgroundView release];
    
    [self.textLabel setBackgroundColor:kDefaultCellColor];
    
    NSMutableArray *_imageViews = [NSMutableArray array];
    
    SEL tapGestureMethod = @selector(tapPhotoOfGesture:);
    
    DTThumbnailView *thumbnail = nil;
    
    for (NSInteger i = 1; i <= 4; i++) {
        if (!copyMode) {
            thumbnail = [DTThumbnailView new];
            [thumbnail setUserInteractionEnabled:YES];
            [thumbnail setTag:i];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:tapGestureMethod];
            [tapGesture setNumberOfTapsRequired:1];
            
            [thumbnail setGestureRecognizers:@[tapGesture]];
            [tapGesture release];
        } else {
            thumbnail = [DTThumbnailView new];
        }
        
        [self addSubview:thumbnail];
        
        [_imageViews addObject:thumbnail];
        [thumbnail release];
    }
    
    imageViews = [_imageViews retain];
}

- (void)loadCellView
{
    CGSize cellSize = self.frame.size;
    
    CGRect imageFrame = CGRectMake(0, 3, kCellHeight - 6, kCellHeight - 6);
    
    // ( CellWidth - (ImageViewWidth * ImageViewCount) - FrameBorderWidth ) / ( ImageViewCount + OneSideBorder )
    CGFloat space = ( cellSize.width - (imageFrame.size.width * imageViews.count) - 6 ) / ( imageViews.count + 1 );
    imageFrame.origin.x = space;
    
    for (DTThumbnailView *thumbnail in imageViews) {
        NSUInteger index = [imageViews indexOfObject:thumbnail];
        
        NSLog(@"%@", [thumbnail class]);
        
        if (index < _thumbnails.count) {
            [thumbnail setThumbnail:_thumbnails[index]];
            
        } else {
            [thumbnail setThumbnail:nil];
            
            if (self.delegate != nil) {
                [thumbnail setChecked:NO];
            }
        }
        
        [thumbnail setFrame:imageFrame];
        
        imageFrame.origin.x += (imageFrame.size.width + space);
    }
}

- (void)setCheckMark:(BOOL)checked photoIndex:(NSUInteger)index
{
    DTThumbnailView *thumbnail = (DTThumbnailView *)imageViews[index];
    
    [thumbnail setChecked:checked];
}

#pragma mark - Overwrite Methods

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    UIView *backgroundViewView = [self viewWithTag:kBackgroundViewViewTag];
    
    [backgroundViewView setBackgroundColor:backgroundColor];
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    [super setAccessoryType:UITableViewCellAccessoryNone];
}

- (void)setThumbnails:(NSArray *)thumbnails
{
    [_thumbnails release];
    _thumbnails = [thumbnails retain];
}

- (NSArray *)thumbnails
{
    return _thumbnails;
}

#pragma mark - Gesture Method

- (IBAction)tapPhotoOfGesture:(UITapGestureRecognizer *)sender
{
    UIGestureRecognizerState state = sender.state;
    
    if (state == UIGestureRecognizerStateFailed || state != UIGestureRecognizerStateRecognized) {
        return;
    }
    
    DTThumbnailView *thumbnailView = (DTThumbnailView *)[sender view];
    
    [thumbnailView setHighlighted:YES];
    
    [self performSelector:@selector(unHighlightThumbnail:) withObject:thumbnailView afterDelay:0.2f];
    
    NSDictionary *thumbnail = [thumbnailView thumbnail];
    
    [self.delegate photoViewCell:self tapedPhotoForThumbnail:thumbnail];
}

- (void)unHighlightThumbnail:(UIImageView *)thumbnail
{
    [thumbnail setHighlighted:NO];
}

@end
