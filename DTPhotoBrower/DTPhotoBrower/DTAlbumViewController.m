//
//  DTAlbumViewController.m
//  DTAlbumBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "DTAlbumViewController.h"
#import "DTTableViewCell.h"
#import "DTPhotoViewController.h"

// Get all assets
#define kALAssetsFilter [ALAssetsFilter allAssets]
// Get photo assets only
//#define kALAssetsFilter [ALAssetsFilter allPhotos]
// Get Video assets only
//#define kALAssetsFilter [ALAssetsFilter allVideos]

#define kAlertTitle @"Emty Album"
#define kAlertMessage @"Your Album is emty."
#define kAlertCancelBtn NSLocalizedString(@"Cancel", @"Alert_View_Cancel_Button")
#define kAlertOKBtn NSLocalizedString(@"OK", @"Alert_OK_Cancel_Button")

#define kCreateAlbumAlertTag 50
#define kCreateAlbumTitle NSLocalizedString(@"Create album", @"Create_Album_Title")
#define kCreateAlbumMessage NSLocalizedString(@"", @"Create_Album_Message")

#define kCloseButtonTitle NSLocalizedString(@"Close", @"Close_Button_Title")

#define kTableViewTag 1

#define kAlbumNameKey @"Name"
#define kAlassetsGroupKey @"Group" 
#define kLastPhotoKey @"lastPhoto"

#define kCellHeight 65.0f

@interface DTAlbumViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSArray *albums;
    
    DTAlbumMode currentMode;
    
    ALAssetsLibrary *libary;
}

@end

@implementation DTAlbumViewController

+ (id)albumViewWithPhotoMode:(DTAlbumMode)mode
{
    DTAlbumViewController *albumViewController = [[[DTAlbumViewController alloc] initWithPhotoMode:mode] autorelease];
    
    return albumViewController;
}

+ (id)albumViewWithPhotoStyle:(DTAlbumViewStyle)style mode:(DTAlbumMode)mode
{
    DTAlbumViewController *photoViewController = [[[DTAlbumViewController alloc] initWithPhotoStyle:style mode:mode] autorelease];
    
    return photoViewController;
}

- (id)initWithPhotoMode:(DTAlbumMode)mode
{
    self = [super init];
    
    if (self == nil) return nil;
    
    currentMode = mode;
    [self setDefaultInfomation];
    
    if (currentMode == DTAlbumModeCopy) {
        UIBarButtonItem *addAlbum = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(askNewAlbumName:)];
        
        [self.navigationItem setRightBarButtonItem:addAlbum];
        [addAlbum release];
    }
    
    return self;
}

- (id)initWithPhotoStyle:(DTAlbumViewStyle)style mode:(DTAlbumMode)mode
{
    self = [super init];
    
    if (self == nil) return nil;
    
    currentMode = mode;
    [self setDefaultInfomation];
    
    return self;
}

- (void)setDefaultInfomation
{
    albums = [NSArray new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self setWantsFullScreenLayout:YES];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:kCloseButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
    
    [self.navigationItem setLeftBarButtonItem:backBtn];
    [backBtn release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView setTag:kTableViewTag];
    
    [self setView:tableView];
    [tableView release];
    
    [self getAlbumInfomation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle:@"Photo Brower"];
    
    if (currentMode == DTAlbumModeCopy) {
        
        // Reload album infomation
        [self getAlbumInfomation];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setTitle:kBackTitle];
}

