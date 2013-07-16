//
//  DTPhotoBrowerViewController.m
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTPhotoBrowerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define kSrollViewTag 1
#define kImageViewTag 1

@interface DTPhotoBrowerViewController () {
    NSUInteger currentIndex;
    NSArray *_photos;
    
    ALAssetsLibrary *library;
}

@end

@implementation DTPhotoBrowerViewController

+ (id)photoBrowerWithIndex:(NSUInteger)index forPhotosArray:(NSArray *)photos
{
    DTPhotoBrowerViewController *photoBrower = [[[DTPhotoBrowerViewController alloc] initWithIndex:index forPhotosArray:photos] autorelease];
    
    return photoBrower;
}

- (id)initWithIndex:(NSUInteger)index forPhotosArray:(NSArray *)photos
{
    self = [super init];
    if (self == nil) return nil;
    
    currentIndex = index;
    _photos = [photos retain];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageView setTag:kImageViewTag];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
//    [imageView setImage:photo];
    
    [self.view addSubview:imageView];
    [imageView release];
    
    [self getAsset];
}

- (void)dealloc
{
    [_photos release];
    [library release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get assets from ALAssetLibrary

- (void)getAsset
{
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *asset){
        if (asset) {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            UIImageOrientation orientation = [[asset valueForProperty:ALAssetPropertyOrientation] integerValue];
            
            if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [self setTitle:[representation filename]];
                [self showPhotoWithImage:[representation fullResolutionImage] orientation:orientation];
                
                return ;
            }
            
            if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                [self showMediaWithData:nil];
                
                return;
            }
            
            
        } else {
            
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
        NSLog(@"%@", error);
    };
    
    NSURL *url = _photos[currentIndex];
    library = [ALAssetsLibrary new];
    [library assetForURL:url resultBlock:resultBlock failureBlock:failureBlock];
    
}

- (void)showPhotoWithImage:(CGImageRef)cgImageRef orientation:(UIImageOrientation)orientation
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:kImageViewTag];
    UIImage *photo = [UIImage imageWithCGImage:cgImageRef scale:1 orientation:orientation];
    
    CGRect imageViewFrame = imageView.frame;
    imageViewFrame.size = photo.size;
    
    [imageView setImage:photo];
    [imageView setCenter:self.view.center];
}

- (void)showMediaWithData:(NSData *)data
{
    NSLog(@"This is Video");
}

@end
