//
//  DTAssetConfig.h
//
//  Created by Darktt on 13/7/25.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

/* DTAlbumViewController asset filter mode */

// Show all assets
#define kALAssetsFilter [ALAssetsFilter allAssets]

// Show photo assets only
//#define kALAssetsFilter [ALAssetsFilter allPhotos]

// Show Video assets only
//#define kALAssetsFilter [ALAssetsFilter allVideos]


/* DTPhotoViewController asset filter mode */

// Show all assets
#define kGetAlassetType ![[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeUnknown]

// Show photo assets only
//#define kGetAlassetType [[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]

// Show video assets only
//#define kGetAlassetType [[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]