- (void)dealloc
{
    [albums release];
    
    [libary release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AlassetsLibrary Methods

#pragma mark Get Album Infomation

- (void)getAlbumInfomation
{
    UITableView *tableView = (UITableView *)[self.view viewWithTag:kTableViewTag];
    
    NSMutableArray *_albums = [NSMutableArray array];
    NSMutableDictionary *albumData = [NSMutableDictionary dictionary];
    
    ALAssetsGroupEnumerationResultsBlock groupEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            UIImage *photo = [UIImage imageWithCGImage:[result thumbnail] scale:1 orientation:UIImageOrientationUp];
            [albumData setObject:photo forKey:kLastPhotoKey];
        } else {
            [_albums addObject:[[albumData copy] autorelease]];
            [albumData removeAllObjects];
        }
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock libraryEnumerationBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [group setAssetsFilter:kALAssetsFilter];
            
            NSString *groupName = [NSString stringWithFormat:@"%@ (%d)", [group valueForProperty:ALAssetsGroupPropertyName], [group numberOfAssets]];
            
//            NSLog(@"Album Name:%@", groupName);
            
            [albumData setObject:groupName forKey:kAlbumNameKey];
            [albumData setObject:group forKey:kAlassetsGroupKey];
            
            if ([group numberOfAssets] != 0) {
                [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - 1] options:NSEnumerationConcurrent usingBlock:groupEnumerationBlock];
            } else {
                [albumData setObject:@"" forKey:kLastPhotoKey];
                [_albums addObject:[[albumData copy] autorelease]];
                [albumData removeAllObjects];
            }
            
        } else {
            [albums release];
            albums = [_albums copy];
            
            [tableView reloadData];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
        NSLog(@"%@", error);
    };
    
    libary = [ALAssetsLibrary new];
    [libary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:libraryEnumerationBlock failureBlock:failureBlock];
}

#pragma mark Create New Album

- (void)addNewAlbumWithAlbumName:(NSString *)albumName
{
    if (libary == nil) {
        libary = [ALAssetsLibrary new];
    }
    
    dispatch_queue_t createAlbumQueue = dispatch_queue_create("Create Album", NULL);
    dispatch_async(createAlbumQueue, ^{
        
        ALAssetsLibraryGroupResultBlock resultBlock = ^(ALAssetsGroup *group){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getAlbumInfomation];
            });
            
        };
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
            NSLog(@"%@", error);
        };
        
        [libary addAssetsGroupAlbumWithName:albumName resultBlock:resultBlock failureBlock:failureBlock];
    });
    
    dispatch_release(createAlbumQueue);
}

#pragma mark - UIBarButtonItem Action Method

- (IBAction)askNewAlbumName:(id)sender
{
    UIAlertView *askAlbumName = [[UIAlertView alloc] initWithTitle:kCreateAlbumTitle
                                                           message:kCreateAlbumMessage
                                                          delegate:self
                                                 cancelButtonTitle:kAlertCancelBtn
                                                 otherButtonTitles:kAlertOKBtn, nil];
    
    [askAlbumName setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [askAlbumName setTag:kCreateAlbumAlertTag];
    [askAlbumName show];
    [askAlbumName release];
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Show Alert Methods

- (void)showEmtyPhotoAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertTitle message:kAlertMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Alert_View_OK_Btn") otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:kAlertOKBtn]) {
        UITextField *albumName = [alertView textFieldAtIndex:0];
        
        [self addNewAlbumWithAlbumName:albumName.text];
//        [self addNewAlbumWithAlbumName:nil];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    DTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath) {
            cell = [DTTableViewCell tableCellWithStyle:DTTableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    NSDictionary *_albumData = [albums objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[_albumData objectForKey:kAlbumNameKey]];
    
    if ([[_albumData objectForKey:kLastPhotoKey] isKindOfClass:[UIImage class]]) {
        [cell setImage:[_albumData objectForKey:kLastPhotoKey]];
    } else {
        [cell setImage:nil];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *_albumData = [albums objectAtIndex:indexPath.row];
    
    ALAssetsGroup *group = [_albumData objectForKey:kAlassetsGroupKey];
//    NSLog(@"%@, %d", [group valueForProperty:ALAssetsGroupPropertyName], [group numberOfAssets]);
    
    DTPhotoViewController *photoView = [DTPhotoViewController photoViewWithAssetsGroup:group mode:currentMode];
    
    [self.navigationController pushViewController:photoView animated:YES];
}

@end
