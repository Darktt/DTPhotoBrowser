//
//  UITableView+TableView.m
//
//  Created by Darktt on 13/3/22.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "UITableView+TableView.h"

@implementation UITableView (TableView)

+ (id)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)tableViewStyle forTager:(id)tager
{
    UITableView *table = [[[UITableView alloc] initWithFrame:frame style:tableViewStyle] autorelease];
    
    [table setDataSource:(id<UITableViewDataSource>)tager];
    [table setDelegate:(id<UITableViewDelegate>)tager];
    
    return table;
}

@end
