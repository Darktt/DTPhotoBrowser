//
//  UIWebView+WebView.m
//
//  Created by Darktt on 16/1/13.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "UIWebView+WebView.h"

@implementation UIWebView (WebView)

+ (id)webViewWithFrame:(CGRect)frame URL:(NSURL *)url;
{
    UIWebView *webView = [[[UIWebView alloc] initWithFrame:frame] autorelease];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    return webView;
}

+ (id)webViewWithFrame:(CGRect)frame URL:(NSURL *)url Delegate:(id<UIWebViewDelegate>)delegate
{
    UIWebView *webView = [UIWebView webViewWithFrame:frame URL:url];
    [webView setDelegate:delegate];
    
    return webView;
}

@end
