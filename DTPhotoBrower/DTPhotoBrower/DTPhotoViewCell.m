//
//  DTPhotoViewCell.m
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTPhotoViewCell.h"
#import "Catagorys.h"

#define kBackgroundViewViewTag 99

#define kDefaultCellColor [UIColor clearColor]

#define kPhoto1Tag 1
#define kPhoto2Tag 2
#define kPhoto3Tag 3
#define kPhoto4Tag 4

#pragma mark - DTPhoto Methods

@interface DTPhoto : UIImageView {
    @private
    UIView *tapView;
}

@end

@implementation DTPhoto

- (id)init
{
    self = [super init];
    if (self == nil) return nil;
    
    tapView = [[UIView alloc] initWithFrame:self.frame];
    [tapView setAlpha:0.5f];
    [tapView setBackgroundColor:[UIColor blackColor]];
    [tapView setHidden:YES];
    
    [self addSubview:tapView];
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [tapView setFrame:self.bounds];
}

- (void)dealloc
{
    [tapView release];
    
    [super dealloc];
}

#pragma mark - Touches Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (event.type != UIEventTypeTouches) return;
    
    [tapView setHidden:NO];
    [self bringSubviewToFront:tapView];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (event.type != UIEventTypeTouches) return;
    
    [tapView setHidden:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (event.type != UIEventTypeTouches) return;
    
    [tapView setHidden:YES];
}

@end

#pragma mark - DTPhotoViewCell Methods

@interface DTPhotoViewCell ()
{
    NSArray *_photos;
    
    NSArray *imageViews;
}

@end

@implementation DTPhotoViewCell

+ (id)photoViewCellWithPhotos:(NSArray *)photos reuseIdentifier:(NSString *)reuseIdentifier
{
    DTPhotoViewCell *cell = [[[DTPhotoViewCell alloc] initWithPhotos:photos reuseIdentifier:reuseIdentifier] autorelease];
    
    return cell;
}

+ (id)photoViewCellWithPhotosForCopyMode:(NSArray *)photos reuseIdentifier:(NSString *)reuseIdentifier
{
    DTPhotoViewCell *cell = [[[DTPhotoViewCell alloc] initWithPhotosForCopyMode:photos reuseIdentifier:reuseIdentifier] autorelease];
    
    return cell;
}

- (id)initWithPhotos:(NSArray *)photos reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self == nil) return nil;
    
    _photos = [photos retain];
    
    return self;
}

- (id)initWithPhotosForCopyMode:(NSArray *)photos reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self == nil) return nil;
    
    _photos = [photos retain];
    
    return self;
}

- (void)layoutSubviews
{
    [self loadCellView];
}

- (void)dealloc
{
    [_photos release];
    [imageViews release];
    [super dealloc];
}

#pragma mark - Set Views

- (void)setDefaultViewForCopyMode:(BOOL)copyMode
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [backgroundView setBackgroundColor:kDefaultCellColor];
    [backgroundView setTag:kBackgroundViewViewTag];
    [backgroundView setOpaque:YES];
    
    [self setBackgroundView:backgroundView];
    
    [self.textLabel setBackgroundColor:kDefaultCellColor];
    
    NSMutableArray *_imageViews = [NSMutableArray array];
    
    SEL tapGestureMethod = @selector(tapPhotoOfGesture:);
    
    for (NSInteger i = 1; i <= 4; i++) {
        DTPhoto *imageView = [DTPhoto new];
        [imageView setUserInteractionEnabled:YES];
        [imageView setTag:i];
        
        if (!copyMode) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:tapGestureMethod];
            
            [imageView setGestureRecognizers:@[tapGesture]];
            [tapGesture release];
        }
        
        [self addSubview:imageView];
        
        [_imageViews addObject:imageView];
        [imageView release];
    }
    
    imageViews = [_imageViews retain];
}

- (void)loadCellView
{
    CGSize cellSize = self.frame.size;
    
    CGRect imageFrame = CGRectMake(0, 3, kCellHeight - 6, kCellHeight - 6);
    
    // ( CellWidth - (imageViewWidth * imageViewCount) - FrameBorderWidth ) / ( imageViewCount + oneSideBorder )
    CGFloat space = ( cellSize.width - (imageFrame.size.width * imageViews.count) - 6 ) / ( imageViews.count + 1 );
    imageFrame.origin.x = space;
    
    for (UIImageView *imageView in imageViews) {
        NSUInteger index = [imageViews indexOfObject:imageView];
        
        if (index < _photos.count) {
            [imageView setImage:_photos[index]];
        } else {
            [imageView setImage:nil];
        }
        
        [imageView setFrame:imageFrame];
        
        imageFrame.origin.x += (imageFrame.size.width + space);
    }
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

- (void)setPhotos:(NSArray *)photos
{
    [_photos release];
    _photos = [photos retain];
}

- (NSArray *)photos
{
    return _photos;
}

#pragma mark - Gesture Method

- (IBAction)tapPhotoOfGesture:(UITapGestureRecognizer *)sender
{
    UIGestureRecognizerState state = sender.state;
    
    if (state == UIGestureRecognizerStateFailed || state != UIGestureRecognizerStateRecognized) {
        return;
    }
    
    UIImageView *photo = (UIImageView *)[sender view];
    UIImage *tapImage = [photo image];
    
    [self.delegate photoViewCell:self tapPhotoForImage:tapImage];
}

@end
