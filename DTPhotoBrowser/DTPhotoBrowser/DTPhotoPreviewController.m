//
//  DTPhotoPreviewController.m
//  DTPhotoBrowser
//
//  Created by Darktt on 2015/3/31.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import "DTPhotoPreviewController.h"

#import "DTPhotoBrowserSetting.h"

@interface DTPhotoPreviewController () <UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning>
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
    
    [self.navigationController setDelegate:self];
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
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

- (BOOL)prefersStatusBarHidden
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    BOOL hidden = UIDeviceOrientationIsLandscape(orientation);
    
    if (!hidden) {
        hidden = self.navigationController.navigationBarHidden;
    }
    
    return hidden;
}

#pragma mark - UI Setup

- (CGRect)imageViewRectToFitScreen
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    BOOL isPortrait = (CGRectGetWidth(screenRect) < CGRectGetHeight(screenRect));
    CGFloat shortSideOfScreen = MIN(CGRectGetWidth(screenRect), CGRectGetHeight(screenRect));
    CGFloat longSideOfScreen = MAX(CGRectGetWidth(screenRect), CGRectGetHeight(screenRect));
    
    CGSize imageSize = _previewImage.size;
    
    CGFloat width = isPortrait ? imageSize.width : imageSize.height;
    CGFloat height = isPortrait ? imageSize.height : imageSize.width;
    CGFloat ratio = height / width;
    
    CGFloat shortSideOfImageView = shortSideOfScreen;
    CGFloat longSideOfImageView = shortSideOfScreen * ratio;
    
    if (longSideOfImageView > longSideOfScreen) {
        shortSideOfImageView = longSideOfScreen * (width / height);
        longSideOfImageView = longSideOfScreen;
    }
    
    if (!isPortrait) {
        CGRect imageViewRect = (CGRect) {
            .origin = (CGPoint) {
                .x = (longSideOfScreen - longSideOfImageView) / 2.0f,
                .y = (shortSideOfScreen - shortSideOfImageView) / 2.0f
            },
            .size = (CGSize) {
                .width = longSideOfImageView,
                .height = shortSideOfImageView
            }
        };
        
        return imageViewRect;
    }
    
    CGRect imageViewRect = (CGRect) {
        .origin = (CGPoint) {
            .x = (shortSideOfScreen - shortSideOfImageView) / 2.0f,
            .y = (longSideOfScreen - longSideOfImageView) / 2.0f
        },
        .size = (CGSize) {
            .width = shortSideOfImageView,
            .height = longSideOfImageView
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

- (void)popAnimationHandleWithCompletion:(void (^) (BOOL finish))completion
{
    [_previewView setHidden:YES];
    [_snapshotView setHidden:NO];
    
    UIImageView *transitionImageView = [self imageViewForTransitionAnimationWithPush:NO];
    
    [_snapshotView addSubview:transitionImageView];
    
    void (^animations) (void) = ^{
        [transitionImageView setFrame:_appearRect];
    };
    
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:animations completion:completion];
}

#pragma mark - Actions

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

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25f;//UINavigationControllerHideShowBarDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *currentView = [transitionContext containerView];
    UIViewController *toViewComtroller = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewComtroller = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [currentView addSubview:toViewComtroller.view];
    [currentView addSubview:fromViewComtroller.view];
    
    void (^completion) (BOOL) = ^(BOOL finish){
        [fromViewComtroller.view removeFromSuperview];
        
        [transitionContext finishInteractiveTransition];
        [transitionContext completeTransition:YES];
    };
    
    [self popAnimationHandleWithCompletion:completion];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (![fromVC isEqual:self]) {
        return nil;
    }
    
    if (operation == UINavigationControllerOperationPop) {
        [navigationController setDelegate:nil];
        return self;
    }
    
    return nil;
}

@end
