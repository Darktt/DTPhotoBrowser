//
//  DTPhotoViewController.m
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "Catagorys.h"
#import "DTPhotoViewController.h"
#import "DTPhotoViewCell.h"
#import "DTPhotoBrowerViewController.h"

#define kTableViewTag 1

// Get all assets
#define kGetAlassetType ![[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeUnknown]
// Get photo assets only
//#define kGetAlassetType [[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]
// Get video assets onlt
//#define kGetAlassetType [[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]

@interface DTPhotoViewController () <UITableViewDataSource, UITableViewDelegate, DTPhotoViewCellDelegate>
{
    DTAlbumMode currentMode;
    ALAssetsGroup *_group;
    
    NSArray *photos;
    NSArray *photosOfUrl;
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
    self = [super initWithNibName:@"DTPhotoViewController" bundle:nil];
    
    if (self == nil) return nil;
    
    currentMode = mode;
    _group = group;
    
    photos = [NSArray new];
    photosOfUrl = [NSArray new];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    NSString *title = [_group valueForProperty:ALAssetsGroupPropertyName];
    
    [self setTitle:title];
    [self setWantsFullScreenLayout:YES];
    
    UITableView *tableView = [UITableView tableViewWithFrame:self.view.bounds style:UITableViewStylePlain forTager:self];
    [tableView setSeparatorColor:[UIColor clearColor]];
    [tableView setTag:kTableViewTag];
    
    [self setView:tableView];
    
    [self getPhotoInfomation];
}

- (void)dealloc
{
    [photos release];
    [photosOfUrl release];
    
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
    NSMutableArray *_photos = [NSMutableArray array];
    NSMutableArray *_photosOfUrl = [NSMutableArray array];
    
    ALAssetsGroupEnumerationResultsBlock groupEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result != nil) {
            
            // Get photo and video data.
            if (kGetAlassetType) {
                
                UIImage *photo = [UIImage imageWithCGImage:[result thumbnail]];
                [_photos addObject:photo];
                
                ALAssetRepresentation *representation = [result defaultRepresentation];
                [_photosOfUrl addObject:[representation url]];
                
//                NSLog(@"%@", [representation filename]);
            }
            
        } else {
            [photos release];
            photos = [_photos copy];
            
            [photosOfUrl release];
            photosOfUrl = [_photosOfUrl copy];
            
            [tableView reloadData];
        }
    };
    
    [_group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:groupEnumerationBlock];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (photos.count % kCellForPhotoCount == 0) {
        return photos.count / kCellForPhotoCount;
    }
    
    return (photos.count / kCellForPhotoCount) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSMutableArray *photosForCell = [NSMutableArray array];
    
    for (NSInteger i = 1; i <= kCellForPhotoCount; i++) {
        NSInteger j = indexPath.row;
        
        NSInteger index = j * kCellForPhotoCount + i;
        
        if (index > photos.count) {
            break;
        }
        
        [photosForCell addObject:photos[index - 1]];
    }
    
    DTPhotoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath) {
            switch (currentMode) {
                case DTAlbumModeNormal:
                    cell = [DTPhotoViewCell photoViewCellWithPhotos:photosForCell reuseIdentifier:CellIdentifier];
                    [cell setDelegate:self];
                    break;
                    
                case DTAlbumModeCopy:
                    cell = [DTPhotoViewCell photoViewCellWithPhotosForCopyMode:photosForCell reuseIdentifier:CellIdentifier];
                    break;
                    
                default:
                    break;
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    } else {
        [cell setPhotos:photosForCell];
    }
    
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

- (void)photoViewCell:(DTPhotoViewCell *)photoViewCell tapPhotoForImage:(UIImage *)image
{
    NSUInteger index = [photos indexOfObject:image];
    
    DTPhotoBrowerViewController *photoBrower = [DTPhotoBrowerViewController photoBrowerWithIndex:index forPhotosArray:photosOfUrl];
    [self.navigationController pushViewController:photoBrower animated:YES];
}

@end
