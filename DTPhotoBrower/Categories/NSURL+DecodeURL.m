//
//  NSURL+DecodeURL.m
//
//  Created by Darktt on 13/4/22.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "NSURL+DecodeURL.h"

@implementation NSURL (DecodeURL)

+ (id)decodeURLWithString:(NSString *)URLString
{
    NSString *decodeString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [[[NSURL alloc] initWithString:decodeString] autorelease];
    
    return URL;
}

@end
