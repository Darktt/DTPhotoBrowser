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

@interface DTPhotoViewController () <UITableViewDataSource, UITableViewDelegate>
{
    ALAssetsGroup *_group;
    NSArray *photos;
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
    
    _group = group;
    
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
    
    [self setView:tableView];
    
    NSMutableArray *_photos = [NSMutableArray array];
    
    ALAssetsGroupEnumerationResultsBlock groupEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result != nil) {
            
            // Get photo data only.
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                
                ALAssetRepresentation *representation = [result defaultRepresentation];
                
                UIImage *photo = [UIImage imageWithCGImage:[representation fullResolutionImage]];
                [_photos addObject:photo];
                
                NSLog(@"%@", [representation filename]);
            }
            
        } else {
            [photos release];
            photos = [_photos copy];
        }
    };
    
    [_group enumerateAssetsUsingBlock:groupEnumerationBlock];
}

- (void)dealloc
{
    [photos release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
