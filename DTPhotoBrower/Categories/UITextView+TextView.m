//
//  UITextView+TextView.m
//  KHBicycleRoadHelper
//
//  Created by Darktt on 13/6/2.
//  Copyright (c) 2013 Darktt Personal Company. All rights reserved.
//

#import "UITextView+TextView.h"

@implementation UITextView (TextView)

+ (id)textViewWithFrame:(CGRect)frame text:(NSString *)text
{
    UITextView *textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
    [textView setText:text];
    
    return textView;
}

+ (id)textViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)bgColor
{
    UITextView *textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
    [textView setBackgroundColor:bgColor];
    
    return textView;
}

@end
