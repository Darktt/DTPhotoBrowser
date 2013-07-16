//
//  UILabel+Label.m
//
//  Created by Darktt on 13/4/23.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "UILabel+Label.h"

@implementation UILabel (Label)

+ (id)labelWithFrame:(CGRect)frame
{
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    
    return label;
}

+ (id)labelWithFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    [label setText:text];
    
    return label;
}

- (void)alignTop
{
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
}

- (void)alignBottom
{
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
}

@end
