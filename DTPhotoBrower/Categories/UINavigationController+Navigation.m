//
//  UINavigationController+Navigation.m
//
//  Created by Darktt on 16/1/13.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "UINavigationController+Navigation.h"

@implementation UINavigationController (Navigation)

+ (id)navigationWithRootViewController:(UIViewController *)rootViewController
{
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
    
    return nav;
}

#pragma mark - Autorotate Methods

- (NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
    
    return YES;
}

@end
