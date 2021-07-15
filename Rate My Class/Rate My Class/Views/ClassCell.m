//
//  ClassCell.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import "ClassCell.h"
#import "ClassModel.h"

@implementation ClassCell

- (void)setClass:(ClassModel *)currClass {
    _currClass = currClass;

    self.className.text = currClass.code;
    self.overallRating.text = currClass.averageRating;
            
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

@end
