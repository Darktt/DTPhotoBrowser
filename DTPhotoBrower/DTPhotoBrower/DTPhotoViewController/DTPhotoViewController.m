//
//  DTPhotoViewController.m
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTPhotoViewController.h"

// Framework
#import <AssetsLibrary/AssetsLibrary.h>

// Config
#import "DTAssetConfig.h"

// Category
#import "ALAssetsLibrary+SaveAsset.h"

// Class
#import "DTAssetType.h"
#import "DTPhotoViewCell.h"

// ViewController
#import "DTPhotoBrowerViewController.h"

// Tags
#define kTableViewTag 1
#define kProgressTag  2

#define INDICATOR_VIEW_TAG          200

// Localized String
#define kCopyBtnTitle                   NSLocalizedString(@"Copy Here", @"Copy_Here_Button")
#define kMoveBtnTitle                   NSLocalizedString(@"Move Here", @"Move_Here_Button")
#define kAlertOK                        NSLocalizedString(@"OK", @"AlertView_OK_Button")
#define kAlertCancel                    NSLocalizedString(@"Cancel", @"AlertView_Cancel_Button")
#define kAlertCopyTitle                 NSLocalizedString(@"Copying...", @"AlertView_Copy_Title")
#define kAlertMoveTitle                 NSLocalizedString(@"Moving...", @"AlertView_Move_Title")
#define kAlertSpaceNotEnoughTitle       NSLocalizedString(@"Failed", @"AlertView_Space_Not_Enough_Title")
#define kAlertSpaceNotEnoughMessage     NSLocalizedString(@"Device free space isn't enough to process.", @"AlertView_Space_Not_Enough_Message")

@interface DTPhotoViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, DTPhotoViewCellDelegate>
{
    DTAlbumMode currentMode;
    BOOL fileProcessCanceled;
    
    ALAssetsGroup *_group;
    UIBarButtonItem *copyBtn;
    
    NSArray *thumbnails;
    NSArray *assets;
    NSMutableArray *selectedAssets;
    
    DTAssetType *assetType;
    
    UIAlertView *_alertView;
}

@end

@implementation DTPhotoViewController

+ (id)photoViewWithAssetsGroup:(ALAssetsGroup *)group mode:(DTAlbumMode)mode
{
    DTPhotoViewController *photoViewController = [[[DTPhotoViewController alloc] initWithAssetsGroup:group mode:mode] autorelease];
    
    return photoViewController;
}

- (id)initWithAssetsGroup:(ALAssetsGroup *)group mode:(DTAlbumMode)mode
{
    self = [super init];
    
    if (self == nil) return nil;
    
    currentMode = mode;
    _group = group;
    
    thumbnails = [NSArray new];
    assets = [NSArray new];
    selectedAssets = [NSMutableArray new];
    
    assetType = [DTAssetType new];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Appearance Setting
    if ([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)]) {
        // iOS 7 Style or Highter
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]}];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
    } else {
        // iOS 6 Style or Lower
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
        [self.navigationController.navigationBar setTranslucent:YES];
        [self setWantsFullScreenLayout:YES];
    }
    
    NSString *title = [_group valueForProperty:ALAssetsGroupPropertyName];
    
    [self setTitle:title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self setTitle:kBackTitle];
    
    if (!self.navigationController.toolbarHidden) {
        [self enterEditMode:nil];
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Main View Setting
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [tableView setDataSource:self];
//    [tableView setBackgroundColor:[UIColor blackColor]];
    [tableView setSeparatorColor:[UIColor clearColor]];
    [tableView setTag:kTableViewTag];
    [tableView setRowHeight:kCellHeight];
    
    [self setView:tableView];
    [tableView release];
    
    // Navigation Toolbar Setting
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    copyBtn = [[UIBarButtonItem alloc] initWithTitle:kCopyBtnTitle
                                               style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(copyHere:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    
    UIBarButtonItem *actionBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    
    switch (currentMode) {
        case DTAlbumModeNormal:
            [self setToolbarItems:@[flexibleSpace, copyBtn, flexibleSpace]];
            break;
            
        case DTAlbumModeCopy:
            [actionBtn setTitle:kCopyBtnTitle];
            [actionBtn setAction:@selector(copyHere:)];
            
            [self setToolbarItems:@[flexibleSpace, actionBtn, flexibleSpace]];
            break;
            
        case DTAlbumModeMove:
            [actionBtn setTitle:kMoveBtnTitle];
            [actionBtn setAction:@selector(moveHere:)];
            
            [self setToolbarItems:@[flexibleSpace, actionBtn, flexibleSpace]];
            break;
            
        default:
            break;
    }
    
    [flexibleSpace release];
    [actionBtn release];
    
    if (currentMode != DTAlbumModeNormal) {
        [self.navigationController setToolbarHidden:NO animated:YES];
    } else {
        UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditMode:)];
        
        [self.navigationItem setRightBarButtonItem:editBtn animated:YES];
        [editBtn release];
    }
    
    [self getPhotoInfomation];
}

