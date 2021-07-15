//
//  SearchCell.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/14/21.
//

#import "SearchCell.h"
#import "ClassModel.h"

@implementation SearchCell

- (void)setClass:(ClassModel *)currClass {
    _currClass = currClass;

    self.classNameLabel.text = currClass.code;
    self.ratingLabel.text = currClass.averageRating;
    
}

@end
