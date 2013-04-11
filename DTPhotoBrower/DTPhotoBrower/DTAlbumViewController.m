//
//  DTAlbumViewController.m
//  DTAlbumBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "Catagorys.h"
#import "DTAlbumViewController.h"
#import "DTTableViewCell.h"
#import "DTPhotoViewController.h"

#define kAlertTitle @"Emty Album"
#define kAlertMessage @"Your Album is emty."

@interface DTAlbumViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *photoGroup;
    NSArray *lastPhotoOfGroup;
    NSArray *alassetsGroups;
}

@end

@implementation DTAlbumViewController

+ (id)albumViewWithPhotoMode:(DTAlbumMode)mode
{
    DTAlbumViewController *albumViewController = nil;
    
    switch (mode) {
        case DTAlbumModeNormal:
            albumViewController = [[[DTAlbumViewController alloc] initWithPhotoNormalMode] autorelease];
            break;
            
        case DTAlbumModeCopy:
            albumViewController = [[[DTAlbumViewController alloc] initWithPhotoCopyMode] autorelease];
            break;
            
        default:
            break;
    }
    
    return albumViewController;
}

+ (id)albumViewWithPhotoStyle:(DTAlbumViewStyle)style mode:(DTAlbumMode)mode
{
    DTAlbumViewController *photoViewController = [[[DTAlbumViewController alloc] initWithPhotoStyle:style mode:mode] autorelease];
    
    return photoViewController;
}

- (id)initWithPhotoCopyMode
{
    self = [super initWithNibName:@"DTAlbumViewController" bundle:nil];
    
    if (self == nil) return nil;
    
    [self setDefaultArray];
    return self;
}

- (id)initWithPhotoNormalMode
{
    self = [super initWithNibName:@"DTAlbumViewController" bundle:nil];
    
    if (self == nil) return nil;
    
    [self setDefaultArray];
    return self;
}

- (id)initWithPhotoStyle:(DTAlbumViewStyle)style mode:(DTAlbumMode)mode
{
    self = [super initWithNibName:@"DTAlbumViewController" bundle:nil];
    
    if (self == nil) return nil;
    
    [self setDefaultArray];
    return self;
}

- (void)setDefaultArray
{
    photoGroup = [[NSArray alloc] initWithObjects:@"", nil];
    lastPhotoOfGroup = [NSArray array];
    alassetsGroups = [NSArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self setTitle:@"Photo Brower"];
    [self setWantsFullScreenLayout:YES];
    
    CGRect frame = self.view.bounds;
    UITableView *tableView = [UITableView tableViewWithFrame:frame style:UITableViewStylePlain forTager:self];
    
    [self setView:tableView];
    
    NSMutableArray *_photoGroup = [NSMutableArray array];
    NSMutableArray *_lastPhotoOfGroup = [NSMutableArray array];
    NSMutableArray *_alassetsGroups = [NSMutableArray array];
    
    ALAssetsGroupEnumerationResultsBlock groupEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            UIImage *photo = [UIImage imageWithCGImage:[result thumbnail] scale:1 orientation:UIImageOrientationUp];
            [_lastPhotoOfGroup addObject:photo];
        } else {
            [lastPhotoOfGroup release];
            lastPhotoOfGroup = [_lastPhotoOfGroup copy];
        }
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock libraryEnumerationBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            
            NSString *groupName = [NSString stringWithFormat:@"%@ (%d)", [group valueForProperty:ALAssetsGroupPropertyName], [group numberOfAssets]];
            
//            NSLog(@"Album Name:%@", groupName);
            
            [_alassetsGroups addObject:group];
            [_photoGroup addObject:groupName];
            
            if ([group numberOfAssets] != 0) {
                [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - 1] options:0 usingBlock:groupEnumerationBlock];
            }
            
        } else {
            [photoGroup release];
            photoGroup = [_photoGroup copy];
            
            [alassetsGroups release];
            alassetsGroups = [_alassetsGroups copy];
            
            [tableView reloadData];
        }
    };
    
    ALAssetsLibrary *libary = [ALAssetsLibrary new];
    [libary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:libraryEnumerationBlock failureBlock:^(NSError *error){
        NSLog(@"%@", error);
    }];
}

- (void)dealloc
{
    [photoGroup release];
    [lastPhotoOfGroup release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Show Alert Methods

- (void)showEmtyPhotoAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertTitle message:kAlertMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Alert_View_OK_Btn") otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return photoGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    DTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath) {
            cell = [DTTableViewCell tableCellWithStyle:DTTableViewCellStyleBlack reuseIdentifier:CellIdentifier];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    [cell.textLabel setText:photoGroup[indexPath.row]];
    
    if (lastPhotoOfGroup.count != 0)
        [cell.imageView setImage:lastPhotoOfGroup[indexPath.row]];
    else {
//        [self showEmtyPhotoAlert];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

#pragma mark - UITableViewDelegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ALAssetsGroup *group = [alassetsGroups objectAtIndex:indexPath.row];
    NSLog(@"%@, %d", [group valueForProperty:ALAssetsGroupPropertyName], [group numberOfAssets]);
    
    DTPhotoViewController *photoView = [DTPhotoViewController photoViewWithAssetsGroup:group mode:DTAlbumModeNormal];
    [self.navigationController pushViewController:photoView animated:YES];
}

@end