- (void)dealloc
{
    [copyBtn release];
    
    [thumbnails release];
    [assets release];
    [selectedAssets release];
    
    if (assetType != nil) {
        [assetType release];
    }
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get Photo Infomation

- (void)getPhotoInfomation
{
    UITableView *tableView = (UITableView *)[self.view viewWithTag:kTableViewTag];
    NSMutableArray *_thumbnails = [NSMutableArray array];
    NSMutableArray *_photosOfAsset = [NSMutableArray array];
    
    ALAssetsGroupEnumerationResultsBlock groupEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result != nil) {
            
            // Get photo and video data.
            if (kGetAlassetType) {
                NSMutableDictionary *thumbnailDictionary = [NSMutableDictionary dictionary];
                
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                    DTAssetType *_assetType = [DTAssetType defaultType];
                    [_assetType setType:AssetTypeVideo];
                    [thumbnailDictionary setValue:_assetType forKey:kTypeKey];
                    
                    UIImage *thumbnail = [UIImage imageWithCGImage:[result thumbnail]];
                    [thumbnailDictionary setValue:thumbnail forKey:kThumbnailKey];
                    
                    NSNumber *videoDuration = [result valueForProperty:ALAssetPropertyDuration];
                    [thumbnailDictionary setValue:videoDuration forKey:kDurationKey];
                    
                    [_thumbnails addObject:[[thumbnailDictionary copy] autorelease]];
                    [_photosOfAsset addObject:result];
                    return;
                }
                
                DTAssetType *_assetType = [DTAssetType defaultType];
                [_assetType setType:AssetTypePhoto];
                [thumbnailDictionary setValue:_assetType forKey:kTypeKey];
                
                UIImage *thumbnail = [UIImage imageWithCGImage:[result thumbnail]];
                [thumbnailDictionary setValue:thumbnail forKey:kThumbnailKey];
                
                [_thumbnails addObject:thumbnailDictionary];
                
                [_photosOfAsset addObject:result];
            }
            
        } else {
            [thumbnails release];
            thumbnails = [_thumbnails copy];
            
            [assets release];
            assets = [_photosOfAsset copy];
            
            [tableView reloadData];
        }
    };
    
    [_group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:groupEnumerationBlock];
    
    [assetType filterAssetsWithAssets:assets];
}

#pragma mark - UIBarButtonItem Action Method

- (void)fileProcessAtIndex:(NSNumber *)index
{
    NSUInteger _index = [index unsignedIntegerValue];
    
    NSString *imageName = [NSString stringWithString:selectedAssets[_index]];
    
    UIImage *saveImage = [UIImage imageWithContentsOfFile:imageName];
    
    ALAssetsLibrarySaveCompletionBlock completionBlock = ^(NSError *error){
        if (error != nil) {
            NSLog(@"%@", error);
            
            [_alertView dismissWithClickedButtonIndex:_alertView.cancelButtonIndex animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        NSLog(@"%s %@ Saved", __func__, [[imageName pathComponents] lastObject]);
        
        UIProgressView *progress = (UIProgressView *)[_alertView viewWithTag:kProgressTag];
        
        NSUInteger nextIndex = _index + 1;
        CGFloat progressValue = (CGFloat)nextIndex / (CGFloat)selectedAssets.count;
        [progress setProgress:progressValue animated:YES];
        
        if (nextIndex == selectedAssets.count || fileProcessCanceled) {
            [_alertView dismissWithClickedButtonIndex:_alertView.cancelButtonIndex animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        [self performSelector:@selector(fileProcessAtIndex:) withObject:@(nextIndex) afterDelay:0.5];
    };
    
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    [library saveImageToAlbumWithImage:saveImage album:self.title completionBlock:completionBlock];
    [library release];
}

- (IBAction)copyHere:(id)sender
{
//#pragma message Copy image or video data to here.
    [_alertView setTitle:kAlertCopyTitle];
    [_alertView show];
    
    [self fileProcessAtIndex:@(0)];
}

- (IBAction)moveHere:(id)sender
{
//#pragma message Move image or video data to here.
}

- (IBAction)copyTo:(id)sender
{
//#pragma message Copy asset out to external viewController.
}

- (IBAction)enterEditMode:(id)sender
{
    BOOL editMode = self.navigationController.toolbarHidden;
    UITableView *tableView = (UITableView *)self.view;
    
    if (editMode) {
        [self.navigationController setToolbarHidden:NO animated:YES];
        [self.navigationItem setHidesBackButton:YES animated:YES];
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(enterEditMode:)];
        [self.navigationItem setRightBarButtonItem:doneBtn];
        [doneBtn release];
        
        [copyBtn setTitle:NSLocalizedString(@"Copy", @"Copy_Button")];
        [copyBtn setAction:@selector(copyTo:)];
        [copyBtn setEnabled:NO];
    } else {
        [self.navigationController setToolbarHidden:YES animated:YES];
        [self.navigationItem setHidesBackButton:NO animated:YES];
        
        UIBarButtonItem *edtiBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditMode:)];
        [self.navigationItem setRightBarButtonItem:edtiBtn];
        [edtiBtn release];
        
        [selectedAssets removeAllObjects];
    }
    
    NSInteger totalCellHeight = [tableView numberOfRowsInSection:0];
    totalCellHeight = (totalCellHeight - ( tableView.frame.size.height / kCellHeight )) * kCellHeight;
    
    if (tableView.contentOffset.y > totalCellHeight && totalCellHeight > tableView.frame.size.height) {
        CGFloat offsetY = tableView.contentOffset.y - 44;
        
        [tableView setContentOffset:CGPointMake(0, offsetY) animated:NO];
    }
    
    [tableView reloadData];
}

#pragma mark - UIAlertView Method

- (void)operationDoneAlert {
    UIAlertView *doneAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Done", @"") message:NSLocalizedString(@"", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [doneAlertView show];
    [doneAlertView release];
}

#pragma mark UIAlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:kAlertSpaceNotEnoughTitle]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    fileProcessCanceled = YES;
}

