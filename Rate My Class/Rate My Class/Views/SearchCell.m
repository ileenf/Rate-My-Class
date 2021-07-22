//
//  SearchCell.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/14/21.
//

#import "SearchCell.h"
#import "ClassObject.h"

@implementation SearchCell

- (void)setClass:(ClassObject *)currClass {
    _currClass = currClass;

    self.classNameLabel.text = currClass.classCode;
    self.ratingLabel.text = currClass.overallRating;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
