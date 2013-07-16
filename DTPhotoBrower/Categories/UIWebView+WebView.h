//
//  UIWebView+WebView.h
//
//  Created by Darktt on 16/1/13.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (WebView)

+ (id)webViewWithFrame:(CGRect)frame URL:(NSURL *)url;
+ (id)webViewWithFrame:(CGRect)frame URL:(NSURL *)url Delegate:(id<UIWebViewDelegate>)delegate;

@end