#pragma mark - Overwrite Method

- (void)setSelectedFiles:(NSArray *)selectedFiles
{
    if (selectedAssets != nil) {
        [selectedAssets release];
    }
    
    selectedAssets = [[NSMutableArray alloc] initWithArray:selectedFiles];
}

- (NSArray *)selectedFiles
{
    return selectedAssets;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([thumbnails count] % kCellForPhotoCount == 0) {
        return [thumbnails count] / kCellForPhotoCount;
    }
    
    return ([thumbnails count] / kCellForPhotoCount) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSMutableArray *thumbnailsForCell = [NSMutableArray array];
    NSMutableArray *assetsForCell = [NSMutableArray array];
    
    for (NSInteger i = 1; i <= kCellForPhotoCount; i++) {
        NSInteger j = indexPath.row;
        
        NSInteger index = j * kCellForPhotoCount + i;
        
        if (index > [thumbnails count]) {
            break;
        }
        
        [thumbnailsForCell addObject:thumbnails[index - 1]];
        [assetsForCell addObject:assets[index - 1]];
    }
    
    DTPhotoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath) {
            switch (currentMode) {
                case DTAlbumModeNormal:
                    cell = [DTPhotoViewCell photoViewCellWithThumbnails:thumbnailsForCell reuseIdentifier:CellIdentifier];
                    [cell setDelegate:self];
                    break;
                    
                case DTAlbumModeCopy:
                    cell = [DTPhotoViewCell photoViewCellWithThumbnailsForCopyMode:thumbnailsForCell reuseIdentifier:CellIdentifier];
                    break;
                    
                case DTAlbumModeMove:
                    cell = [DTPhotoViewCell photoViewCellWithThumbnailsForCopyMode:thumbnailsForCell reuseIdentifier:CellIdentifier];
                    break;
                    
                default:
                    break;
            }
            
            [cell.backgroundView setBackgroundColor:tableView.backgroundColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    } else {
        [cell setThumbnails:thumbnailsForCell];
    }
    
    if (currentMode != DTAlbumModeNormal) {
        return cell;
    }
    
    [assetsForCell enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if ([selectedAssets indexOfObject:obj] == NSNotFound) {
            [cell setCheckMark:NO photoIndex:idx];
        } else {
            [cell setCheckMark:YES photoIndex:idx];
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

#pragma mark - UITableViewDelegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - DTPhotoViewCellDelegate Method

- (void)photoViewCell:(DTPhotoViewCell *)photoViewCell tapedPhotoForThumbnail:(NSDictionary *)thumbnail
{
    NSUInteger index = [thumbnails indexOfObject:thumbnail];
    NSUInteger indexForCell = [photoViewCell.thumbnails indexOfObject:thumbnail];
    
    BOOL editMode = !self.navigationController.toolbarHidden;
    
    if (editMode) {
        ALAsset *asset = assets[index];
        
        if ([selectedAssets indexOfObject:asset] != NSNotFound) {
            [selectedAssets removeObject:asset];
            
            [photoViewCell setCheckMark:NO photoIndex:indexForCell];
        } else {
            [selectedAssets addObject:asset];
            
            [photoViewCell setCheckMark:YES photoIndex:indexForCell];
        }
        
        BOOL enable = selectedAssets.count > 0;
        [copyBtn setEnabled:enable];
        
        return;
    }
    
    ALAsset *asset = assets[index];
    
    if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
        /// MARK: Show photo assets
//        DTPhotoBrowerViewController *photoBrower = [DTPhotoBrowerViewController photoBrowerWithIndex:index forPhotosArray:assetType.photoAssets];
//        [self.navigationController pushViewController:photoBrower animated:YES];
    }
    
    if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
        /// MARK: Show video assets
    }
}

@end
