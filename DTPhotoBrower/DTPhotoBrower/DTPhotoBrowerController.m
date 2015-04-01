//
//  DTPhotoBrowerController.m
//  DTPhotoBrower
//
//  Created by Darktt on 2015/3/30.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import "DTPhotoBrowerController.h"
#import "PHFetchResult+Array.h"
#import "PHImageManager+ImageManager.h"

#import "DTPhotoBrowerSetting.h"
#import "DTPhotoBrowerCell.h"
#import "DTPhotoPreviewController.h"

@import Photos;
@import AssetsLibrary;

typedef NS_ENUM(NSUInteger, DTPhotoBrowerAssetQuality) {
    DTPhotoBrowerAssetQualityThumbnail = 0,
    DTPhotoBrowerAssetQualityScreenResolution,
    DTPhotoBrowerAssetQualityFullResolution,
};

static NSString *kCellIdentifier = @"Cell";

@interface DTPhotoBrowerController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSArray *_assets;
    PHFetchResult *_fetchResult;
    
    UICollectionView *_collectionView;
    
    UIAlertController *_alertController;
}

@end

@implementation DTPhotoBrowerController

+ (instancetype)photoBrowerWithAssets:(NSArray *)assets
{
    DTPhotoBrowerController *photoBrower = [[DTPhotoBrowerController alloc] initWithAssets:assets];
    
    return [photoBrower autorelease];
}

+ (instancetype)photoBrowerWithFetchResult:(PHFetchResult *)fetchResult
{
    DTPhotoBrowerController *photoBrower = [[DTPhotoBrowerController alloc] initWithFetchResult:fetchResult];
    
    return [photoBrower autorelease];
}

#pragma mark Instance Method -
#pragma mark View Live Cycle

- (instancetype)initWithAssets:(NSArray *)assets
{
    self = [super init];
    if (self == nil) return nil;
    
    _assets = [assets retain];
    
    return self;
}

- (instancetype)initWithFetchResult:(PHFetchResult *)fetchResult
{
    self = [super init];
    if (self == nil) return nil;
    
    _fetchResult = [fetchResult retain];
    
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
    
    NSAssert(self.navigationController != nil, @"Must use with UINavigationController");
    
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UICollectionViewFlowLayout *collectionViewLayout = [UICollectionViewFlowLayout new];
    UIViewAutoresizing autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:screenRect collectionViewLayout:collectionViewLayout];
    [_collectionView registerClass:[DTPhotoBrowerCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setAlwaysBounceVertical:YES];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setAutoresizingMask:autoresizingMask];
    [_collectionView setAutoresizesSubviews:YES];
    
    [self.view addSubview:_collectionView];
    [collectionViewLayout release];
}

- (void)dealloc
{
    if (_assets != nil) {
        [_assets release];
        _assets = nil;
    }
    
    if (_fetchResult != nil) {
        [_fetchResult release];
        _fetchResult = nil;
    }
    
    [_collectionView release];
    
    [super dealloc];
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
    return NO;
}

#pragma mark - Fetch Image from Asset
#pragma mark #AssetLibrary

- (UIImage *)imageWithAsset:(ALAsset *)asset forQuality:(DTPhotoBrowerAssetQuality)quality
{
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    
    if (quality == DTPhotoBrowerAssetQualityThumbnail) {
        UIImage *thumbnail = [UIImage imageWithCGImage:asset.thumbnail scale:2.0f orientation:UIImageOrientationUp];
        
        return thumbnail;
    }
    
    if (quality == DTPhotoBrowerAssetQualityScreenResolution) {
        CGImageRef cgImage = [representation fullScreenImage];
        
        UIImage *image = [UIImage imageWithCGImage:cgImage scale:2.0f orientation:UIImageOrientationUp];
        
        return image;
    }
    
    ALAssetOrientation orientation = representation.orientation;
    CGImageRef cgImage = [representation fullResolutionImage];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:2.0f orientation:(UIImageOrientation)orientation];
    
    return image;
}

#pragma mark #Photo Framework

