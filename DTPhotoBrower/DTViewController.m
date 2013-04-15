//
//  DTViewController.m
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTViewController.h"
#import "DTAlbumViewController.h"
#import "Catagorys.h"

@interface DTViewController ()

@end

@implementation DTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openPhotoBrower:(id)sender
{
    DTAlbumViewController *photoViewController = [DTAlbumViewController albumViewWithPhotoMode:DTAlbumModeCopy];
    UINavigationController *navController = [UINavigationController navigationWithRootViewController:photoViewController];
    
    [self presentViewController:navController animated:YES completion:nil];
}

@end
