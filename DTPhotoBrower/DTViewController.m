//
//  DTViewController.m
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTViewController.h"
#import "DTAlbumViewController.h"
#import "Categories.h"

@interface DTViewController ()

@end

@implementation DTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    
    NSLog(@"Screen Rect: %@", NSStringFromCGRect(screenRect));
    
    [self.button setCenter:CGPointMake(CGRectGetMidX(screenRect), CGRectGetMidY(screenRect))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openPhotoBrower:(id)sender
{
    DTAlbumViewController *photoViewController = [DTAlbumViewController albumViewWithPhotoMode:DTAlbumModeNormal];
//    DTAlbumViewController *photoViewController = [DTAlbumViewController albumViewWithPhotoMode:DTAlbumModeCopy];
    UINavigationController *navController = [UINavigationController navigationWithRootViewController:photoViewController];
    
    [self presentViewController:navController animated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
