//
//  DTThumbnailView.m
//  togodrive
//
//  Created by Darktt on 13/7/11.
//  Copyright (c) 2013 MAC. All rights reserved.
//

#import "DTThumbnailView.h"

#define kDurationTag 1000

@interface DTThumbnailView ()
{
    UIView *videoInfoView;
    UIView *tapView;
    UIImageView *checkedView;
    
    NSDictionary *_thumbnail;
}

@end

@implementation DTThumbnailView

- (id)init
{
    self = [super init];
    if (self == nil) return nil;
    
    videoInfoView = [UIView new];
    [videoInfoView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7f]];
    [videoInfoView setHidden:YES];
    
    UILabel *durationLabel = [UILabel new];
    [durationLabel setBackgroundColor:[UIColor clearColor]];
    [durationLabel setTextColor:[UIColor whiteColor]];
    [durationLabel setTextAlignment:NSTextAlignmentRight];
    [durationLabel setFont:[UIFont systemFontOfSize:10.0f]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [durationLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    
    [durationLabel setTag:kDurationTag];
    
    [videoInfoView addSubview:durationLabel];
    [durationLabel release];
    
    tapView = [[UIView alloc] initWithFrame:self.bounds];
    [tapView setBackgroundColor:[UIColor colorWithWhite:0 alpha:1.0f]];
    [tapView setAlpha:0.5f];
    [tapView setHidden:YES];
    
    UIImage *checkedImage = [[UIImage imageNamed:@"CheckMark.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 50, 50)];
    checkedView = [[UIImageView alloc] initWithImage:checkedImage];;
    [checkedView setFrame:self.bounds];
    [checkedView setHidden:YES];
    
    [self addSubview:videoInfoView];
    [self addSubview:tapView];
    [self addSubview:checkedView];
    
    [tapView release];
    [checkedView release];
    [videoInfoView release];
    
    return self;
}

- (void)dealloc
{
//    [checkedView release];
    
    if (_thumbnail != nil) {
        [_thumbnail release];
    }
    
    [super dealloc];
}

#pragma mark - Overwrite Method

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [tapView setFrame:self.bounds];
    [checkedView setFrame:self.bounds];
    
    CGRect videoInfoFrame = CGRectZero;
    videoInfoFrame.origin.y = self.frame.size.height - ( self.frame.size.height / 5.0f );
    videoInfoFrame.size.width = self.frame.size.width;
    videoInfoFrame.size.height = self.frame.size.height / 5.0f;
    
    [videoInfoView setFrame:videoInfoFrame];
    
    CGRect labelFrame = videoInfoView.bounds;
    labelFrame.size.width -= 2.0f;
    
    UILabel *durationLabel = (UILabel *)[videoInfoView viewWithTag:kDurationTag];
    [durationLabel setFrame:labelFrame];
}

- (void)setThumbnail:(NSDictionary *)thumbnail
{
    if (thumbnail == nil) {
        [_thumbnail release];
        _thumbnail = thumbnail;
        [self setImage:nil];
        
        return;
    }
    
    if ([_thumbnail isEqualToDictionary:thumbnail]) {
        return;
    }
    
    if (_thumbnail != nil) {
        [_thumbnail release];
    }
    _thumbnail = [thumbnail retain];
    
    [videoInfoView setHidden:YES];
    
    DTAssetType *assetType = _thumbnail[kTypeKey];
    if (assetType.type == AssetTypeVideo) {
        [videoInfoView setHidden:NO];
        NSNumber *duration = _thumbnail[kDurationKey];
        NSDate *durationDate = [NSDate dateWithTimeIntervalSince1970:[duration floatValue]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter setDateFormat:@"HH:mm:ss"];
        
        NSString *durationString = [formatter stringFromDate:durationDate];
        
        UILabel *durationLabel = (UILabel *)[videoInfoView viewWithTag:kDurationTag];
        [durationLabel setText:durationString];
        
        [formatter release];
    }
    
    [self setImage:_thumbnail[kThumbnailKey]];
}

- (NSDictionary *)thumbnail
{
    return _thumbnail;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [tapView setHidden:!highlighted];
}

- (BOOL)isHighlighted
{
    return !tapView.hidden;
}

- (void)setChecked:(BOOL)checked
{
    [checkedView setHidden:!checked];
}

- (BOOL)isChecked
{
    return !checkedView.hidden;
}

#pragma mark - Touches Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (event.type != UIEventTypeTouches) return;
    
    if (tapView.hidden)
        [tapView setHidden:NO];
    
    [self bringSubviewToFront:tapView];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if (event.type != UIEventTypeTouches) return;
    
    [tapView setHidden:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (event.type != UIEventTypeTouches) return;
    
    [tapView setHidden:YES];
}

@end