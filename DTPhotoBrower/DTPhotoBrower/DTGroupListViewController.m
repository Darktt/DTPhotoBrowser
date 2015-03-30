//
//  DTGroupListViewController.m
//  DTPhotoBrower
//
//  Created by Darktt on 2015/3/27.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import "DTGroupListViewController.h"
#import "PHImageManager+ImageManager.h"
#import "DTPhotoBrowerSetting.h"
#import "DTPhotoBrowerController.h"

CGFloat const kRowHeight = 65.0f;

@import Photos;

@interface DTGroupListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    id<DTGroupListViewControllerDelegate> _target;
    
    UITableView *_tableView;
    
    PHAssetCollection *_allPhotos;
    PHFetchResult *_collections;
}

@end

@implementation DTGroupListViewController

+ (instancetype)groupListWithTarget:(id<DTGroupListViewControllerDelegate>)target
{
    DTGroupListViewController *groupList = [[DTGroupListViewController alloc] initWithTarget:target];
    
    return [groupList autorelease];
}

#pragma mark Instance Method -
#pragma mark View Live Cycle

- (instancetype)initWithTarget:(id<DTGroupListViewControllerDelegate>)target
{
    self = [super init];
    if (self == nil) return nil;
    
    _target = target;
    
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
    
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    [self setTitle:[DTPhotoBrowerSetting titleOfGroupList]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:screenRect style:UITableViewStylePlain];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    
    [self.view addSubview:tableView];
    [tableView release];
    
    _tableView = tableView;
    
    void (^requestHandle) (PHAuthorizationStatus) = ^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) {
            return;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self fetchAllPhotosGroup];
        }];
    };
    
    [PHPhotoLibrary requestAuthorization:requestHandle];
}

- (void)dealloc
{
    [_allPhotos release];
    [_collections release];
    
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

#pragma mark - Fetch Photo Group

- (PHFetchOptions *)fetchOptions
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
    
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    [fetchOptions setPredicate:predicate];
    [fetchOptions setIncludeAllBurstAssets:[DTPhotoBrowerSetting includeAllBurstAssets]];
    [fetchOptions setIncludeHiddenAssets:[DTPhotoBrowerSetting includeHiddenAssets]];
    
    return [fetchOptions autorelease];
}

- (void)fetchAllPhotosGroup
{
    PHAssetMediaType mediaType = [DTPhotoBrowerSetting fetchMediaType];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
    
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    [fetchOptions setSortDescriptors:@[sortDescriptor]];
    
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithMediaType:mediaType options:fetchOptions];
    [fetchOptions release];
    
    NSString *title = [DTPhotoBrowerSetting cameraRollTitle];
    
    PHAssetCollection *allPhotosCollection = [PHAssetCollection transientAssetCollectionWithAssetFetchResult:allPhotos title:title];
    _allPhotos = [allPhotosCollection retain];
    
    [self fetchPhotoGroups];
}

- (void)fetchPhotoGroups
{
    PHFetchOptions *fetchOptions = [self fetchOptions];
    
    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions];
    
    _collections = [collections retain];
    
    [_tableView reloadData];
}

- (PHFetchResult *)assetsInCollection:(PHAssetCollection *)collection
{
    PHAssetMediaType mediaType = [DTPhotoBrowerSetting fetchMediaType];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", mediaType];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    [fetchOptions setPredicate:predicate];
    [fetchOptions setSortDescriptors:@[sortDescriptor]];
    
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
    [fetchOptions release];
    
    return result;
}

- (void)fetchLastImageInCollection:(PHAssetCollection *)collection resultHandler:(void (^) (UIImage *image))resultHandler
{
    PHFetchResult *result = [self assetsInCollection:collection];
    
    PHAsset *lastAsset = result.lastObject;
    
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize limitSize = (CGSize) {
        .width = kRowHeight * screenScale,
        .height = kRowHeight * screenScale
    };
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager thumbnailImageWithAsset:lastAsset imageSize:limitSize result:resultHandler];
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    return _collections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    PHAssetCollection *collection = nil;
    
    if (indexPath.section == 0) {
        collection = _allPhotos;
    } else {
        NSUInteger index = indexPath.row;
        collection = (PHAssetCollection *)_collections[index];
    }
    
    NSUInteger assetCount = collection.estimatedAssetCount;
    
    NSString *collectionName = [NSString stringWithFormat:@"%@ (%tu)", collection.localizedTitle, assetCount];
    
    [cell.textLabel setText:collectionName];
    
    void (^resultHandler) (UIImage *) = ^(UIImage *image) {
        [cell.imageView setImage:image];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [cell.imageView setClipsToBounds:YES];
    };
    
    [self fetchLastImageInCollection:collection resultHandler:resultHandler];
    
    return cell;
}

#pragma mark UITableView Delegate Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    }
    
    return @"Albums";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PHFetchResult *assets = nil;
    NSString *title = nil;
    
    if (indexPath.section == 0) {
        assets = [self assetsInCollection:_allPhotos];
        title = _allPhotos.localizedTitle;
    } else {
        NSUInteger index = indexPath.row;
        PHAssetCollection *collection = _collections[index];
        
        assets = [self assetsInCollection:collection];
        title = collection.localizedTitle;
    }
    
    DTPhotoBrowerController *photoBrower = [DTPhotoBrowerController photoBrowerWithFetchResult:assets];
    [photoBrower setTitle:title];
    
    [self.navigationController pushViewController:photoBrower animated:YES];
}

@end
