//
//  UIAlertView+AlertViewWithProgress.m
//  togodrive
//
//  Created by Darktt on 13/6/3.
//  Copyright (c) 2013 MAC. All rights reserved.
//

#import "UIAlertView+AlertViewWithProgress.h"

#define kAlertViewProgressTag  99
#define kAlertCancel    NSLocalizedString(@"Cancel", @"AlertView_Cancel_Button")

@implementation UIAlertView (AlertViewWithProgress)

+ (id)progressAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:title message:@"" delegate:delegate cancelButtonTitle:kAlertCancel otherButtonTitles:nil] autorelease];
    
    NSString *newMessage = [[NSString stringWithString:message] stringByAppendingFormat:@"\n\n\n"];
    [alertView setMessage:newMessage];
     
    CGRect progressFrame = CGRectZero;
    progressFrame.size = CGSizeMake(200.0f, 10.0f);
    progressFrame.origin.x = alertView.center.x + 45.0f;
    progressFrame.origin.y = 70.0f;
    
    UIProgressView *progerss = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [progerss setFrame:progressFrame];
    [progerss setTag:kAlertViewProgressTag];
    
    [alertView addSubview:progerss];
    [progerss release];
    
    return alertView;
}

#pragma mark - Override Property Method

- (UIProgressView *)progressView
{
    UIProgressView *progressView = (UIProgressView *)[self viewWithTag:kAlertViewProgressTag];
    
    return progressView;
}

@end
