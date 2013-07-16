//
//  UIAlertView+AlertViewWithProgress.h
//  togodrive
//
//  Created by Darktt on 13/6/3.
//  Copyright (c) 2013 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (AlertViewWithProgress)

+ (id)progressAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;

@property (nonatomic, readonly) UIProgressView *progressView;

@end
