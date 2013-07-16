//
//  UIScrollView+ScrollView.m
//
//  Created by Darktt on 13/5/4.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "UIScrollView+ScrollView.h"

@implementation UIScrollView (ScrollView)

+ (id)scrollWithFrame:(CGRect)frame
{
    UIScrollView *scroll = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
    
    return scroll;
}

+ (id)scrollPagingWithFrame:(CGRect)frame
{
    UIScrollView *scroll = [self scrollWithFrame:frame];
    [scroll setPagingEnabled:YES];
    
    return scroll;
}
@end
