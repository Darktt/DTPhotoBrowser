//
//  NSArray+AroundArray.h
//
//  Created by Darktt on 13/3/22.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NSArrayEnumerateBlock) (id obj, NSUInteger idx, BOOL *stop);

@interface NSArray (AroundArray)

- (id)aroundObjectAtIndex:(NSInteger)index;

@end
