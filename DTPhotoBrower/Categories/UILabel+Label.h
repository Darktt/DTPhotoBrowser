//
//  UILabel+Label.h
//
//  Created by Darktt on 13/4/23.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Label)

+ (id)labelWithFrame:(CGRect)frame;
+ (id)labelWithFrame:(CGRect)frame text:(NSString *)text;

- (void)alignTop;
- (void)alignBottom;

@end
