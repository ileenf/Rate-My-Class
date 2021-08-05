//
//  ClassCell.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import "ClassCell.h"
#import "ClassObject.h"

@implementation ClassCell

- (void)setClass:(ClassObject *)currClass withIndexPath:(NSIndexPath *)indexPath {
    _currClass = currClass;

    self.className.text = currClass.classCode;
    self.overallRating.text = currClass.overallRating;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView.layer setMasksToBounds:YES];
    [self.contentView.layer setBorderWidth:2];
    [self.contentView.layer setShadowOffset:CGSizeMake(-1, -1)];
    
    UIColor *color = [self getBorderColor:indexPath];
    [self.contentView.layer setBorderColor:color.CGColor];
    [self.contentView.layer setBackgroundColor:color.CGColor];
}

- (UIColor *)getBorderColor:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    NSInteger modulus = index % 9;
    float alphaValue = 0;;
    
    if (modulus == 0) {
        alphaValue = 0.05;
    } else {
        alphaValue = modulus * 0.1;
    }
    
    UIColor *color = [UIColor colorWithRed:0 green:0.2667 blue:0.8471 alpha:alphaValue];
    return color;
}

@end
