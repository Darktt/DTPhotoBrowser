//
//  NSArray+AroundArray.m
//
//  Created by Darktt on 13/3/22.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "NSArray+AroundArray.h"

@implementation NSArray (AroundArray)

- (id)aroundObjectAtIndex:(NSInteger)index
{
    while (index < 0) {
        index += self.count;
    }
    
    NSUInteger aroundIndex = index % self.count;
    
    return [self objectAtIndex:aroundIndex];
}

@end
