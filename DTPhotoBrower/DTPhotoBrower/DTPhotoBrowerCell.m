//
//  DTPhotoBrowerCell.m
//  DTPhotoBrower
//
//  Created by Darktt on 2015/3/30.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import "DTPhotoBrowerCell.h"

@interface DTPhotoBrowerCell ()
{
    UIImageView *_imageView;
}

@end

@implementation DTPhotoBrowerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    [self.contentView addSubview:_imageView];
    
    return self;
}

- (void)dealloc
{
    [_imageView release];
    
    [super dealloc];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.imageView setImage:nil];
}

- (UIImageView *)imageView
{
    return _imageView;
}

@end
