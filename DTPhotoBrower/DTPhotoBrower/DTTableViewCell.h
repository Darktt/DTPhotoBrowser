//
//  DTTableViewCell.h
//  DTPhotoBrower
//
//  Created by Darktt on 13/4/11.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DTTableViewCellStyle)
{
    DTTableViewCellStyleDefault,  // Aka UITableViewCellStyleDefault
    DTTableViewCellStyleValue1,   // Aka UITableViewCellStyleValue1
    DTTableViewCellStyleValue2,   // Aka UITableViewCellStyleValue2
    DTTableViewCellStyleSubtitle, // Aka UITableViewCellStyleSubtitle
    DTTableViewCellStyleBlack     // Custom table view cell style of black color style
};

@interface DTTableViewCell : UITableViewCell

@property (assign, readonly) DTTableViewCellStyle cellStyle;
@property (nonatomic, retain) UIImage *image NS_AVAILABLE_IOS(2_0);
@property (nonatomic, retain) UIColor *selectedBackgroundColor;

+ (id)tableCellWithStyle:(DTTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithStyle:(DTTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
