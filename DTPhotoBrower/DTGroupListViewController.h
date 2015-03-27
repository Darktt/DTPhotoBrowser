//
//  DTGroupListViewController.h
//  DTPhotoBrower
//
//  Created by EdenLi on 2015/3/27.
//  Copyright (c) 2015年 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTGroupListViewControllerDelegate;

@interface DTGroupListViewController : UIViewController

+ (instancetype)groupListWithTarget:(id<DTGroupListViewControllerDelegate>)target;

@end
