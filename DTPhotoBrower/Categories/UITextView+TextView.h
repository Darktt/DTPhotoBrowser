//
//  UITextView+TextView.h
//  KHBicycleRoadHelper
//
//  Created by Darktt on 13/6/2.
//  Copyright (c) 2013 Darktt Personal Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (TextView)

+ (id)textViewWithFrame:(CGRect)frame text:(NSString *)text;
+ (id)textViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)bgColor;

@end
