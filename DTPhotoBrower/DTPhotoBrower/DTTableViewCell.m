//
//  DTTableViewCell.m
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "Categories.h"
#import "DTTableViewCell.h"

@interface DTTableViewCell ()
{
    DTTableViewCellStyle cellStyle;
}

@end

@implementation DTTableViewCell

+ (id)tableCellWithStyle:(DTTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    DTTableViewCell *cell = [[[DTTableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier] autorelease];
    
    return cell;
}

- (id)initWithStyle:(DTTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    cellStyle = style;
    
    switch (cellStyle) {
        case DTTableViewCellStyleDefault:
            self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            break;
            
        case DTTableViewCellStyleValue1:
            self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
            break;
            
        case DTTableViewCellStyleValue2:
            self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
            break;
            
        case DTTableViewCellStyleSubtitle:
            self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
            break;
            
        default:
            self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            break;
    }
    
    if (self == nil) return nil;
    
    if (cellStyle == DTTableViewCellStyleBlack)
        [self setBlackColorStyle];
    else
        [self.imageView setImage:[UIImage imageNamed:@"EmtyPhotoNormalStyle.png"]];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBlackColorStyle
{
    UIView *cellBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [cellBackgroundView setOpaque:YES];
    [cellBackgroundView setBackgroundColor:[UIColor blackColor]];
    
    UIView *selectBgView = [[UIView alloc] initWithFrame:self.bounds];
    [selectBgView setOpaque:YES];
    [selectBgView setBackgroundColor:[UIColor togoBoxGreenColor]];
    
    [self setBackgroundView:cellBackgroundView];
    [self setSelectedBackgroundView:selectBgView];
    [cellBackgroundView release];
    [selectBgView release];
    
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.textLabel setTextColor:[UIColor whiteColor]];
    
//    [self.imageView setImage:[UIImage imageNamed:@"EmtyPhotoBlackStyle.png"]];
}

#pragma mark - Over Write Defaule Method

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    if (cellStyle == DTTableViewCellStyleBlack && accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        [super setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        UIImageView *disclosure = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Disclosure.png"]];
        
        [self setAccessoryView:disclosure];
        [disclosure release];
    } else {
        [super setAccessoryType:accessoryType];
        
        [self setAccessoryView:nil];
    }
}

- (void)setImage:(UIImage *)image
{
    if (image != nil) {
        [self.imageView setImage:image];
        
        return;
    }
    
    if (cellStyle == DTTableViewCellStyleBlack)
        [self.imageView setImage:[UIImage imageNamed:@"EmtyPhotoBlackStyle.png"]];
    else
        [self.imageView setImage:[UIImage imageNamed:@"EmtyPhotoNormalStyle.png"]];
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [selectedBackgroundView setBackgroundColor:selectedBackgroundColor];
    
    [self setSelectedBackgroundView:selectedBackgroundView];
    [selectedBackgroundView release];
}

- (UIColor *)selectedBackgroundColor
{
    return self.selectedBackgroundView.backgroundColor;
}

#pragma mark - Getter Method

- (DTTableViewCellStyle)cellStyle
{
    return cellStyle;
}

@end
