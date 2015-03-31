//
//  DTPhotoPreviewController.m
//  DTPhotoBrower
//
//  Created by Darktt on 2015/3/31.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import "DTPhotoPreviewController.h"

#import "DTPhotoBrowerSetting.h"

@interface DTPhotoPreviewController ()
{
    UIImage *_previewImage;
    UIImageView *_previewView;
    
    UIView *_snapshotView;
    NSString *_previousViewTitle;
    CGRect _appearRect;
}

@end

@implementation DTPhotoPreviewController

+ (instancetype)photoPreviewWithPhoto:(UIImage *)previewImage
{
    DTPhotoPreviewController *photoPreview = [[DTPhotoPreviewController alloc] initWithPhoto:previewImage];
    
    return [photoPreview autorelease];
}

#pragma mark Instance Method -
#pragma mark View Live Cycle

- (instancetype)initWithPhoto:(UIImage *)previewImage
{
    self = [super init];
    if (self == nil) return nil;
    
    _previewImage = [previewImage retain];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_snapshotView.hidden) {
        [super viewDidAppear:animated];
        return;
    }
    
    [self pushAnimationHandleWithCompletion:^{
        [super viewDidAppear:animated];
    }];
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
    
    NSAssert(_snapshotView != nil, @"Must push view with -pushFromViewController:appearRect:");
    
    [self setupBackButtonItem];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewHandle:)];
    [tapGesture setNumberOfTapsRequired:1];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    _previewView = [[UIImageView alloc] initWithImage:_previewImage];
    [_previewView setFrame:screenRect];
    [_previewView setContentMode:UIViewContentModeScaleAspectFit];
    [_previewView setBackgroundColor:[UIColor clearColor]];
    [_previewView addGestureRecognizer:tapGesture];
    [_previewView setUserInteractionEnabled:YES];
    [_previewView setHidden:YES];
    
    [self.view addSubview:_snapshotView];
    [self.view addSubview:_previewView];
    
    [self setupAutoresizingMaskWithView:_snapshotView];
    [self setupAutoresizingMaskWithView:_previewView];
}

- (void)dealloc
{
    [_previewImage release];
    [_previewView release];
    
    [_snapshotView release];
    [_previousViewTitle release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

- (BOOL)prefersStatusBarHidden
{
    BOOL hidden = self.navigationController.navigationBarHidden;
    
    return hidden;
}

#pragma mark - UI Setup

- (CGRect)imageViewRectToFitScreen
{
    CGSize imageSize = _previewImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat ratio = height / width;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGFloat imageViewHeight = CGRectGetWidth(screenRect) * ratio;
    
    CGRect imageViewRect = (CGRect) {
        .origin = (CGPoint) {
            .y = (CGRectGetMaxY(screenRect) - imageViewHeight) / 2.0f
        },
        .size = (CGSize) {
            .width = CGRectGetWidth(screenRect),
            .height = imageViewHeight
        }
    };
    
    return imageViewRect;
}

- (UIImageView *)imageViewForTransitionAnimationWithPush:(BOOL)flag
{
    CGRect imageViewRect = (flag) ? _appearRect : [self imageViewRectToFitScreen];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_previewImage];
    [imageView setFrame:imageViewRect];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    
    return [imageView autorelease];
}

- (UIImage *)backIndicatorImage
{
    return nil;
}

- (void)setupBackButtonItem
{
    UIFont *buttonFont = [UIFont systemFontOfSize:16.0f];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:_previousViewTitle forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popHandle:) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    
    [backButton.titleLabel setFont:buttonFont];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.navigationItem setLeftBarButtonItem:backItem];
    [backItem release];
}

- (void)setupAutoresizingMaskWithView:(UIView *)view
{
    UIViewAutoresizing autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [view setAutoresizingMask:autoresizingMask];
    [view setAutoresizesSubviews:YES];
}

#pragma mark - Push Handle

- (UIView *)snapshotFromViewController:(UIViewController *)viewController
{
    UIViewController *presentingViewController = viewController.view.window.rootViewController;
    
    while (presentingViewController.presentedViewController){
        presentingViewController = presentingViewController.presentedViewController;
    }
    
    UIView *snapshotView = [presentingViewController.view snapshotViewAfterScreenUpdates:YES];
    
    return snapshotView;
}

- (void)pushFromViewController:(UIViewController *)viewController appearRect:(CGRect)rect
{
    _snapshotView = [[self snapshotFromViewController:viewController] retain];
    
    _previousViewTitle = [[NSString alloc] initWithString:viewController.title];
    
    _appearRect = rect;
    
    [viewController.navigationController pushViewController:self animated:NO];
}

- (void)pushAnimationHandleWithCompletion:(void (^) (void))completion
{
    UIView *blockView = [[UIView alloc] initWithFrame:_appearRect];
    [blockView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *transitionImageView = [self imageViewForTransitionAnimationWithPush:YES];
    
    [_snapshotView addSubview:blockView];
    [_snapshotView addSubview:transitionImageView];
    
    [blockView release];
    
    CGRect finallyRect = [self imageViewRectToFitScreen];
    
    void (^animations) (void) = ^{
        [transitionImageView setFrame:finallyRect];
    };
    
    void (^_completion) (BOOL) = ^(BOOL finished) {
        [transitionImageView removeFromSuperview];
        [_snapshotView setHidden:YES];
        
        [_previewView setHidden:NO];
        
        if (completion != nil) completion();
    };
    
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:animations completion:_completion];
}

#pragma mark - Pop Handle

- (void)popAnimationHandle
{
    [_previewView setHidden:YES];
    [_snapshotView setHidden:NO];
    
    UIImageView *transitionImageView = [self imageViewForTransitionAnimationWithPush:NO];
    
    [_snapshotView addSubview:transitionImageView];
    
    void (^animations) (void) = ^{
        [transitionImageView setFrame:_appearRect];
    };
    
    void (^completion) (BOOL) = ^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    };
    
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:animations completion:completion];
}

#pragma mark - Actions

- (void)popHandle:(id)sender
{
    [self popAnimationHandle];
}

- (void)applyHandle:(id)sender
{
    
}

- (void)tapImageViewHandle:(UIGestureRecognizer *)sender
{
    BOOL hidden = self.navigationController.navigationBarHidden;
    
    [self.navigationController setNavigationBarHidden:!hidden animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIColor *backgroundColor = (hidden) ? [UIColor whiteColor] : [UIColor blackColor];
    [self.view setBackgroundColor:backgroundColor];
}

@end
