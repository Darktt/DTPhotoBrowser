//
//  DTViewController.m
//  DTPhotoBrower
//
//  Created by Darktt on 2015/3/27.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import "DTViewController.h"

#import "DTGroupListViewController.h"

@interface DTViewController () <DTGroupListViewControllerDelegate>

- (IBAction)openAlbum:(id)sender;

@end

@implementation DTViewController

+ (instancetype)viewController
{
    DTViewController *__autoreleasing viewController = [DTViewController new];
    
    return viewController;
}

#pragma mark Instance Method -
#pragma mark View Live Cycle

- (instancetype)init
{
    self = [super initWithNibName:@"DTViewController" bundle:nil];
    if (self == nil) return nil;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)openAlbum:(id)sender
{
    DTGroupListViewController *groupList = [DTGroupListViewController groupListWithTarget:self];
    
    UINavigationController *__autoreleasing navigation = [[UINavigationController alloc] initWithRootViewController:groupList];
    
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - DTGroupListViewController Delegate

- (void)groupListDidDismiss:(DTGroupListViewController *)groupList
{
    [groupList dismissViewControllerAnimated:YES completion:nil];
}

@end
