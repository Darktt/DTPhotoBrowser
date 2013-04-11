//
//  DTPhotoViewController.m
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "DTPhotoViewController.h"

@interface DTPhotoViewController ()

@end

@implementation DTPhotoViewController

+ (id)photoViewWithAssetsGroup:(ALAssetsGroup *)group mode:(DTAlbumMode)mode
{
    DTPhotoViewController *photoViewController = [[[DTPhotoViewController alloc] initWithAssetsGroup:group mode:mode] autorelease];
    
    return photoViewController;
}

- (id)initWithAssetsGroup:(ALAssetsGroup *)group mode:(DTAlbumMode)mode
{
    self = [super initWithNibName:@"DTPhotoViewController" bundle:nil];
    
    if (self == nil) return nil;
    
    NSLog(@"%@", [group valueForProperty:ALAssetsGroupPropertyName]);
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