- (CGSize)imageLimitSizeForAsset:(PHAsset *)asset
{
    CGFloat maximumSide = MAX(asset.pixelWidth, asset.pixelHeight);
    CGSize imageSize = CGSizeZero;
    
    if (maximumSide > 3000.0f) {
        imageSize = CGSizeMake(3000.0f, 3000.0f);
    } else {
        imageSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    }
    
    return imageSize;
}

- (void)fetchThumbnailImageWithPHAsset:(PHAsset *)asset forSize:(CGSize)size result:(PHImageManagerFetchImageResult)resultHandler
{
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager thumbnailImageWithAsset:asset imageSize:size result:resultHandler];
}

- (void)fetchImageWithPHAsset:(PHAsset *)asset result:(PHImageManagerFetchImageResult)resultHandler
{
    CGSize imageSize = [self imageLimitSizeForAsset:asset];
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager imageWithAsset:asset limitSize:imageSize result:resultHandler];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_assets != nil) {
        return _assets.count;
    }
    
    return _fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DTPhotoBrowerCell *cell = (DTPhotoBrowerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    NSUInteger index = indexPath.item;
    
    if (_assets != nil) {
        ALAsset *asset = _assets[index];
        UIImage *image = [self imageWithAsset:asset forQuality:DTPhotoBrowerAssetQualityThumbnail];
        
        [cell.imageView setImage:image];
        
        return cell;
    }
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    CGSize cellSize = [self collectionView:collectionView layout:collectionView.collectionViewLayout sizeForItemAtIndexPath:indexPath];
    
    PHAsset *asset = _fetchResult[index];
    
    CGSize imageSize = (CGSize) {
        .width = cellSize.width * scale,
        .height = cellSize.height * scale
    };
    
    PHImageManagerFetchImageResult resultHandler = ^(UIImage *image) {
        [cell.imageView setImage:image];
    };
    
    [self fetchThumbnailImageWithPHAsset:asset forSize:imageSize result:resultHandler];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DTPhotoBrowerCell *cell = (DTPhotoBrowerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGRect cellRect = [self.view convertRect:cell.frame fromView:collectionView];
    
    NSUInteger index = indexPath.item;
    NSUInteger totalCount = (_assets != nil) ? _assets.count : _fetchResult.count;
    NSString *title = [NSString stringWithFormat:@"(%.2tu/%.2tu)", index + 1, totalCount];
    
    if (_assets != nil) {
        ALAsset *asset = _assets[index];
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGSize assetSize = representation.dimensions;
        
        DTPhotoBrowerAssetQuality quality = DTPhotoBrowerAssetQualityFullResolution;
        
        // When image's maximum side is large then 3000 pixel, use full screen resolution.
        if (MAX(assetSize.width, assetSize.height) > 3000.0f) {
            quality = DTPhotoBrowerAssetQualityScreenResolution;
        }
        
        UIImage *image = [self imageWithAsset:asset forQuality:quality];
        
        DTPhotoPreviewController *preview = [DTPhotoPreviewController photoPreviewWithPhoto:image];
        [preview setTitle:title];
        [preview pushFromViewController:self appearRect:cellRect];
        return;
    }
    
    PHAsset *asset = _fetchResult[index];
    
    PHImageManagerFetchImageResult resultHandler = ^(UIImage *image){
        DTPhotoPreviewController *preview = [DTPhotoPreviewController photoPreviewWithPhoto:image];
        [preview setTitle:title];
        [preview pushFromViewController:self appearRect:cellRect];
    };
    
    [self fetchImageWithPHAsset:asset result:resultHandler];
}

#pragma mark - UICollectionView Delegate FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    CGFloat borderWidth = 2.0f;
    
    CGFloat cellWidth = (width - (borderWidth * 3) ) / 4.0f;
    
    return CGSizeMake(cellWidth, cellWidth);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets inset = (UIEdgeInsets) {
        .top = 9.0f,
    };
    
    return inset;//UIEdgeInsetsZero;
}

@end
