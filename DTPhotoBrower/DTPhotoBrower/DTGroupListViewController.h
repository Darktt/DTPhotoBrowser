//
//  DTGroupListViewController.h
//  DTPhotoBrower
//
//  Created by Darktt on 2015/3/27.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTGroupListViewControllerDelegate;

@interface DTGroupListViewController : UIViewController

@property (readonly) id<DTGroupListViewControllerDelegate> target;

+ (instancetype)groupListWithTarget:(id<DTGroupListViewControllerDelegate>)target;

@end

@protocol DTGroupListViewControllerDelegate <NSObject>

- (void)groupListDidDismiss:(DTGroupListViewController *)groupList;

@end