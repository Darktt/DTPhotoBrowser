//
//  NSString+String.m
//
//  Created by Darktt on 30/12/12.
//  Copyright (c) 2012 Darktt. All rights reserved.
//

#import "NSString+String.h"

@implementation NSString (String)

static NSArray *base16Symbols = nil;

+ (id)stringWithInteger:(NSInteger)integer
{
    NSString *string = [[[NSString alloc] initWithInteger:integer] autorelease];
    
    return string;
}

+ (id)stringWithFloat:(float)f numberOfDecimalPlaces:(NSUInteger)dP
{
    NSString *string = [[[NSString alloc] initWithFloat:f numberOfDecimalPlaces:dP] autorelease];
    
    return string;
}

- (id)initWithInteger:(NSInteger)integer
{
    self = [self initWithFormat:@"%d", integer];
    
    return self;
}

- (id)initWithFloat:(float)f numberOfDecimalPlaces:(NSUInteger)dP
{
    self = [self initWithFormat:@"%f", f];
    
    return self;
}

#pragma mark - Hex String to Integer Methods

- (void)setBase16Symbols
{
    if (base16Symbols == nil) {
        base16Symbols = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A", @"B", @"C", @"D", @"E", @"F"];
    }
}

- (NSInteger)base16ToIntegerWithString:(NSString *)string
{
    [self setBase16Symbols];
    
    return [base16Symbols indexOfObject:string];
}

- (long long)hexLongLongValue
{
    long long integer = 0.0f;
    
    for (NSInteger i = (self.length - 1); i >= 0; i--) {
        NSInteger j = self.length - i - 1;
        
        NSRange range = {i , 1};
        NSString *string = [self substringWithRange:range];
        
        double digit = [self base16ToIntegerWithString:[string uppercaseString]] * pow(16, j);

        integer += digit;
    }
    
    return integer;
}

- (NSInteger)hexIntegerValue
{
    NSNumber *hexNumber = [NSNumber numberWithLongLong:[self hexLongLongValue]];
    
    return [hexNumber integerValue];
}

@end
